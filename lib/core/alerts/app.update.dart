import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdate {
  void checkAppUpdate(BuildContext context) async {
    final data = await getAppVersionInfo();
    final info = await PackageInfo.fromPlatform();

    if (data != null) {
      String version = data['version'];
      int code = data['code'];
      String android = data['android'];
      String ios = data['ios'];
      if (info.version != version && int.parse(info.buildNumber) < code) {
        showAppUpdatePopup(context, android, ios);
      }
    }
  }

  // check app version from firestore
  Future<Map<String, dynamic>?> getAppVersionInfo() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('about')
          .doc('0')
          .get();

      if (doc.exists) {
        return {
          'version': doc['version'],
          'code': doc['code'],
          'android': doc['android'],
          'ios': doc['ios'],
        };
      }
    } catch (e) {
      print('Error getting version info: $e');
    }
    return null;
  }
}

// update banner

void showAppUpdatePopup(BuildContext context, String android, String ios) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Update Available',
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'A new version of the app is available. Please update to continue.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              launchStore(android, ios);
            },
            child: Text(
              'Update',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.whiteColor),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> launchStore(String android, String ios) async {
  Uri url;

  if (Platform.isAndroid) {
    url = Uri.parse(android);
  } else if (Platform.isIOS) {
    url = Uri.parse(ios);
  } else {
    throw Exception('Unsupported platform');
  }

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
