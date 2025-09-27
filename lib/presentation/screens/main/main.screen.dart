import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/services/permission.services.dart';
import 'package:meditation_center/data/services/update.services.dart';
import 'package:meditation_center/presentation/components/update.banner.dart';
import 'package:meditation_center/presentation/pages/item%20menus/item.menu.page.dart';
import 'package:meditation_center/presentation/pages/home/home.page.dart';
import 'package:meditation_center/presentation/pages/notice/page/notice.page.dart';
import 'package:meditation_center/presentation/pages/upcoming%20program/upcoming.program.dart';
import 'package:meditation_center/presentation/pages/upload/page/upload.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cUSer = FirebaseAuth.instance.currentUser!.uid;
  validateUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      context.push('/login');
    }
  }

  Future<void> checkUpdate() async {
    final update = await UpdateServices().getAppUpdate();

    print("App Version: ${update.appVersion}");
    final currentV = AppData.appVersion;
    if (update.appVersion > currentV) {
      print("Update Available");
      UpdateBanner.showUpdateBanner(context, () {
        UpdateServices().launchURL(update.appLink);
      });
    }
  }

  Future<void> subscribeToAllUserTopic() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = await provider.getUserById(id);

    if (user.allowNotification == true) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.subscribeToTopic('all_users');
      print("🛑  Subscribed to all_users topic");
    }
  }

  void listeners() {
    // 🔹 Foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final cUser = FirebaseAuth.instance.currentUser;

      final notificationUserId = message.data['user_id'];
      final postId = message.data['post_id'];

      if (cUser != null && cUser.uid != notificationUserId) {
        LocalNotification().showNotification(
          int.tryParse(postId) ?? 0,
          message.notification?.title ?? "No Title",
          message.notification?.body ?? "No Body",
        );
      } else {
        print("👋 Notification is from current user");
      }
    });

    // 🔹 Terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("📩 App opened from terminated by notification: ${message.data}");
      }
    });
    // background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📩 App opened from background by notification: ${message.data}");
    });
  }

  @override
  void initState() {
    super.initState();
    // validate User
    validateUser();
    // check update
    checkUpdate();
    // request permissions
    PermissionServices.requestPermissions();
    // subscribe to all users topic
    subscribeToAllUserTopic();
    // setup  listeners
    listeners();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(milliseconds: 500),
      length: 5,
      child: Builder(
        builder: (BuildContext innerContext) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Mediation Center',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.push('/profile', extra: cUSer);
                  },
                  icon: Icon(Icons.account_circle),
                  color: AppColors.whiteColor,
                  iconSize: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      context.push('/settings');
                    },
                    icon: Icon(Icons.settings),
                    color: AppColors.whiteColor,
                    iconSize: 30,
                  ),
                ),
              ],
              bottom: const TabBar(
                labelColor: AppColors.whiteColor,
                dividerColor: AppColors.primaryColor,
                automaticIndicatorColorAdjustment: true,
                unselectedLabelColor: AppColors.secondaryColor,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  Tab(icon: Icon(Icons.home_rounded, size: 25)),
                  Tab(icon: Icon(Icons.swap_vertical_circle_sharp, size: 25)),
                  Tab(icon: Icon(Icons.add_circle_rounded, size: 25)),
                  Tab(icon: Icon(Icons.assignment_outlined, size: 25)),
                  Tab(icon: Icon(Icons.event_repeat, size: 25)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // HomePage
                HomePage(),
                // notice page
                NoticePage(),

                // PostPage
                UploadPage(),

                // BookingPage
                ItemMenuPage(),

                // NotificationPage
                UpcomingProgram(),
              ],
            ),
          );
        },
      ),
    );
  }
}
