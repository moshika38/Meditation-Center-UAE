import 'package:flutter/material.dart';
import 'package:meditation_center/core/formatter/datetime.formatter.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/data/models/user.model.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return FutureBuilder(
            future: userProvider.getUserById(userID),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final user = snapshot.data as UserModel;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                  const SizedBox(width: 12),

                  /// Comment bubble
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Name + Time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    user.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textColor,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DatetimeFormatter.timeAgo(dateTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// Comment text
                            Text(
                              body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    height: 1.4,
                                    color: AppColors.textColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
