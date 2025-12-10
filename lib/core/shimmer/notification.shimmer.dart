import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  final int itemCount;
  const NotificationShimmer({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;
    final avatarSize = size.width * 0.12;
    final spacing = size.width * 0.03;
    final textHeight = size.height * 0.018;
    final textShortWidth = size.width * 0.5;
    final containerPadding = size.width * 0.03;
    final borderRadius = 12.0;

    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return ListView.separated(
      itemCount: itemCount,
      padding: EdgeInsets.all(padding),
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            padding: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: textHeight,
                        width: double.infinity,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: spacing * 0.5),
                      Container(
                        height: textHeight,
                        width: textShortWidth,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
