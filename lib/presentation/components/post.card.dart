import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/formatter/number.formatter.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/pending.icon.dart';
import 'package:meditation_center/presentation/components/post.card.Components.dart';
import 'package:meditation_center/presentation/components/post.card.user.info.dart';
import 'package:meditation_center/core/shimmer/post.shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/video.player.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String postID;
  final bool isHome;
  final bool isCUser;
  final bool isApproved;
  final bool isReel;
  final bool approvedPage;
  final VoidCallback onDelete;
  final VoidCallback approvedFun;
  final VoidCallback removeFun;
  const PostCard({
    super.key,
    required this.postID,
    required this.isApproved,
    required this.isHome,
    required this.isCUser,
    required this.isReel,
    required this.approvedPage,
    required this.onDelete,
    required this.approvedFun,
    required this.removeFun,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  bool isMore = false;
  bool isLiked = false;
  int numOfLikes = 0;
  int numOfComments = 0;
  final cUser = FirebaseAuth.instance.currentUser!.uid;

  void checkUserLikeStatus() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    bool status = await postProvider.hasUserLikedPost(widget.postID, cUser);
    if (!mounted) return;
    setState(() {
      isLiked = status;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    checkUserLikeStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postWithUserDataProvider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: StreamBuilder(
            stream: postWithUserDataProvider.getPostDetailsById(widget.postID),
            builder: (context, snapshot) {
              // First time load only
              if (!snapshot.hasData) {
                return const PostShimmer();
              }

              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error loading post",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text("Try again"),
                    ),
                  ],
                );
              }

              final postData = snapshot.data!;

              // Local UI update
              numOfLikes = postData.post.likes;
              numOfComments = postData.post.comments;

              return Column(
                children: [
                  // delete or approve post
                  widget.approvedPage
                      ? !widget.isApproved
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppButtons(
                                  width: 120,
                                  height: 40,
                                  icon: Icons.remove,
                                  text: "Remove",
                                  onTap: widget.removeFun,
                                  isPrimary: true,
                                ),
                                SizedBox(width: 10),
                                AppButtons(
                                  width: 120,
                                  height: 40,
                                  icon: Icons.check_circle_rounded,
                                  text: "Approve",
                                  onTap: widget.approvedFun,
                                  isPrimary: true,
                                ),
                              ],
                            )
                          : SizedBox.shrink()
                      : SizedBox.shrink(),

                  SizedBox(height: 20),
                  // user info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PostCardUserInfo(
                        isNotHome: widget.approvedPage == true,
                        userId: postData.user.uid,
                        userName: postData.user.name ,
                        userImage: postData.user.profileImage,
                        time: postData.post.dateTime,
                      ),
                      widget.isCUser && widget.isHome == false
                          ? PopupMenuButton<int>(
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: AppColors.pureBlack,
                                size: 25,
                              ),
                              color: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (value) async {
                                // delete
                                PopupWindow.showPopupWindow(
                                  "Are you sure? This action cannot be undone.",
                                  "Yes, delete",
                                  context,
                                  () {
                                    // delete
                                    context.pop();
                                    widget.onDelete();
                                  },
                                  () {
                                    // cancel
                                    context.pop();
                                  },
                                );
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: AppColors.whiteColor),
                                      SizedBox(width: 8),
                                      Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: AppColors.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMore = !isMore;
                              });
                            },
                            child: Text(
                              postData.post.description ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: !isMore ? TextOverflow.ellipsis : null,
                              maxLines: isMore ? null : 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  postData.post.description != ""
                      ? const SizedBox(height: 10)
                      : const SizedBox.shrink(),

                  // content images or video
                  widget.isReel
                      ? VideoPlayerWidget(
                          videoPath: postData.post.assetsUrls.first,
                        )
                      : Container(
                          // ignore: deprecated_member_use
                          color: AppColors.gray.withOpacity(0.05),
                          width: double.infinity,
                          child: Column(
                            children: [
                              if (postData.post.assetsUrls.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/viewer',
                                      extra: postData.post.assetsUrls,
                                    );
                                  },
                                  child: PostCardComponents.imageCard(
                                    context,
                                    false,
                                    postData.post.assetsUrls.length,
                                    postData.post.assetsUrls[0],
                                    postData.post.assetsUrls.length > 1
                                        ? postData.post.assetsUrls[1]
                                        : "null",
                                  ),
                                ),
                              const SizedBox(height: 10),
                              if (postData.post.assetsUrls.length > 2)
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/viewer',
                                      extra: postData.post.assetsUrls,
                                    );
                                  },
                                  child: PostCardComponents.imageCard(
                                    context,
                                    true,
                                    postData.post.assetsUrls.length,
                                    postData.post.assetsUrls[2],
                                    postData.post.assetsUrls.length != 3
                                        ? postData.post.assetsUrls[3]
                                        : "null",
                                  ),
                                ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 30),

                  widget.isApproved
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " ${NumberFormatter.formatCount(numOfLikes)}  like",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                " ${NumberFormatter.formatCount(numOfComments)}  comments",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            // show pending badge
                            widget.isCUser ? PendingIcon() : SizedBox.shrink()
                          ],
                        ),

                  widget.isApproved
                      ? const SizedBox(height: 10)
                      : SizedBox.shrink(),
                  widget.isApproved
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PostCardComponents.actionBtn(
                                context,
                                Icons.thumb_up,
                                "Like",
                                isLiked,
                                () {
                                  setState(() {
                                    numOfLikes += isLiked ? 1 : -1;
                                    isLiked = !isLiked;
                                  });

                                  // backend update background
                                  if (isLiked) {
                                    postProvider.likePost(widget.postID, cUser);
                                  } else {
                                    postProvider.dislikePost(
                                      widget.postID,
                                      cUser,
                                    );
                                  }
                                },
                              ),
                              PostCardComponents.actionBtn(
                                context,
                                Icons.comment,
                                "Comment",
                                false,
                                () {
                                  (context)
                                      .push('/comment', extra: widget.postID);
                                },
                              ),
                              PostCardComponents.actionBtn(
                                context,
                                Icons.share_outlined,
                                "Share",
                                false,
                                () {},
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  widget.isApproved
                      ? const SizedBox(height: 10)
                      : SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
