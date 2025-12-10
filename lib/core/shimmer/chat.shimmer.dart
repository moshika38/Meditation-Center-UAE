import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatInboxShimmer extends StatelessWidget {
  final int itemCount;
  const ChatInboxShimmer({super.key, this.itemCount = 15});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;
    final screenWidth = MediaQuery.of(context).size.width;

    final avatarSize = screenWidth * 0.135;
    final nameWidth = screenWidth * 0.45;
    final messageWidth = screenWidth * 0.6;
    final timeWidth = screenWidth * 0.11;
    final dotSize = screenWidth * 0.033;

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      itemCount: itemCount,
      separatorBuilder: (_, __) => Divider(height: 0),
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.033,
            vertical: screenWidth * 0.026,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.033),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: nameWidth,
                        height: avatarSize * 0.25,
                        color: baseColor,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: messageWidth,
                        height: avatarSize * 0.21,
                        color: baseColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.033),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: timeWidth,
                      height: avatarSize * 0.21,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: baseColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
