import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/notifications/send.push.notification.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/shimmer/post.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:provider/provider.dart';

class ApprovePostsPage extends StatefulWidget {
  const ApprovePostsPage({super.key});

  @override
  State<ApprovePostsPage> createState() => _ApprovePostsPageState();
}
class _ApprovePostsPageState extends State<ApprovePostsPage> {
  late Future<List<PostWithUsersModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadUnapprovedPosts();
  }

  void _loadUnapprovedPosts() {
    final provider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    _postsFuture = provider.getUnapprovedPosts();
  }

  Future<void> _refreshUnapprovedPosts() async {
    try {
      LoadingPopup.show("Refreshing posts...");
      _loadUnapprovedPosts();
      setState(() {});
    } catch (e) {
      EasyLoading.dismiss();
      // optional: show error snackbar here
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
        title: Text(
          'Approve Posts',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        onRefresh: _refreshUnapprovedPosts,
        child: FutureBuilder<List<PostWithUsersModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading posts"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PostShimmer();
            }

            final posts = snapshot.data ?? [];

            if (posts.isEmpty) {
              return const Center(
                child: EmptyAnimation(title: "No posts yet!"),
              );
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                  ),
                  child: PostCard(
                    isReel: post.post.isReel,
                    approvedPage: true,
                    postID: post.post.id,
                    isApproved: post.post.isApproved,
                    isHome: true,
                    isCUser: false,
                    onDelete: () {},
                    removeFun: () {
                      PopupWindow.showPopupWindow(
                        "Are you sure? you want to remove this post? This action cannot be undone.",
                        "Yes, Remove",
                        context,
                        () {
                          final postProvider = Provider.of<PostProvider>(
                              context,
                              listen: false);
                          context.pop();
                          LoadingPopup.show('Deleting...');
                          postProvider.deletePost(post.post.id);
                          EasyLoading.dismiss();
                          _refreshUnapprovedPosts(); // refresh after delete
                        },
                        () {
                          context.pop();
                        },
                      );
                    },
                    approvedFun: () {
                      PopupWindow.showPopupWindow(
                        "Are you sure? you want to approve this post?",
                        "Yes, Approve",
                        context,
                        () {
                          final provider =
                              Provider.of<PostWithUserDataProvider>(context,
                                  listen: false);
                          provider.ApprovedPostByID(post.post.id);
                          SendPushNotification.sendNotificationUsingApi(
                            topic: AppData.allUserTopic,
                            title: "නව පළ කිරීමක් 🔔",
                            body:
                                "'${post.user.name}' විසින් අලුත් පළ කිරීමක් කරන ලදී...",
                            data: {
                              "post_id": post.post.id,
                              "user_id": post.user.id,
                            },
                          );
                          context.pop();
                          _refreshUnapprovedPosts();  
                        },
                        () {
                          context.pop();
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
