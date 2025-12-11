import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/popup/popup.window.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/notice.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/providers/notice.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class NoticeViewer extends StatefulWidget {
  final String noticeID;
  const NoticeViewer({
    super.key,
    required this.noticeID,
  });

  @override
  State<NoticeViewer> createState() => _NoticeViewerState();
}

class _NoticeViewerState extends State<NoticeViewer> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Notice',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
                fontSize: 20,
              ),
        ),
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
        actions: [_actionBtnAppBar()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, NoticeProvider provider, child) => FutureBuilder(
            future: provider.getNoticeByID(widget.noticeID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PageLoader();
              }

              if (snapshot.hasError) {
                AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
              }
              if (snapshot.hasData) {
                final notice = snapshot.data as NoticeModel;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notice.title,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      CachedNetworkImage(
                        imageUrl: notice.mainImage,
                        cacheKey: notice.mainImage,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(notice.body,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                );
              }
              return const PageLoader();
            },
          ),
        ),
      ),
    );
  }

  Widget _actionBtnAppBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Consumer2(
        builder: (context, UserProvider uProvider, NoticeProvider nProvider,
                child) =>
            FutureBuilder(
          future: uProvider.getUserById(userID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data as UserModel;

              return IconButton(
                onPressed: () {
                  if (userData.isAdmin) {
                    // show conform window
                    PopupWindow.showPopupWindow(
                      "Conform to delete this  notice, this action cannot be undone",
                      "Yes, add notice",
                      context,
                      () async {
                        // upload
                        final status =
                            await nProvider.deleteNotice(widget.noticeID);
                        if (status) {
                          EasyLoading.showSuccess("Deleted !",
                              duration: Duration(seconds: 2));
                          if (!mounted) return;
                          context.pop();
                        }
                        if (!mounted) return;
                        context.pop();
                      },
                      () {
                        // cancel
                        if (!mounted) return;
                        context.pop();
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.whiteColor,
                  size: 20,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
