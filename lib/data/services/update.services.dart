import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_center/data/models/update.model.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AppUpdateModel> getAppUpdate() async {
    try {
      final docSnapshot =
          await _firestore.collection('version').doc('apv').get();

      if (docSnapshot.exists) {
        return AppUpdateModel.fromMap(docSnapshot.data()!);
      } else {
        return AppUpdateModel(
            appVersion: "0",
            appLink: 'Document does not exist');
      }
    } catch (e) {
      return AppUpdateModel(appVersion: "0", appLink: 'Error: $e');
    }
  }

  Future<void> launchURL(String link) async {
    final Uri url = Uri.parse(link);

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
