import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id;
  final String title;
  final String time;
  final String date;
  final String? place;
  final String? contact;
  final DateTime? dateTime;

  EventModel({
    required this.id,
    required this.title,
    required this.time,
    required this.date,
    this.place,
    this.contact,
    required this.dateTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      time: json['time'] as String,
      date: json['date'] as String,
      place: json['place'] as String?,
      contact: json['contact'] as String?,
      dateTime: (json['dateTime'] is Timestamp)
          ? (json['dateTime'] as Timestamp).toDate()
          : (json['dateTime'] as DateTime),
    );
  }

 

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'date': date,
      'place': place,
      'contact': contact,
      'dateTime': dateTime,
    };
  }
}
