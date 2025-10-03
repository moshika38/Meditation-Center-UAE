import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/presentation/pages/account%20settings/account.settings.dart';
import 'package:meditation_center/presentation/pages/approve%20posts/approve.posts.page.dart';
import 'package:meditation_center/presentation/pages/notice/add%20notice/add.notice.dart';
import 'package:meditation_center/presentation/pages/notifications%20settings/notifications.settings.dart';
import 'package:meditation_center/presentation/pages/comments/comment.page.dart';
import 'package:meditation_center/presentation/pages/help%20and%20supports/help.and.support.dart';
import 'package:meditation_center/presentation/pages/notice/notice%20viewer/notice.viewer.dart';
import 'package:meditation_center/presentation/pages/home/post%20viewer/post.viewer.dart';
import 'package:meditation_center/presentation/pages/social%20media/social.media.page.dart';
import 'package:meditation_center/presentation/screens/auth/create.screen.dart';
import 'package:meditation_center/presentation/screens/auth/forgot.password.dart';
import 'package:meditation_center/presentation/screens/auth/login.screen.dart';
import 'package:meditation_center/presentation/screens/auth/verify.screen.dart';
import 'package:meditation_center/presentation/screens/main/main.screen.dart';
import 'package:meditation_center/presentation/screens/profile/user.profile.dart';
import 'package:meditation_center/presentation/screens/settings/settings.screen.dart';
import 'package:meditation_center/presentation/screens/splash/splash.screen.dart';
import 'package:meditation_center/presentation/screens/terms/terms.screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouting {
  final bool isVerify;
  final int duration = 100;
  late final GoRouter appRouter;

  AppRouting({required this.isVerify}) {
    appRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: FirebaseAuth.instance.currentUser != null
          ? (isVerify ? '/main' : '/verify')
          : '/',

      // initialLocation: '/profile',
      routes: [
        _route(
          '/',
          'splash',
          false,
          SplashScreen(),
          duration,
        ),
        _route(
          '/login',
          'login',
          false,
          LoginScreen(),
          duration,
        ),
        _route(
          '/create',
          'create',
          false,
          CreateScreen(),
          duration,
        ),
        _route(
          '/forgot',
          'forgot',
          false,
          ForgotPassword(),
          duration,
        ),
        _route(
          '/verify',
          'verify',
          false,
          VerifyScreen(),
          duration,
        ),
        _route(
          '/main',
          'main',
          false,
          MainScreen(),
          duration,
        ),
        _route(
          '/settings',
          'settings',
          false,
          SettingsScreen(),
          duration,
        ),
        _route(
          '/account_settings',
          'account_settings',
          false,
          AccountSettings(),
          duration,
        ),
        _route(
          '/notifications',
          'notifications',
          false,
          NotificationsSettings(),
          duration,
        ),
        _route(
          '/help_and_support',
          'help_and_support',
          false,
          HelpAndSupport(),
          duration,
        ),
        // no - animation
        GoRoute(
          path: "/profile",
          name: "profile",
          builder: (context, state) {
            final userID = state.extra as String;
            return UserProfile(userId: userID);
          },
        ),
        // no - animation
        GoRoute(
          path: "/terms",
          name: "terms",
          builder: (context, state) {
            return TermsAndConditionsPage();
          },
        ),
        // no - animation
        GoRoute(
          path: "/approve",
          name: "approve",
          builder: (context, state) {
            return ApprovePostsPage();
          },
        ),
        // no - animation
        GoRoute(
          path: "/viewer",
          name: "viewer",
          builder: (context, state) {
            final imagesList = state.extra as List<String>;
            return PostViewer(imagesList: imagesList);
          },
        ),
        // no - animation
        GoRoute(
          path: "/comment",
          name: "comment",
          builder: (context, state) {
            final postID = state.extra as String;
            return CommentPage(postID: postID);
          },
        ),
        // no - animation
        GoRoute(
          path: "/addNotice",
          name: "addNotice",
          builder: (context, state) {
            return AddNotice();
          },
        ),
        // no - animation
        GoRoute(
          path: "/noticeViewer",
          name: "noticeViewer",
          builder: (context, state) {
            final noticeID = state.extra as String;
            return NoticeViewer(
              noticeID: noticeID,
            );
          },
        ),
        // no - animation
        GoRoute(
          path: "/socialMedia",
          name: "socialMedia",
          builder: (context, state) {
            return SocialMediaPage();
          },
        ),
      ],
    );
  }
}

GoRoute _route(
  String path,
  String name,
  bool isRightSlide,
  Widget page,
  int duration,
) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: page,
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //  const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;

        final tween = Tween(
                begin: isRightSlide ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
                end: end)
            .chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
