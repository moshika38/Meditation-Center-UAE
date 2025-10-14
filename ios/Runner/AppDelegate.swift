import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "app.channel.shared.data"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    // Setup for iOS 10+ notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // 🔹 Add MethodChannel for sharing
    if let controller = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
      
      methodChannel.setMethodCallHandler { call, result in
        if call.method == "share" {
          if let args = call.arguments as? [String: Any],
             let text = args["text"] as? String,
             let url = args["url"] as? String? {

              // Combine text + url
              let items: [Any] = [text + (url ?? "")]
              let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
              
              // For iPad support
              activityVC.popoverPresentationController?.sourceView = controller.view
              
              controller.present(activityVC, animated: true, completion: nil)
              result(nil)
          } else {
              result(FlutterError(code: "INVALID_ARGS", message: "Missing text or url", details: nil))
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
