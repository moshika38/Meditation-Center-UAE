import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/firebase/firebase_options.dart';
import 'package:meditation_center/core/routing/app.routing.dart';
import 'package:meditation_center/core/theme/app.theme.dart';
import 'package:meditation_center/providers/comment.provider.dart';
import 'package:meditation_center/providers/events.provider.dart';
import 'package:meditation_center/providers/notice.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

// Firebase Messaging Background Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 BG Message Data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load env file
  await dotenv.load(fileName: ".env");

  // Initializing Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initializing notification
  await LocalNotification().initialize();

  // Setting background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Get verification status before running the app
  final user = FirebaseAuth.instance.currentUser;
  await user?.reload();
  final bool isUserVerified = user != null
      ? await UserProvider().isUserVerifiedInFirestore(user.uid)
      : false;

  // re-subscribe to topics
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 Token refreshed: $newToken");
    await FirebaseMessaging.instance.subscribeToTopic('all_users');
  });

  runApp(
    // MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProxyProvider<UserProvider, PostWithUserDataProvider>(
          create: (context) =>
              PostWithUserDataProvider(context.read<UserProvider>()),
          update: (context, userProvider, postWithUserDataProvider) =>
              PostWithUserDataProvider(userProvider),
        ),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
      ],
      child: MyApp(isVerifyUser: isUserVerified),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isVerifyUser;
  const MyApp({
    super.key,
    required this.isVerifyUser,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mediation Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouting(
        isVerify: isVerifyUser,
      ).appRouter,
      builder: EasyLoading.init(),
    );
  }
}
