import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionServices {
  /// Request notification & photo/video permissions
  static Future<bool> requestPermissions() async {
    try {
      // Notification permission (iOS only)
      if (await Permission.notification.request().isDenied) {
        debugPrint("Notification permission denied");
      }

      // Storage / Photos / Media (Android & iOS)
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,     // iOS photo library
        Permission.videos,     // iOS video library (if needed)
        Permission.storage,    // Android storage
      ].request();

      // Check if all permissions are granted
      bool allGranted = statuses.values.every((status) => status.isGranted);

      if (!allGranted) {
        debugPrint("Some permissions are denied");
      }

      return allGranted;
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
      return false;
    }
  }
}
