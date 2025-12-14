import 'package:flutter/material.dart';
import 'package:meditation_center/core/formatter/datetime.formatter.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final String commentID;
  final String userID;
  final String body;
  final DateTime dateTime;

  const CommentCard({
    super.key,
    required this.commentID,
    required this.userID,
    required this.body,
    required this.dateTime,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Consumer(
          builder: (context, UserProvider userProvider, child) => FutureBuilder(
            future: userProvider.getUserById(widget.userID),
            builder: (context, snapshot) {
              // error getting user
              if (snapshot.hasError) {
                return const SizedBox.shrink();
              }

              // loading user data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }

              // has user data

              final user = snapshot.data as UserModel;

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      user.profileImage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                         border: Border.all(
                           color: AppColors.secondaryColor,
                            width: 1,
                         ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    user.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!.copyWith(fontSize: 13,fontWeight: FontWeight.bold)
                                        ,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  ,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DatetimeFormatter.timeAgo(widget.dateTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!.copyWith(
                                        fontSize: 12
                                      )
                                      ,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
