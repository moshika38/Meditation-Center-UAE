import 'dart:convert';
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

    // print response
    if (response.statusCode == 200) {
      print("Push Notification sent successfully");
      print("Response: ${response.body}");
    } else {
      print("Failed to send Push notification");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  }
}
