import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/loading.popup.dart';
import 'package:meditation_center/core/formatter/number.formatter.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/post.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/native.share.dart';
import 'package:meditation_center/presentation/components/pending.icon.dart';
import 'package:meditation_center/presentation/components/post.card.Components.dart';
import 'package:meditation_center/presentation/components/post.card.user.info.dart';
import 'package:meditation_center/presentation/pages/comments/comment.page.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/video.player.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final PostModel postData;
  final UserModel userData;
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
    required this.postData,
    required this.userData,
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
  final String cUser = FirebaseAuth.instance.currentUser!.uid;

  bool isMore = false;
  bool isLiked = false;

  late int numOfLikes;
  late int numOfComments;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //  INIT local state ONCE
    numOfLikes = widget.postData.likes;
    numOfComments = widget.postData.comments;

    _checkUserLikeStatus();
  }

  void _checkUserLikeStatus() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final status = await postProvider.hasUserLikedPost(
      widget.postData.id,
      cUser,
    );

    if (!mounted) return;
    setState(() => isLiked = status);
  }

  void openComments(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommentBottomSheet(postID: postId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  APPROVE / REMOVE (ADMIN)
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

          //  USER INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostCardUserInfo(
                isProfile: widget.isHome,
                isNotHome: widget.approvedPage,
                userId: widget.userData.uid,
                userName: widget.userData.name,
                userImage: widget.userData.profileImage,
                time: widget.postData.dateTime,
              ),
              if (widget.isCUser && !widget.isHome)
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onSelected: (_) {
                    PopupWindow.showPopupWindow(
                      "Delete this post?",
                      "Yes, Delete",
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
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 10),

          //  DESCRIPTION
          GestureDetector(
            onTap: () => setState(() => isMore = !isMore),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.postData.description ?? "",
                maxLines: isMore ? null : 2,
                overflow: isMore ? null : TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(height: 10),

          //  IMAGE / VIDEO
          widget.isReel
              ? VideoPlayerWidget(videoPath: widget.postData.assetsUrls.first)
              : PostCardComponents.imageCard(
                  context,
                  false,
                  widget.postData.assetsUrls.length,
                  widget.postData.assetsUrls.first,
                  widget.postData.assetsUrls.length > 1
                      ? widget.postData.assetsUrls[1]
                      : "null",
                ),

          const SizedBox(height: 10),

          //  LIKE / COMMENT COUNT
          if (widget.isApproved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${NumberFormatter.formatCount(numOfLikes)} likes",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontSize: 14),
                  ),
                  Text(
                    "${NumberFormatter.formatCount(numOfComments)} comments",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

          if (!widget.isApproved && widget.isCUser)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: PendingIcon(),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Container(color: AppColors.gray.withOpacity(0.3), height: 1),
          ),

          const SizedBox(height: 10),

          //  ACTION BUTTONS
          if (widget.isApproved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostCardComponents.actionBtn(
                    context,
                    Icons.thumb_up,
                    "Like",
                    "assets/svg/like.svg",
                    isLiked,
                    () {
                      setState(() {
                        if (isLiked) {
                          numOfLikes--;
                        } else {
                          numOfLikes++;
                        }
                        isLiked = !isLiked;
                      });

                      isLiked
                          ? postProvider.likePost(widget.postData.id, cUser)
                          : postProvider.dislikePost(widget.postData.id, cUser);
                    },
                  ),

                  PostCardComponents.actionBtn(
                    context,
                    Icons.comment,
                    "Comment",
                    "assets/svg/comments.svg",
                    false,
                    // () => context.push('/comment', extra: widget.postData.id),
                    () {
                      openComments(context, widget.postData.id);
                    },
                  ),
                  PostCardComponents.actionBtn(
                    context,
                    Icons.share_outlined,
                    "Share",
                    "assets/svg/share.svg",
                    false,
                    () {
                      LoadingPopup.show("Sharing...");
                      NativeShare.share(url: widget.postData.assetsUrls.first);
                      EasyLoading.dismiss();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
