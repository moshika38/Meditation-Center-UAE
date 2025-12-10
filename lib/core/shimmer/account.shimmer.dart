import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AccountPageShimmer extends StatelessWidget {
  const AccountPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    // MediaQuery sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.25; // 25% of screen width
    final nameWidth = screenWidth * 0.4;
    final emailWidth = screenWidth * 0.6;
    final menuHeight = screenWidth * 0.18; // proportional height
    final menuRadius = 20.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          // Name shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: nameWidth,
              height: avatarSize * 0.18,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          // Email shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: emailWidth,
              height: avatarSize * 0.14,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.1),

          // Menu items shimmer
          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  height: menuHeight,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(menuRadius),
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: screenWidth * 0.125),
          // App version shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: screenWidth * 0.2,
              height: avatarSize * 0.14,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
