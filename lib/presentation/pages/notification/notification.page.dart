import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/alerts/app.top.snackbar.dart';
import 'package:meditation_center/core/shimmer/notification.shimmer.dart';
import 'package:meditation_center/data/models/notification.model.dart';
import 'package:meditation_center/presentation/components/empty.animation.dart';
import 'package:meditation_center/presentation/components/notification.card.dart';
import 'package:meditation_center/providers/notification.provider.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer(
        builder: (context, NotificationProvider notificationProvider, child) =>
            FutureBuilder(
          future: notificationProvider.getNotificationsByUserId(cUser),
          builder: (context, snapshot) {
            // error  getting notifications
            if (snapshot.hasError) {
              AppTopSnackbar.showTopSnackBar(context, "Something went wrong");
            }
            // loading data
            if (snapshot.connectionState == ConnectionState.waiting) {
              NotificationShimmer();
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return EmptyAnimation(title: "No notifications yet !");
              }

              final notifications = snapshot.data as List<NotificationModel>;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: GestureDetector(
                            onTap: () {
                              notificationProvider
                                  .deleteAllNotificationsByUserId(cUser);
                            },
                            child: Text(
                              "Clear all",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          print(notifications[index].dateTime.toString());
                          return NotificationCard(
                            title: notifications[index].title,
                            body: notifications[index].body,
                            time: notifications[index].dateTime.toString(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return NotificationShimmer();
          },
        ),
      ),
    );
  }
}
