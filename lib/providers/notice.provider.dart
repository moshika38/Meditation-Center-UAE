import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/core/notifications/send.push.notification.dart';
import 'package:meditation_center/data/cloudinary/cloudinary_api.dart';
import 'package:meditation_center/data/models/notice.model.dart';

class NoticeProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // addNewNotice
  Future<bool> addNewNotice(
    String title,
    String body,
    XFile imagePath,
  ) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final docRef = _firestore.collection('notice').doc();

    try {
      // upload images to cloudinary
      final response = await CloudinarySdk.cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imagePath.path,
          resourceType: CloudinaryResourceType.image,
          folder: "notice",
          fileName: docRef.id,
          progressCallback: (byteCount, total) {
            debugPrint("Uploading... $byteCount/$total");
          },
        ),
      );

      if (response.isSuccessful) {
        final noticeImageUrl = response.secureUrl;

        final notice = NoticeModel(
          title: title,
          body: body,
          id: docRef.id,
          mainImage: noticeImageUrl.toString(),
          dateTime: DateTime.now(),
        );

        // create notice in firestore
        await docRef.set({...notice.toJson()});

        SendPushNotification.sendNotificationUsingApi(
          topic: AppData.allUserTopic,
          title: "නව දැන්වීමක් 📢",
          body: "ඔබට නව දැන්වීමක් ඇත. දැන්ම බලන්න.",
          data: {
            "user_id": userId,
             "screen": "notice",
            "id": docRef.id,
          },
        );
        notifyListeners();
      } else {
        // send local notification for failed upload
        await LocalNotification().showNotification(
          docRef.id.hashCode,
          "🚫 Failed",
          " Your notice failed to upload ! try again later",
        );
        notifyListeners();
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error creating comment: $e');
      notifyListeners();
      return false;
    }
  }

  // get all notices
  Stream<List<NoticeModel>> getAllNotices() {
    return _firestore.collection('notice').snapshots().map((querySnapshot) {
      final notices = querySnapshot.docs
          .map((doc) => NoticeModel.fromJson(doc.data()))
          .toList();

      notices.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return notices;
    });
  }

  // Get notice by ID
  Future<NoticeModel?> getNoticeByID(String noticeID) async {
    try {
      final doc = await _firestore.collection('notice').doc(noticeID).get();

      if (doc.exists) {
        return NoticeModel.fromJson({
          ...doc.data()!,
          'id': doc.id,
        });
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching notice by ID: $e');
      return null;
    }
  }

// delete notice
  Future<bool> deleteNotice(String noticeID) async {
    try {
      await _firestore.collection('notice').doc(noticeID).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting notice: $e');
      return false;
    }
  }
}
