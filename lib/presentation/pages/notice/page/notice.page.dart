import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/shimmer/notice.shimmer.dart';
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
  String user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
         children: [
          const SizedBox(height: 5),
          Consumer(
            builder:
                (BuildContext context, UserProvider userP, Widget? child) =>
                    FutureBuilder(
              future: userP.getUserById(user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data as UserModel;

                  return user.isAdmin
                      ? AppButtons(
                          height: 50,
                          width: double.infinity,
                          text: "Add new notice",
                          isPrimary: true,
                          icon: Icons.add_box_rounded,
                          onTap: () {
                            // go to add new notice page
                            context.push('/addNotice');
                          },
                        )
                      : const SizedBox.shrink();
                }
                return SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 15),
          Consumer(
            builder: (context, NoticeProvider noticeProvider, child) =>
                StreamBuilder(
              stream: noticeProvider.getAllNotices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NoticeCardShimmer();
                }

                if (snapshot.hasError) {
                   return const Center(child: Text("Something went wrong!"));
                }

                if (!snapshot.hasData ||
                    (snapshot.data as List<NoticeModel>).isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: EmptyDataCard(title: "No notices yet !"),
                    ),
                  );
                }

                final notices = snapshot.data as List<NoticeModel>;

                return Expanded(
                  child: ListView.builder(
                     
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          context.push("/noticeViewer", extra: notices[index].id);
                        },
                        child: NoticeCard(
                          body: notices[index].body,
                          title: notices[index].title,
                          date: notices[index].dateTime,
                          time: notices[index].dateTime.toString(),
                          mainImage: notices[index].mainImage,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
