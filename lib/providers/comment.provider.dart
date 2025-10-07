import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/data/models/comment.model.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

// add new comment

  Future<bool> addNewComment(
    String postID,
    String userID,
    String body,
  ) async {
    final docRef = _firestore.collection('comment').doc();

    final comment = CommentModel(
      id: docRef.id,
      postID: postID,
      userID: userID,
      body: body,
      dateTime: DateTime.now(),
    );

    try {
      await docRef.set({...comment.toJson()});
      updateComment(postID, docRef.id, true);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error creating comment: $e');
      notifyListeners();
      return false;
    }
  }

  /// Fetch comments for a post sorted by dateTime (latest first)
  Stream<List<CommentModel>> getCommentsByPostId(String postID) {
    return _firestore
        .collection('comment')
        .where('postID', isEqualTo: postID)
        .snapshots()
        .map((querySnapshot) {
      final comments = querySnapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();

      // Sort by dateTime descending
      comments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return comments;
    });
  }

  /// update comment count
  Future<void> updateComment(
      String postId, String commentID, bool isAdd) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final comment = data['comments'] ?? 0;
      if (isAdd) {
        transaction.update(postRef, {
          'comments': comment + 1,
          'comments_id': FieldValue.arrayUnion([commentID]),
        });
      } else {
        transaction.update(postRef, {
          'comments': comment - 1,
          'comments_id': FieldValue.arrayRemove([commentID]),
        });
      }
    });
  }


  // delete comment
  Future<void> deleteComment(String postID,String commentID) async {
    final docRef = _firestore.collection('comment').doc(commentID);
    await docRef.delete();
    updateComment(postID, commentID, false);
  }

  
}
