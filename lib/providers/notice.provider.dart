import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
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

    final notice = NoticeModel(
      title: title,
      body: body,
      mainImage: "",
      id: docRef.id,
      dateTime: DateTime.now(),
    );

    try {
      // create dummy notice
      await docRef.set({...notice.toJson()});

      // upload images to cloudinary
      final response = await CloudinarySdk.cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: imagePath.path,
          resourceType: CloudinaryResourceType.image,
          folder: "notice",
          fileName: docRef.id,
          progressCallback: (count, total) {
            debugPrint("Uploading... $count/$total");
          },
        ),
      );

      if (response.isSuccessful) {
        final profileImage = response.secureUrl;

        final updateNotice = NoticeModel(
          title: title,
          body: body,
          id: docRef.id,
          mainImage: profileImage.toString(),
          dateTime: DateTime.now(),
        );

        // create dummy notice
        await docRef.update({...updateNotice.toJson()});
        SendPushNotification.sendNotificationUsingApi(
          topic: AppData.allUserTopic,
          title: "Notice Alert",
          body: "You have a new notice. Check it out!",
          data: {
            "post_id": docRef.id,
            "user_id": userId,
            "notice_id": docRef.id,
          },
        );
        notifyListeners();
      } else {
        notifyListeners();
        return false;
      }

      return true;
    } catch (e) {
      print('Error creating comment: $e');
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
      print('Error fetching notice by ID: $e');
      return null;
    }
  }

// delete notice
  Future<bool> deleteNotice(String noticeID) async {
    try {
      await _firestore.collection('notice').doc(noticeID).delete();
      return true;
    } catch (e) {
      print('Error deleting notice: $e');
      return false;
    }
  }
}
