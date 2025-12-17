import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.update.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/services/permission.services.dart';
import 'package:meditation_center/presentation/pages/home/home.page.dart';
import 'package:meditation_center/presentation/pages/item menus/pages/item.menu.page.dart';
import 'package:meditation_center/presentation/pages/notice/page/notice.page.dart';
import 'package:meditation_center/presentation/pages/upcoming program/page/upcoming.program.dart';
import 'package:meditation_center/presentation/pages/upload/page/upload.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/screens/main/navigation_setup/nav.items.dart';
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
  final String? cUSer = FirebaseAuth.instance.currentUser?.uid;

  int _currentIndex = 0;
  bool isAvailable = false;

  StreamSubscription<List<dynamic>>? _postsSubscription;

  final List<Widget> _pages = const [
    HomePage(),
    NoticePage(),
    UploadPage(),
    UpcomingProgram(),
    ItemMenuPage(),
  ];

  @override
  void initState() {
    super.initState();
    PermissionServices.requestPermissions();
    listeners();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      subscribeOnce();
      await checkIfPostAvailableOrNot();
      updateUserLastLogin();
      AppUpdate().checkAppUpdate(context);
    });
  }

  @override
  void dispose() {
    _postsSubscription?.cancel();
    super.dispose();
  }

  Future<void> updateUserLastLogin() async {
    Provider.of<UserProvider>(context, listen: false).updateUserLastLogin();
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
      }
    });
  }

  Future<void> subscribeOnce() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final id = currentUser.uid;

    final provider = Provider.of<UserProvider>(context, listen: false);

    try {
      final user = await provider.getUserById(id);

      if (user.isAdmin) {
        final preference = await SharedPreferences.getInstance();
        final alreadySubscribed =
            preference.getBool('subscribed_admins') ?? false;

        if (!alreadySubscribed) {
          await FirebaseMessaging.instance.subscribeToTopic('admins');
          await preference.setBool('subscribed_admins', true);
        }
      }
    } catch (e) {
      debugPrint("Subscription error: $e");
    }
  }

  Future<void> checkIfPostAvailableOrNot() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final id = currentUser.uid;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    try {
      final user = await userProvider.getUserById(id);

      if (user.isAdmin) {
        _postsSubscription = postProvider.unapprovedPostsStream().listen((
          posts,
        ) {
          setState(() {
            isAvailable = posts.isNotEmpty;
          });
        });
      }
    } catch (e) {
      debugPrint("Post availability check failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meditation Center',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                'CMC-UAE',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (isAvailable)
            IconButton(
              onPressed: () {
                context.push('/approve');
              },
              icon: const FaIcon(FontAwesomeIcons.lock, size: 22),
              color: AppColors.whiteColor,
            ),
          IconButton(
            onPressed: () {
              if (cUSer != null) {
                context.push('/profile', extra: cUSer);
              }
            },
            icon: SvgPicture.asset(
              "assets/svg/user.svg",
              colorFilter: ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
              width: 28,
              height: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: SvgPicture.asset(
              "assets/svg/settings.svg",
              colorFilter: ColorFilter.mode(
                AppColors.whiteColor,
                BlendMode.srcIn,
              ),
              width: 28,
              height: 28,
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1.5, color: AppColors.primaryColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: NavItems(
                currentIndex: _currentIndex,
                onTap: (i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
