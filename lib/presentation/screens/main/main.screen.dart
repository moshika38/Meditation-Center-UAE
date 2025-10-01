import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/services/permission.services.dart';
import 'package:meditation_center/data/services/update.services.dart';
import 'package:meditation_center/presentation/components/update.banner.dart';
import 'package:meditation_center/presentation/pages/item%20menus/item.menu.page.dart';
import 'package:meditation_center/presentation/pages/home/home.page.dart';
import 'package:meditation_center/presentation/pages/notice/page/notice.page.dart';
import 'package:meditation_center/presentation/pages/upcoming%20program/page/upcoming.program.dart';
import 'package:meditation_center/presentation/pages/upload/page/upload.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> updateUserLastLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateUserLastLogin();
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

  void listeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final cUser = FirebaseAuth.instance.currentUser;

      final notificationUserId = message.data['user_id'] ?? '';
      final postId = message.data['item_id'] ?? '0';

      if (cUser != null && cUser.uid != notificationUserId) {
        LocalNotification().showNotification(
          int.tryParse(postId) ?? 0,
          message.notification?.title ?? "No Title",
          message.notification?.body ?? "No Body",
        );
      } else {
        print("👋 Notification is from current user or data missing");
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("📩 App opened from terminated by notification: ${message.data}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📩 App opened from background by notification: ${message.data}");
    });
  }

  Future<void> subscribeOnce() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = await provider.getUserById(id);

    if (user.isAdmin) {
      final prefs = await SharedPreferences.getInstance();
      final alreadySubscribed = prefs.getBool('subscribed_admins') ?? false;

      if (!alreadySubscribed) {
        await FirebaseMessaging.instance.subscribeToTopic('admins');
        await prefs.setBool('subscribed_admins', true);
      }
    }
  }

  bool isAvailable = false;
  Future<void> checkIfPostAvailableOrNot() async {
    final id = FirebaseAuth.instance.currentUser!.uid;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final user = await userProvider.getUserById(id);

    if (user.isAdmin) {
      postProvider.unapprovedPostsStream().listen((posts) {
        if (posts.isNotEmpty) {
          setState(() {
            isAvailable = true;
          });
        } else {
          setState(() {
            isAvailable = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // validate User
    validateUser();
    // request permissions
    PermissionServices.requestPermissions();
    // setup  listeners
    listeners();

    // async calls
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // check update
      checkUpdate();
      // subscribe to admin
      subscribeOnce();
      // check if post available
      checkIfPostAvailableOrNot();
      // update user last login
      updateUserLastLogin();
    });
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
                isAvailable
                    ? IconButton(
                        onPressed: () {
                          context.push('/approve');
                        },
                        icon: FaIcon(FontAwesomeIcons.lock, size: 23),
                        color: AppColors.whiteColor,
                        iconSize: 30,
                      )
                    : SizedBox.shrink(),
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
                  Tab(icon: Icon(Icons.home_rounded, size: 30)),
                  Tab(icon: FaIcon(FontAwesomeIcons.scroll, size: 22)),
                  Tab(icon: Icon(Icons.add_circle_rounded, size: 28)),
                  Tab(icon: FaIcon(FontAwesomeIcons.calendar, size: 22)),
                  Tab(icon: FaIcon(FontAwesomeIcons.listUl, size: 22)),
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

                // UpcomingProgram,
                UpcomingProgram(),

                // BookingPage
                ItemMenuPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}
