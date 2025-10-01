import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/pages/notice/widgets/date.time.cal.dart';

class NoticeCard extends StatefulWidget {
  final String title;
  final String body;
  final DateTime date;
  final String time;
  final String mainImage;
  const NoticeCard({
    super.key,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    required this.mainImage,
  });

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DatetimeCal().formatDateOrTime(widget.date, true),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  DatetimeCal().formatDateOrTime(widget.date, false),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                width: double.infinity,
                height: 200,
                imageUrl: widget.mainImage,
                cacheKey: widget.mainImage,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text(
              widget.body,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
