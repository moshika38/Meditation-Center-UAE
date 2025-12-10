import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentShimmer extends StatelessWidget {
  final int itemCount;
  const CommentShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarWidth = screenWidth * 0.105;
    final avatarHeight = screenWidth * 0.26;
    final bubbleHeight = screenWidth * 0.078;
    final bubbleWidth = screenWidth * 0.6;
    final spacing = screenWidth * 0.033;

    return ListView.separated(
      reverse: true,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: avatarWidth,
                height: avatarHeight,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: bubbleHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(0.02 * screenWidth),
                      ),
                    ),
                    SizedBox(height: spacing * 0.18),
                    Container(
                      width: bubbleWidth,
                      height: bubbleHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(0.02 * screenWidth),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
