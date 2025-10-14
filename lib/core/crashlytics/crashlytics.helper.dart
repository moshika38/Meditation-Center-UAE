import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsHelper {
  /// Call this when a new screen/page is opened
  static void logScreenView(String screenName) {
    FirebaseCrashlytics.instance.log("User opened $screenName");
    FirebaseCrashlytics.instance.setCustomKey('screen', screenName);
  }
}
