import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/connection/connection.checker.dart';
import 'package:meditation_center/connection/lost.connection.alert.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.data.card.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String cUser = FirebaseAuth.instance.currentUser!.uid;

  final ScrollController _scrollController = ScrollController();

  Future<List<PostWithUsersModel>>? _postsFuture;


  bool isAdmin = false;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();

    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAdminStatus();
    });

    FirebaseCrashlytics.instance.log("User opened Home Screen");
    FirebaseCrashlytics.instance.setCustomKey('screen', 'Home Screen');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void checkAdminStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final user = await userProvider.getUserById(cUser);
      if (user.isAdmin != isAdmin) {
        setState(() {
          isAdmin = user.isAdmin;
        });
      }
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current,
          reason: "Error in checkAdmin Firestore access");
      debugPrint("Firestore unavailable error: $e");
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await ConnectionChecker().checkConnection();

    if (isConnected != result) {
      setState(() {
        isConnected = result;
      });

      if (!result) {
        showLostConnectionAlert();
      }
    }
  }

  void _loadPosts() {
    final provider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);

    setState(() {
  _postsFuture = provider.getAllPosts();
});

  }

  void _loadData() {
    _checkConnectivity();
    _loadPosts();
  }

  Future<void> _refreshPosts() async {
    LoadingPopup.show("Refreshing posts...");

    try {
      await _checkConnectivity();
      _loadPosts();

      setState(() {});
    } catch (e) {
      AppTopSnackbar.showTopSnackBar(context, "Failed to refresh posts");
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current,
          reason: "Error during post refresh");
    } finally {
      EasyLoading.dismiss();
    }
  }

  void showLostConnectionAlert() {
    LostConnectionAlert.showAlert(context, onCheckAgain: () {
      _refreshPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return const PageLoader();
    }

    return RefreshIndicator(
      backgroundColor: AppColors.whiteColor,
      color: AppColors.primaryColor,
      onRefresh: _refreshPosts,
      child: FutureBuilder<List<PostWithUsersModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: PageLoader(),
            );
          }

          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              EasyLoading.dismiss();
              AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
            });
            return const Center(
              child: EmptyDataCard(title: "Error loading posts !"),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.dismiss();
          });

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: EmptyDataCard(title: "No posts yet!"));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onLongPress: () {
                  if (isAdmin) {
                    PopupWindow.showPopupWindow(
                      "Are you sure? you want to delete this post?if you delete this post, it will be gone forever",
                      "Yes, Delete",
                      context,
                      () {
                        LoadingPopup.show('Deleting...');
                        final postProvider =
                            Provider.of<PostProvider>(context, listen: false);
                        postProvider.deletePost(post.post.id);

                        _refreshPosts();
                        context.pop();
                        EasyLoading.dismiss();
                      },
                      () {
                        context.pop();
                      },
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                  ),
                  child: PostCard(
                    isReel: post.post.isReel,
                    removeFun: () {},
                    approvedFun: () {},
                    approvedPage: false,
                    isApproved: post.post.isApproved,
                    isCUser: post.user.uid == cUser,
                    isHome: true,
                    postData: post.post,
                    userData: post.user,
                    onDelete: () {},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
