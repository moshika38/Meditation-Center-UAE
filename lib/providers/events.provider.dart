import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/send.push.notification.dart';
import 'package:meditation_center/data/models/event.model.dart';

class EventsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // add new event
  Future<bool> addNewEvent(
    String title,
    String time,
    String date,
    String? place,
    String? contact,
    bool isNotify,
  ) async {
    final docRef = _firestore.collection('events').doc();

    try {
      final event = EventModel(
        id: docRef.id,
        title: title,
        time: time,
        date: date,
        place: place ?? "",
        contact: contact ?? "",
        dateTime: DateTime.now(),
      );

      await docRef.set({...event.toJson()});
      if (isNotify) {
        SendPushNotification.sendNotificationUsingApi(
          topic: AppData.allUserTopic,
          title: "අලුත් වැඩසටහනක් 🪔",
          body: "දැන්ම කාලසටහන බලන්න, ඔබත් එක්වන්න.",
          data: {
            "user_id": userId,
            "screen": "events",
            "item_id": docRef.id,
          },
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // get all events
  Stream<List<EventModel>> getAllEvents() {
    return _firestore.collection('events').snapshots().map((querySnapshot) {
      final events = querySnapshot.docs
          .map((doc) => EventModel.fromJson(doc.data()))
          .toList();

      events.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
      return events;
    });
  }

  // delete event by id
  Future<bool> deleteEvent(String id) async {
    try {
      await _firestore.collection('events').doc(id).delete();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
