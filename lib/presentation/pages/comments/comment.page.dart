import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/data/models/comment.model.dart';
import 'package:meditation_center/presentation/components/app.input.dart';
import 'package:meditation_center/presentation/components/comment.card.dart';
import 'package:meditation_center/presentation/components/empty.data.card.dart';
import 'package:meditation_center/providers/comment.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postID;
  const CommentBottomSheet({super.key, required this.postID});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String cUser = FirebaseAuth.instance.currentUser!.uid;
  bool isAdmin = false;

  void _addNewComment() async {
    if (_textController.text.trim().isEmpty) return;

    final provider = context.read<CommentProvider>();
    final body = _textController.text.trim();
    _textController.clear();

    await provider.addNewComment(widget.postID, cUser, body);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void checkAdmin() async {
    final user = await context.read<UserProvider>().getUserById(cUser);
    if (user.isAdmin) {
      setState(() => isAdmin = true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                /// Header (Drag handle + Close)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.xmark),
                        splashRadius: 20,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                /// Title
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    "Comments",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const Divider(height: 1),

                /// Comment List
                Expanded(
                  child: Consumer<CommentProvider>(
                    builder: (context, provider, _) {
                      return StreamBuilder<List<CommentModel>>(
                        stream: provider.getCommentsByPostId(widget.postID),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const PageLoader();
                          }

                          final comments = snapshot.data!;
                          if (comments.isEmpty) {
                            return const EmptyDataCard(
                              title: "No comments yet",
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            padding: const EdgeInsets.all(12),
                            itemCount: comments.length,
                            itemBuilder: (_, index) {
                              final comment = comments[index];

                              return GestureDetector(
                                onLongPress: () {
                                  if (isAdmin || comment.userID == cUser) {
                                    PopupWindow.showPopupWindow(
                                      "Delete this comment permanently?",
                                      "Delete",
                                      context,
                                      () {
                                        context.pop();
                                        provider.deleteComment(
                                          widget.postID,
                                          comment.id,
                                        );
                                      },
                                      () => context.pop(),
                                    );
                                  }
                                },
                                child: CommentCard(
                                  commentID: comment.id,
                                  userID: comment.userID,
                                  body: comment.body,
                                  dateTime: comment.dateTime,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                /// Input Field
                Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                    top: 8,
                  ),
                  child: AppInput(
                    controller: _textController,
                    hintText: "Write a comment...",
                    prefixIcon: Icons.image,
                    suffixIcon: Icons.send,
                    onTapIcon: _addNewComment,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
