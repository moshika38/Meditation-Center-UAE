import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );

    await notificationPlugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'basic_channel_id',
        'basic channel',
        channelDescription: 'Notification channel for basic messages',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification(int id, String title, String body) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  ///upload progress show notification
  NotificationDetails progressNotificationDetails({
    required int progress,
    required int maxProgress,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'upload_id',
        'upload channel',
        channelDescription: 'Notification channel for upload progress',
        importance: Importance.high,
        priority: Priority.high,
        showProgress: true,
        maxProgress: maxProgress,
        progress: progress,
        onlyAlertOnce: true,
        ongoing: true,
        autoCancel: false,
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.critical,
      ),
    );
  }

  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      progressNotificationDetails(progress: progress, maxProgress: 100),
    );
  }

  // Request permission for Android 13+ and iOS
  Future<void> requestPermission() async {
    // Android 13+
    final androidPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    // iOS
    final iosPlugin = notificationPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
