import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/core/notifications/send.push.notification.dart';
import 'package:meditation_center/data/cloudinary/cloudinary_api.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/services/posts.delete.services.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  double uploadProgress = 0.0;
  double totalUpload = 0.0;
  bool isDone = false;

  // create new post

  Future<bool> createNewPost(
    String des,
    String name,
    bool isAdmin,
    List<XFile> imageList,
  ) async {
    // reset upload progress
    isDone = false;
    uploadProgress = 0.0;
    final docRef = _firestore.collection('posts').doc();

    final post = PostModel(
      id: docRef.id,
      description: des,
      userId: userId,
      userName: name,
      dateTime: DateTime.now(),
      images: [],
      likes: 0,
      comments: 0,
      comment_ids: [],
      likedUsersIds: [],
      isApproved: isAdmin,
    );

    try {
      // create dummy post
      await docRef.set({...post.toJson()});

      uploadProgress = 0.0;
      notifyListeners();

      // upload images to cloudinary
      List<String> cloudinaryUrlList =
          await uploadImages(imageList, userId, docRef.id);
      if (cloudinaryUrlList.isEmpty) {
        return false;
      }
      // update post with image urls
      await docRef.update({'images': cloudinaryUrlList});

      // show notification
      LocalNotification().showNotification(
        docRef.id.hashCode,
        "Pending...",
        "Successfully uploaded. wait for admin approval",
      );
      // SendPushNotification
      SendPushNotification.sendNotificationUsingApi(
        topic: isAdmin ? AppData.allUserTopic : AppData.adminTopic,
        title: isAdmin ? "New Post" : "Action needed",
        body: "'$name' uploaded a new post",
        data: {
          "post_id": docRef.id,
          "user_id": userId,
        },
      );
      notifyListeners();

      return true;
    } catch (e) {
      print('Error creating post: $e');
      notifyListeners();
      return false;
    }
  }

  Future<List<String>> uploadImages(
    List<XFile> imageList,
    String userID,
    String postsID,
  ) async {
    List<String> uploadedUrls = [];

    try {
      uploadProgress = 0.0;
      isDone = false;
      notifyListeners();

      int totalFiles = imageList.length;
      int completedFiles = 0;

      // CloudinaryUploadResource list create
      final resources = imageList.asMap().entries.map(
        (entry) {
          int index = entry.key;
          XFile file = entry.value;

          return CloudinaryUploadResource(
            filePath: file.path,
            resourceType: CloudinaryResourceType.image,
            folder: "posts/$postsID",
            fileName:
                "${userID}_${DateTime.now().millisecondsSinceEpoch}_$index",
            progressCallback: (count, total) {
              // one file progress
              double fileProgress = count / total;

              // overall progress
              double overallProgress =
                  ((completedFiles + fileProgress) / totalFiles) * 100;

              uploadProgress = overallProgress;
              notifyListeners();
            },
          );
        },
      ).toList();

      // Upload resources
      List<CloudinaryResponse> responses =
          await CloudinarySdk.cloudinary.uploadResources(resources);

      // Handle responses
      for (var response in responses) {
        if (response.isSuccessful) {
          uploadedUrls.add(response.secureUrl!);
        }
        completedFiles++;
        uploadProgress = (completedFiles / totalFiles) * 100;
        notifyListeners();
      }

      if (completedFiles == totalFiles) {
        isDone = true;
        notifyListeners();
      }
    } catch (e) {
      isDone = true;
      notifyListeners();

      debugPrint(" Upload failed: $e");
      return [];
    }

    return uploadedUrls;
  }

  /// Like a post
  Future<void> likePost(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final likedUsers = List<String>.from(data['likedUsersIds'] ?? []);
      final likes = data['likes'] ?? 0;

      // If user already liked → do nothing
      if (likedUsers.contains(userId)) return;

      likedUsers.add(userId);

      transaction.update(postRef, {
        'likes': likes + 1,
        'likedUsersIds': likedUsers,
      });
      notifyListeners();
    });
  }

  /// Dislike a post (remove like)
  Future<void> dislikePost(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final likedUsers = List<String>.from(data['likedUsersIds'] ?? []);
      final likes = data['likes'] ?? 0;

      // If user hasn’t liked → do nothing
      if (!likedUsers.contains(userId)) return;

      likedUsers.remove(userId);

      transaction.update(postRef, {
        'likes': likes > 0 ? likes - 1 : 0,
        'likedUsersIds': likedUsers,
      });
      notifyListeners();
    });
  }

  /// Check if user has liked a post
  Future<bool> hasUserLikedPost(String postId, String userId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();

      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      final likedUsers = List<String>.from(data['likedUsersIds'] ?? []);

      return likedUsers.contains(userId);
    } catch (e) {
      return false;
    }
  }

  // delete post
  Future<bool> deletePost(String postId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      final snapshot = await postRef.get();

      if (!snapshot.exists) return false;

      final data = snapshot.data() as Map<String, dynamic>;
      final comments = List<String>.from(data['comments_id'] ?? []);

      WriteBatch batch = _firestore.batch();

      // delete all comments
      for (var commentId in comments) {
        final commentRef = _firestore.collection('comment').doc(commentId);
        batch.delete(commentRef);
      }

      // delete post itself
      batch.delete(postRef);

      // commit batch
      await batch.commit();
      await deleteFromCloudinary(postId);

      return true;
    } catch (e) {
      print("Error deleting post = $e");
      return false;
    }
  }

  Future<void> deleteFromCloudinary(String postsID) async {
    try {
      final delImages = await PostsDeleteServices.deleteFolderAssets(postsID);
      if (delImages) {
        final delFolder = await PostsDeleteServices.deleteEmptyFolder(postsID);
        if (delFolder) {
          debugPrint("Successfully deleted Cloudinary folder posts/$postsID");
        }
      }
    } catch (e) {
      debugPrint("Failed to delete Cloudinary folder posts/$postsID: $e");
    }
  }

  // has Unapproved Posts
 Stream<List<PostModel>> unapprovedPostsStream() {
  return _firestore
      .collection('posts')
      .where('isApproved', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return PostModel.fromJson(data);
        }).toList();
      });
}

}
