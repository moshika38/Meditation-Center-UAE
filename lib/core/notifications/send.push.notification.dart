import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meditation_center/core/notifications/get.service.key.dart';

class SendPushNotification {
  static Future<void> sendNotificationUsingApi({
    required String? title,
    required String? body,
    required String? topic,
    required Map<String, dynamic>? data,
  }) async {
    String serviceKey = await GetServiceKey().getServiceKey();

    String url =
        "https://fcm.googleapis.com/v1/projects/meditation-center-44aad/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serviceKey',
    };

    Map<String, dynamic> message = {
      "message": {
        "topic": topic,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data
      },
    };

    // hit api

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    // debugPrint response
    if (response.statusCode == 200) {
      debugPrint("Push Notification sent successfully");
      debugPrint("Response: ${response.body}");
    } else {
      debugPrint("Failed to send Push notification");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");
    }
  }
}
