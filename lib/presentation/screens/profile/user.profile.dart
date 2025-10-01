import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/formatter/number.formatter.dart';
import 'package:meditation_center/core/shimmer/user.account.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/presentation/components/user.data.card.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deletePost(String postID) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.deletePost(postID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.pureBlack,
            size: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Consumer<PostWithUserDataProvider>(
          builder: (context, postDataProvider, child) =>
              FutureBuilder<List<PostModel>>(
            future: postDataProvider.getPostsByUserId(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserProfileShimmer();
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading posts"));
              }

              final posts = snapshot.data ?? [];

              int totalPosts = posts.length;
              int totalLikes = posts.fold(0, (sum, post) => sum + (post.likes));
              int totalComments =
                  posts.fold(0, (sum, post) => sum + (post.comments));

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  // User info
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) => FutureBuilder(
                      future: userProvider.getUserById(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data as UserModel;
                          return UserDataCard(
                            imageUrl: user.profileImage,
                            name: user.name,
                            email: user.email,
                            isDarkText: true,
                          );
                        }
                        return UserDataCard(
                          imageUrl: AppData.baseUserUrl,
                          name: "",
                          email: "",
                          isDarkText: true,
                        );
                      },
                    ),
                  ),

                  // **Dynamic counts**
                  _detailsCard(totalPosts, totalLikes, totalComments),

                  _headerCard(),

                  if (posts.isEmpty)
                    _emptyAnimation()
                  else
                    ...posts.map(
                      (postData) => PostCard(
                        postID: postData.id,
                        isApproved: postData.isApproved,
                        isHome: false,
                        isCUser: currentUser == postData.userId,
                        isReel: postData.isReel,
                        approvedPage: false,
                        onDelete: ()  {
                          deletePost(postData.id);
                        },
                        approvedFun: () {},
                        removeFun: () {},
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Uploaded Posts",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          FaIcon(
            FontAwesomeIcons.earth,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _emptyAnimation() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: EmptyAnimation(title: "No posts yet!"),
    );
  }

  Widget _detailsCard(int totalPosts, int totalLikes, int totalComments) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _itemCard(
              "Likes",
              totalLikes,
              FontAwesomeIcons.heart,
            ),
            _itemCard(
              "Comments",
              totalComments,
              FontAwesomeIcons.comment,
            ),
            _itemCard(
              "Posts",
              totalPosts,
              FontAwesomeIcons.noteSticky,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(
    String title,
    int count,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          NumberFormatter.formatCount(count),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            FaIcon(icon, size: 15, color: AppColors.pureBlack),
            const SizedBox(width: 5),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppColors.pureBlack, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}
