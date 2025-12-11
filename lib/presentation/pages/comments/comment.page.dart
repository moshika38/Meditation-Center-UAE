import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

class CommentPage extends StatefulWidget {
  final String postID;
  const CommentPage({
    super.key,
    required this.postID,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final userID = FirebaseAuth.instance.currentUser!.uid;

  void _addNewComment() async {
    if (_textController.text.isEmpty) return;

    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    final body = _textController.text;
    _textController.clear();

    await commentProvider.addNewComment(widget.postID, userID, body);

    // Scroll to latest comment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0, // because reverse: true
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final cUser = FirebaseAuth.instance.currentUser!.uid;

  bool isAdmin = false;
  bool isCurrentUser = false;

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
    checkAdmin();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // key point
      appBar: AppBar(
        title: const Text("Comments"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer2(
              builder: (context, CommentProvider commentProvider,UserProvider user, child) {
                return StreamBuilder<List<CommentModel>>(
                  stream: commentProvider.getCommentsByPostId(widget.postID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final comments = snapshot.data ?? [];

                      if (comments.isEmpty) {
                        return const EmptyDataCard(title: "No comments yet !");
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true, // latest comment at bottom
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return GestureDetector(
                            onLongPress: () {
                              if (isAdmin || comment.userID == cUser) {
                                // admin can delete any comment
                                PopupWindow.showPopupWindow(
                                  "Are you sure? you want to delete this comment?if you delete this comment, it will be gone forever",
                                  "Yes, Delete",
                                  context,
                                  () {
                                    // delete comment
                                    context.pop();
                                    commentProvider.deleteComment(widget.postID,comment.id);
                                    EasyLoading.dismiss();
                                  },
                                  () {
                                    context.pop();
                                  },
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
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    return PageLoader();
                  },
                );
              },
            ),
          ),
          // Fixed bottom input field
          Container(
            color: Theme.of(context).canvasColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              top: false,
              child: AppInput(
                controller: _textController,
                hintText: "Type your message",
                prefixIcon: Icons.type_specimen,
                suffixIcon: Icons.send,
                onTapIcon: _addNewComment,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
