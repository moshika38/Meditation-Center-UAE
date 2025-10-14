import 'package:flutter/services.dart';

class NativeShare {
  static const platform = MethodChannel('app.channel.shared.data');

  static Future<void> share({required String text, String? url}) async {
    try {
      await platform.invokeMethod('share', {'text': text, 'url': url});
    } on PlatformException catch (e) {
      print("Failed to share: '${e.message}'.");
    }
  }
}
