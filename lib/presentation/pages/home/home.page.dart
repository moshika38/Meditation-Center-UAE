import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/core/shimmer/post.shimmer.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<PostWithUsersModel>> _postsFuture;
  final cUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    final provider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    _postsFuture = provider.getAllPosts();
  }

  Future<void> _refreshPosts() async {
    try {
      LoadingPopup.show("Refreshing posts...");
      _loadPosts();
      setState(() {});
    } catch (e) {
      AppTopSnackbar.showTopSnackBar(context, "Failed to refresh posts");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.whiteColor,
      color: AppColors.primaryColor,
      onRefresh: _refreshPosts,
      child: FutureBuilder<List<PostWithUsersModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              EasyLoading.dismiss();
              AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
            });
            return Center(
              child: EmptyAnimation(title: "Error loading posts !"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PostShimmer(); // shimmer directly
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            EasyLoading.dismiss();
          });

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: EmptyAnimation(title: "No posts yet!"));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: posts.length,
            cacheExtent: 1000,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.1),
                ),
                child: PostCard(
                  isCUser: post.user.uid == cUser,
                  isHome: true,
                  postID: post.post.id,
                  onDelete: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
