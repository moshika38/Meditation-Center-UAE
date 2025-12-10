import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoticeViewerShimmer extends StatelessWidget {
  const NoticeViewerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    final titleHeight = size.height * 0.022;
    final bodyHeight = size.height * 0.018;
    final spacingSmall = size.height * 0.01;
    final spacingMedium = size.height * 0.025;
    final titleShortWidth = size.width * 0.5;
    final bodyShortWidth = size.width * 0.35;
    final imageHeight = size.height * 0.25;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer (2 lines)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: titleHeight,
                  color: Colors.white,
                ),
                SizedBox(height: spacingSmall),
                Container(
                  width: titleShortWidth,
                  height: titleHeight,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          SizedBox(height: spacingMedium),

          // Image shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: imageHeight,
              color: Colors.white,
            ),
          ),

          SizedBox(height: spacingMedium),

          // Body shimmer (2–3 lines)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: bodyHeight,
                  color: Colors.white,
                ),
                SizedBox(height: spacingSmall),
                Container(
                  width: double.infinity,
                  height: bodyHeight,
                  color: Colors.white,
                ),
                SizedBox(height: spacingSmall),
                Container(
                  width: bodyShortWidth,
                  height: bodyHeight,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
