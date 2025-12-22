import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meditation_center/core/formatter/number.formatter.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class ProfileDataCard {
  static Widget detailsCard(
    BuildContext context, {
    required bool isAdmin,
    required int totalPosts,
    required int totalLikes,
    required int totalComments,
    required DateTime createdDate,
    required DateTime lastLogin,
  }) {
    final TextStyle labelStyle = Theme.of(context).textTheme.bodySmall!
        .copyWith(color: AppColors.whiteColor, fontWeight: FontWeight.bold);
    final TextStyle valueStyle = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(color: AppColors.whiteColor,fontSize: 15);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Padding(
          padding:   EdgeInsets.only(top: 30, bottom: isAdmin?12:30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _itemCard(
                    context,
                    "Likes",
                    totalLikes,
                    FontAwesomeIcons.heart,
                  ),
                  _divider(),
                  _itemCard(
                    context,
                    "Comments",
                    totalComments,
                    FontAwesomeIcons.comment,
                  ),
                  _divider(),
                  _itemCard(
                    context,
                    "Posts",
                    totalPosts,
                    FontAwesomeIcons.noteSticky,
                  ),
                ],
              ),
             isAdmin? const SizedBox(height: 20):SizedBox.shrink(),
              // Info Card
          isAdmin?    Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                        Icons.credit_score_sharp,
                        "Created",
                        createdDate,
                        labelStyle,
                        valueStyle,
                      ),
                      const SizedBox(height: 10),
                      _infoRow(
                        Icons.calendar_month_sharp,
                        "Last Login",
                        lastLogin,
                        labelStyle,
                        valueStyle,
                      ),
                    ],
                  ),
                ),
              ):SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  // Stats Card
  static Widget _itemCard(
    BuildContext context,
    String title,
    int count,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              NumberFormatter.formatCount(count),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            FaIcon(icon, size: 15, color: AppColors.primaryColor),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.pureBlack,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Divider between stats
  static Widget _divider() =>
      Container(width: 1, height: 30, color: AppColors.gray);

  // Info Row
  static Widget _infoRow(
    IconData icon,
    String label,
    DateTime? value, 
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.whiteColor, size: 20),
        const SizedBox(width: 5),
        Text("$label : ", style: labelStyle),
        Text(
          value != null ? _formatCustomDate(value) : "N/A",
          style: valueStyle,
        ),
      ],
    );
  }

  // Format DateTime to "2025 Dec 12 at 12.20 PM"
  static String _formatCustomDate(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('yy MMM dd');
    final DateFormat timeFormat = DateFormat('hh.mm a');

    String formattedDate = dateFormat.format(dateTime);
    String formattedTime = timeFormat.format(dateTime);

    return '$formattedDate at $formattedTime';
  }
}
