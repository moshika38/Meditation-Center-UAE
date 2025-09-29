import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/shimmer/user.account.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/posts.with.users.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/presentation/components/user.data.card.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String userID;

  const UserProfile({super.key, required this.userID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<PostWithUsersModel>> _postsFuture;

  final cUser = FirebaseAuth.instance.currentUser!.uid;

  String userName = "";
  String userEmail = "";
  String userImage = "";

  int allComments = 0;
  int allLikes = 0;

  bool isCUser = false;

  void checkUser() async {
    if (widget.userID == cUser) {
      setState(() {
        isCUser = true;
      });
    }
  }

  loadUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = await userProvider.getUserById(widget.userID);
    if (user.name.isNotEmpty && user.email.isNotEmpty) {
      setState(() {
        userName = user.name;
        userEmail = user.email;
        userImage = user.profileImage;
      });
    } else {
      AppTopSnackbar.showTopSnackBar(context, " Error loading user data");
      context.pop();
    }
  }

  void _loadPosts() {
    final provider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    _postsFuture = isCUser
        ? provider.getPostsByUserId(widget.userID)
        : provider.getApprovedPostsByUserId(widget.userID);
  }

  Future<void> _refreshPosts() async {
    _loadPosts();
    setState(() {});
    await _postsFuture;
  }

    bool isAdmin = false;

  // check user is admin or not
  void checkAdmin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = await userProvider.getUserById(cUser);
    if (user.isAdmin) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    checkUser();
    _loadPosts();
    checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.pureBlack,
            size: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.whiteColor,
        color: AppColors.primaryColor,
        onRefresh: _refreshPosts,
        child: Consumer(
          builder: (context, PostWithUserDataProvider provider, child) =>
              FutureBuilder(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error loading posts");
              }

              if (snapshot.hasData) {
                final posts = snapshot.data as List<PostWithUsersModel>;
                if (posts.isNotEmpty) {
                  allComments = posts
                      .map((e) => e.post.comments)
                      .reduce((value, element) => value + element);
                  allLikes = posts
                      .map((e) => e.post.likes)
                      .reduce((value, element) => value + element);
                }

                return _accountCard(
                  theme,
                  size,
                  posts,
                  allComments,
                  allLikes,
                );
              }

              return UserProfileShimmer(size: size);
            },
          ),
        ),
      ),
    );
  }

  Widget _accountCard(
    TextTheme theme,
    Size size,
    List<PostWithUsersModel> postData,
    int allComments,
    int allLikes,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: size.width * 0.7,
              child: UserDataCard(
                isDarkBorder: true,
                isDarkText: true,
                imageUrl: userImage,
                name: userName,
                email: userEmail,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                itemCard(
                  Icons.thumb_up,
                  allLikes,
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.gray,
                ),
                itemCard(
                  Icons.comment,
                  allComments,
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.gray,
                ),
                itemCard(
                  Icons.photo_size_select_actual,
                  postData.length,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          postData.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Uploaded Posts",
                        style: theme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.public),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          postData.isNotEmpty ? SizedBox(height: 30) : const SizedBox.shrink(),
          postData.isNotEmpty
              ? ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                onLongPress: () {
                  if (isAdmin) {
                    // admin can delete any post
                    PopupWindow.showPopupWindow(
                      "Are you sure? you want to delete this post?if you delete this post, it will be gone forever",
                      "Yes, Delete",
                      context,
                      () {
                        // delete post by admin
                        LoadingPopup.show('Deleting...');
                        final postProvider =
                            Provider.of<PostProvider>(context, listen: false);
                        postProvider.deletePost(postData[index].post.id);
                        EasyLoading.dismiss();
                        _refreshPosts();
                        context.pop();
                      },
                      () {
                        context.pop();
                      },
                    );
                  }
                }, 
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: AppColors.gray.withOpacity(0.1),
                        ),
                        child: PostCard(
                          removeFun: () {},
                          approvedFun: () {},
                          approvedPage: false,
                          isApproved: postData[index].post.isApproved,
                          isCUser: isCUser,
                          isHome: false,
                          postID: postData[index].post.id,
                          onDelete: () {
                            LoadingPopup.show('Deleting...');
                            final postProvider =
                                Provider.of<PostProvider>(context, listen: false);
                            postProvider.deletePost(postData[index].post.id);
                            EasyLoading.dismiss();
                            _refreshPosts();
                          },
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    EmptyAnimation(title: "No posts yet !"),
                  ],
                ),
        ],
      ),
    );
  }

  Widget itemCard(
    IconData icon,
    int number,
  ) {
    final tt = Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15);
    return Container(
      width: 110,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
            ),
            const SizedBox(width: 10),
            Text(
              number.toString(),
              style: tt,
            ),
          ],
        ),
      ),
    );
  }
}
