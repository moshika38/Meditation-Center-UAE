import 'dart:io';

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
    bool isReel,
    List<XFile> imageList,
  ) async {
    // reset upload progress
    isDone = false;
    uploadProgress = 0.0;
    final docRef = _firestore.collection('posts').doc();

    try {
      // // create dummy post
      // await docRef.set({...post.toJson()});

      uploadProgress = 0.0;
      notifyListeners();

      // upload images to cloudinary
      List<String> cloudinaryUrlList = [];

      if (isReel) {
        String? videoUrl =
            await uploadSingleVideo(imageList.first, userId, docRef.id);
        if (videoUrl != null) {
          cloudinaryUrlList = [videoUrl];
        }
      } else {
        cloudinaryUrlList = await uploadImages(imageList, userId, docRef.id);
      }

      if (cloudinaryUrlList.isEmpty) {
        // send local notification for failed upload
        await LocalNotification().showNotification(
          docRef.id.hashCode,
          "🚫 Failed",
          " Upload failed ! try again later",
        );
        return false;
      } else {
        final userID = FirebaseAuth.instance.currentUser?.uid;
        // create post with image urls
        final post = PostModel(
          id: docRef.id,
          description: des,
          userId: userId,
          userName: name,
          dateTime: DateTime.now(),
          assetsUrls: cloudinaryUrlList,
          likes: 0,
          comments: 0,
          commentsIds: [],
          likedUsersIds: [],
          isApproved: isAdmin,
          isReel: isReel,
        );

        await docRef.set({...post.toJson()});

        // send local notification
        await LocalNotification().showNotification(
          docRef.id.hashCode,
          "✔️ Completed 100%",
          "Successfully uploaded !  ${!isAdmin ? "Wait for admin approval" : ""}",
        );
        // Send push notification
        SendPushNotification.sendNotificationUsingApi(
          topic: isAdmin ? AppData.allUserTopic : AppData.adminTopic,
          title: isAdmin ? "නව පළ කිරීමක් 🔔" : "ඔබේ ක්‍රියාමාර්ගය අවශ්‍යයි 🚨",
          body: "'$name' විසින් අලුත් පළ කිරීමක් කරන ලදී...",
          data: {
            "user_id": userID,
            "screen": "home",
            "id": docRef.id,
          },
        );
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error creating post: $e');
      notifyListeners();
      return false;
    }
  }

// upload video to cloudinary
  Future<String?> uploadSingleVideo(
    XFile videoFile,
    String userID,
    String postsID,
  ) async {
    try {
      final response = await CloudinarySdk.cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: videoFile.path,
          resourceType: CloudinaryResourceType.video,
          folder: "videos/$postsID",
          fileName: "${userID}_${DateTime.now().millisecondsSinceEpoch}",
          progressCallback: (byteCount, total) async {
            double progress = (byteCount / total) * 100;

            uploadProgress = progress;
            notifyListeners();

            await LocalNotification().showProgressNotification(
              id: postsID.hashCode,
              title: "Uploading Video...",
              body: "${progress.toStringAsFixed(0)}% completed",
              progress: progress.toInt(),
            );
          },
        ),
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        debugPrint("Cloudinary upload failed: ${response.error}");
        return null;
      }
    } catch (e) {
      debugPrint("Video upload failed: $e");
      return null;
    }
  }

// upload images to cloudinary
  Future<List<String>> uploadImages(
    List<XFile> imageList,
    String userID,
    String postsID,
    // bool isAdmin,
  ) async {
    List<String> uploadedUrls = [];

    try {
      uploadProgress = 0.0;
      isDone = false;
      notifyListeners();

      // total bytes of all files
      int totalBytesAllFiles = 0;
      for (var f in imageList) {
        totalBytesAllFiles += File(f.path).lengthSync();
      }

      int uploadedBytes = 0; // track uploaded bytes

      // loop
      for (int index = 0; index < imageList.length; index++) {
        XFile file = imageList[index];
        int fileTotal = File(file.path).lengthSync();

        final response = await CloudinarySdk.cloudinary.uploadResource(
          CloudinaryUploadResource(
            filePath: file.path,
            resourceType: CloudinaryResourceType.image,
            folder: "posts/$postsID",
            fileName:
                "${userID}_${DateTime.now().millisecondsSinceEpoch}_$index",
            progressCallback: (byteCount, total) async {
              // total uploaded = already finished files + current file progress
              int currentUploaded = uploadedBytes + byteCount;
              double overallProgress =
                  (currentUploaded / totalBytesAllFiles) * 100;

              uploadProgress = overallProgress;
              notifyListeners();

              await LocalNotification().showProgressNotification(
                id: postsID.hashCode,
                title: "Uploading...",
                body: "${overallProgress.toStringAsFixed(0)}% completed",
                progress: overallProgress.toInt(),
              );
            },
          ),
        );

        if (response.isSuccessful) {
          uploadedUrls.add(response.secureUrl!);
        } else {
          debugPrint("Cloudinary upload failed for image $index: ${response.error}");
        }

        // mark file as fully uploaded
        uploadedBytes += fileTotal;
      }

      // final 100% notification
      uploadProgress = 100;
      isDone = true;
      notifyListeners();
    } catch (e) {
      isDone = true;
      notifyListeners();
      debugPrint("Upload failed: $e");

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
      debugPrint("Error deleting post = $e");
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
