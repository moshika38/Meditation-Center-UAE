import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/formatter/number.formatter.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/native.share.dart';
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

class _PostCardState extends State<PostCard> {
  bool isMore = false;
  bool isLiked = false;

  int numOfLikes = 0;
  int numOfComments = 0;

  String? cUser;

  @override
  void initState() {
    super.initState();
    cUser = FirebaseAuth.instance.currentUser?.uid;

    if (cUser != null) {
      _checkUserLikeStatus();
    }
  }

  Future<void> _checkUserLikeStatus() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final status =
        await postProvider.hasUserLikedPost(widget.postID, cUser!);

    if (!mounted) return;
    setState(() => isLiked = status);
  }

  @override
  Widget build(BuildContext context) {
    final postWithUserDataProvider =
        Provider.of<PostWithUserDataProvider>(context, listen: false);
    final postProvider =
        Provider.of<PostProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: StreamBuilder(
        stream:
            postWithUserDataProvider.getPostDetailsById(widget.postID),
        builder: (context, snapshot) {
          /// proper shimmer
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PostShimmer();
          }

          if (snapshot.hasError) {
            return Column(
              children: [
                Text(
                  "Error loading post",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text("Try again"),
                ),
              ],
            );
          }

          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final postData = snapshot.data!;

          /// sync counters once
          numOfLikes = postData.post.likes;
          numOfComments = postData.post.comments;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// approve / remove buttons
              if (widget.approvedPage && !widget.isApproved)
                Row(
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
                    const SizedBox(width: 10),
                    AppButtons(
                      width: 120,
                      height: 40,
                      icon: Icons.check_circle_rounded,
                      text: "Approve",
                      onTap: widget.approvedFun,
                      isPrimary: true,
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              /// user info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostCardUserInfo(
                    isNotHome: widget.approvedPage,
                    userId: postData.user.uid,
                    userName: postData.user.name,
                    userImage: postData.user.profileImage,
                    time: postData.post.dateTime,
                  ),
                  if (widget.isCUser && !widget.isHome)
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert_outlined),
                      onSelected: (_) {
                        PopupWindow.showPopupWindow(
                          "Are you sure? This action cannot be undone.",
                          "Yes, delete",
                          context,
                          () {
                            context.pop();
                            widget.onDelete();
                          },
                          () => context.pop(),
                        );
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 1,
                          child: Text("Delete",
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                ],
              ),

              const SizedBox(height: 10),

              /// description
              GestureDetector(
                onTap: () => setState(() => isMore = !isMore),
                child: Text(
                  postData.post.description ?? "",
                  maxLines: isMore ? null : 2,
                  overflow:
                      isMore ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
              ),

              if ((postData.post.description ?? "").isNotEmpty)
                const SizedBox(height: 10),

              /// media
              widget.isReel
                  ? VideoPlayerWidget(
                      videoPath: postData.post.assetsUrls.first,
                    )
                  : _buildImages(postData),

              const SizedBox(height: 20),

              /// counts
              widget.isApproved
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${NumberFormatter.formatCount(numOfLikes)} likes",
                        ),
                        Text(
                          "${NumberFormatter.formatCount(numOfComments)} comments",
                        ),
                      ],
                    )
                  : (widget.isCUser ? const PendingIcon() : const SizedBox()),

              if (widget.isApproved) const SizedBox(height: 10),

              /// actions
              if (widget.isApproved)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PostCardComponents.actionBtn(
                      context,
                      Icons.thumb_up,
                      "Like",
                      isLiked,
                      () {
                        if (cUser == null) return;

                        setState(() {
                          isLiked = !isLiked;
                          numOfLikes += isLiked ? 1 : -1;
                        });

                        isLiked
                            ? postProvider.likePost(
                                widget.postID, cUser!)
                            : postProvider.dislikePost(
                                widget.postID, cUser!);
                      },
                    ),
                    PostCardComponents.actionBtn(
                      context,
                      Icons.comment,
                      "Comment",
                      false,
                      () =>
                          context.push('/comment', extra: widget.postID),
                    ),
                    PostCardComponents.actionBtn(
                      context,
                      Icons.share_outlined,
                      "Share",
                      false,
                      () {
                        LoadingPopup.show('Sharing...');
                        NativeShare.share(
                          text: postData.post.description ?? "",
                          url: postData.post.assetsUrls.first,
                        );
                        EasyLoading.dismiss();
                      },
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  /// image helper
  Widget _buildImages(postData) {
    return Container(
      color: AppColors.gray.withOpacity(0.05),
      child: Column(
        children: [
          if (postData.post.assetsUrls.isNotEmpty)
            GestureDetector(
              onTap: () =>
                  context.push('/viewer', extra: postData.post.assetsUrls),
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
        ],
      ),
    );
  }
}
