import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/providers/user.provider.dart'; // Added import

class PostWithUserDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProvider _userProvider; // Added UserProvider field

  PostWithUserDataProvider(this._userProvider); // Modified constructor

  Future<List<PostWithUsersModel>> getAllPosts() async {
    // 1. Fetch posts
    final postSnapshot = await _firestore.collection('posts').get();

    final posts = postSnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data);
    }).toList();

    // ✅ Filter only approved posts
    final approvedPosts = posts.where((p) => p.isApproved).toList();

    if (approvedPosts.isEmpty) return [];

    // 2. Collect unique userIds
    final userIds = approvedPosts.map((p) => p.userId).toSet().toList();

    // 3. Batch fetch users
    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', whereIn: userIds)
        .get();

    final users = {
      for (var doc in userSnapshot.docs)
        doc['uid']: UserModel.fromJson({...doc.data(), 'id': doc.id})
    };

    // 4. Map posts to PostWithUsers
    final postWithUsers = approvedPosts.map((post) {
      final user = users[post.userId];
      if (user != null) {
        return PostWithUsersModel(post: post, user: user);
      } else {
        return PostWithUsersModel(
          post: post,
          user: UserModel(
            id: null,
            name: 'Unknown',
            email: '',
            uid: '',
            profileImage: '',
            isAdmin: false,
            isVerify: false,
            allowNotification: false,
          ),
        );
      }
    }).toList();

    // 5. Sort by dateTime
    postWithUsers.sort((a, b) => b.post.dateTime.compareTo(a.post.dateTime));

    return postWithUsers;
  }

  // get all non approved posts
  Future<List<PostWithUsersModel>> getUnapprovedPosts() async {
    // 1. Fetch posts
    final postSnapshot = await _firestore.collection('posts').get();

    final posts = postSnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data);
    }).toList();

    // ❌ Filter only unapproved posts
    final unapprovedPosts = posts.where((p) => !p.isApproved).toList();

    if (unapprovedPosts.isEmpty) return [];

    // 2. Collect unique userIds
    final userIds = unapprovedPosts.map((p) => p.userId).toSet().toList();

    // 3. Batch fetch users
    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', whereIn: userIds)
        .get();

    final users = {
      for (var doc in userSnapshot.docs)
        doc['uid']: UserModel.fromJson({...doc.data(), 'id': doc.id})
    };

    // 4. Map posts to PostWithUsers
    final postWithUsers = unapprovedPosts.map((post) {
      final user = users[post.userId];
      if (user != null) {
        return PostWithUsersModel(post: post, user: user);
      } else {
        return PostWithUsersModel(
          post: post,
          user: UserModel(
            id: null,
            name: 'Unknown',
            email: '',
            uid: '',
            profileImage: '',
            isAdmin: false,
            isVerify: false,
            allowNotification: false,
          ),
        );
      }
    }).toList();

    // 5. Sort by dateTime
    postWithUsers.sort((a, b) => b.post.dateTime.compareTo(a.post.dateTime));

    return postWithUsers;
  }

// get post details by id
  Stream<PostWithUsersModel?> getPostDetailsById(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .asyncMap((docSnapshot) async {
      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data()!;
      final post = PostModel.fromJson(data);

      // Fetch user using UserProvider
      final user = await _userProvider.getUserById(post.userId);

      return PostWithUsersModel(post: post, user: user);
    });
  }

// getPostsByUserId
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      return posts;
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

// get approved posts by user id

  Future<List<PostWithUsersModel>> getApprovedPostsByUserId(
      String userId) async {
    // 1. Fetch posts for the given userId
    final postSnapshot = await _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();

    // filter by isApproved == true
    final posts = postSnapshot.docs
        .map((doc) {
          final data = doc.data();
          return PostModel.fromJson(data);
        })
        .where((post) => post.isApproved == true)
        .toList();

    if (posts.isEmpty) return [];

    // 2. Fetch user (only one user, since all posts belong to this userId)
    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .get();

    UserModel user;
    if (userSnapshot.docs.isNotEmpty) {
      final uDoc = userSnapshot.docs.first;
      user = UserModel.fromJson({...uDoc.data(), 'id': uDoc.id});
    } else {
      user = UserModel(
        id: null,
        name: 'Unknown',
        email: '',
        uid: '',
        profileImage: '',
        isAdmin: false,
        isVerify: false,
        allowNotification: false,
      );
    }

    // 3. Map posts with the user
    final postWithUsers = posts.map((post) {
      return PostWithUsersModel(post: post, user: user);
    }).toList();

    // 4. Sort by dateTime (latest first)
    postWithUsers.sort((a, b) => b.post.dateTime.compareTo(a.post.dateTime));

    return postWithUsers;
  }

// approve post
  Future<bool> ApprovedPostByID(String postID) async {
    final docRef = _firestore.collection('posts').doc(postID);

    try {
      await docRef.update({
        'isApproved': true,
      });
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print('Error updating name: $e');
      return false;
    }
  }
}
