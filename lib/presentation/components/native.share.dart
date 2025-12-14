import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class NativeShare {
  static const platform = MethodChannel('app.channel.shared.data');

  static Future<void> share({required String? url}) async {
    try {
      // await platform.invokeMethod('share', {'text': text, 'url': url});
      SharePlus.instance.share(ShareParams(text: url));
    } on PlatformException catch (e) {
      print("Failed to share: '${e.message}'.");
    }
  }
}
