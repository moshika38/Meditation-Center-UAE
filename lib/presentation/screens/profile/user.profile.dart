import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/connection/connection.checker.dart';
import 'package:meditation_center/connection/lost.connection.alert.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/crashlytics/crashlytics.helper.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/empty.data.card.dart';
import 'package:meditation_center/presentation/components/post.card.dart';
import 'package:meditation_center/presentation/components/profile.data.card.dart';
import 'package:meditation_center/presentation/components/user.data.card.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final String userId;
  const UserProfile({super.key, required this.userId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  UserModel? userData;
  bool isConnect = false;

  Future<void> deletePost(String postID) async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.deletePost(postID);
    setState(() {});
  }

  void showLostConnectionAlert() {
    LostConnectionAlert.showAlert(
      context,
      onCheckAgain: () {
        initConnectivity();
      },
    );
  }

  Future<void> initConnectivity() async {
    final result = await ConnectionChecker().checkConnection();
    if (!result) {
      isConnect = false;
      setState(() {});
      showLostConnectionAlert();
    } else {
      isConnect = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    CrashlyticsHelper.logScreenView("User Profile");
  }

  @override
  Widget build(BuildContext context) {
    return isConnect
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
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
              child: FutureBuilder<UserModel>(
                future: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).getUserById(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const PageLoader();
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text("Error loading user data"));
                  }

                  userData = snapshot.data!;

                  return Consumer<PostWithUserDataProvider>(
                    builder: (context, postDataProvider, child) =>
                        FutureBuilder<List<PostModel>>(
                          future: postDataProvider.getPostsByUserId(
                            widget.userId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const PageLoader();
                            }

                            if (snapshot.hasError) {
                              return Center(child: Text("Error loading posts"));
                            }

                            final posts = snapshot.data ?? [];

                            int totalPosts = posts.length;
                            int totalLikes = posts.fold(
                              0,
                              (sum, post) => sum + (post.likes),
                            );
                            int totalComments = posts.fold(
                              0,
                              (sum, post) => sum + (post.comments),
                            );

                            return ListView(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              children: [
                                // User info
                                UserDataCard(
                                  imageUrl: userData!.profileImage,
                                  name: userData!.name,
                                  email: userData!.email,
                                  isDarkText: true,
                                ),

                                // Details card
                                GestureDetector(
                                  child: ProfileDataCard.detailsCard(
                                    context,   
                                    totalPosts: totalPosts,
                                    totalLikes: totalLikes,
                                    totalComments: totalComments,
                                    createdDate: userData!.onCreated!=null ? userData!.onCreated.toString() : "N/A",
                                    lastLogin: userData!.lastLogin!=null ?userData!.lastLogin.toString() : "N/A",

                                  ),
                                ),

                                _headerCard(),

                                if (posts.isEmpty)
                                  _emptyAnimation()
                                else
                                  ...posts.map(
                                    (postData) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gray.withOpacity(0.1),
                                      ),
                                      child: PostCard(
                                        userData: userData!,
                                        postData: postData,
                                        isApproved: postData.isApproved,
                                        isHome: false,
                                        isCUser: currentUser == postData.userId
                                            ? true
                                            : false,
                                        isReel: postData.isReel,
                                        approvedPage: false,
                                        onDelete: () {
                                          deletePost(postData.id);
                                        },
                                        approvedFun: () {},
                                        removeFun: () {},
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                  );
                },
              ),
            ),
          )
        : const PageLoader();
  }

  Widget _headerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Uploaded Posts",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const FaIcon(FontAwesomeIcons.earth, size: 20),
        ],
      ),
    );
  }

  Widget _emptyAnimation() {
    return const Padding(
      padding: EdgeInsets.only(top: 30),
      child: EmptyDataCard(title: "No posts yet!"),
    );
  }
}
