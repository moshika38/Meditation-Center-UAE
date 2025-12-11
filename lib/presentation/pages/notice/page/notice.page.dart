import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/alerts/app.loading.dart';
import 'package:meditation_center/data/models/notice.model.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';
import 'package:meditation_center/presentation/components/empty.data.card.dart';
import 'package:meditation_center/presentation/pages/notice/widgets/notice.card.dart';
import 'package:meditation_center/providers/notice.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 5),

          //  ADMIN BUTTON
          Consumer<UserProvider>(
            builder: (context, userP, child) {
              return FutureBuilder<UserModel>(
                future: userP.getUserById(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final user = snapshot.data!;
                  if (!user.isAdmin) return const SizedBox.shrink();

                  return AppButtons(
                    height: 50,
                    width: double.infinity,
                    text: "Add new notice",
                    isPrimary: true,
                    icon: Icons.add_box_rounded,
                    onTap: () {
                      context.push('/addNotice');
                    },
                  );
                },
              );
            },
          ),

          const SizedBox(height: 15),

          //  NOTICE LIST / LOADER / EMPTY
          Consumer<NoticeProvider>(
            builder: (context, noticeProvider, child) {
              return StreamBuilder<List<NoticeModel>>(
                stream: noticeProvider.getAllNotices(),
                builder: (context, snapshot) {
                  //  LOADING (CENTER)
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: PageLoader(),
                      ),
                    );
                  }

                  //  ERROR
                  if (snapshot.hasError) {
                    return const Expanded(
                      child: Center(
                        child: Text("Something went wrong!"),
                      ),
                    );
                  }

                  //  EMPTY
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: EmptyDataCard(
                          title: "No notices yet !",
                        ),
                      ),
                    );
                  }

                  final notices = snapshot.data!;

                  //  DATA LIST
                  return Expanded(
                    child: ListView.builder(
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        final notice = notices[index];

                        return GestureDetector(
                          onTap: () {
                            context.push(
                              "/noticeViewer",
                              extra: notice.id,
                            );
                          },
                          child: NoticeCard(
                            body: notice.body,
                            title: notice.title,
                            date: notice.dateTime,
                            time: notice.dateTime.toString(),
                            mainImage: notice.mainImage,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
