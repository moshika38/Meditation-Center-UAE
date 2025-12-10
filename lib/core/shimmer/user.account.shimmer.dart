import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    final profileSize = size.width * 0.35;
    final spacingSmall = size.height * 0.015;
    final spacingMedium = size.height * 0.03;
    final spacingLarge = size.height * 0.08;
    final postsHeight = size.height * 0.05;
    final postsWidth = size.width * 0.5;
    final labelHeight = size.height * 0.03;
    final labelWidth = size.width * 0.4;
    final listItemHeight = size.height * 0.35;
    final listItemWidth = size.width * 0.8;
    final borderRadiusProfile = profileSize / 2;
    final borderRadiusCard = 10.0;
    final borderRadiusPosts = 20.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: spacingMedium),

            // Profile card shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: profileSize,
                height: profileSize,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(borderRadiusProfile),
                ),
              ),
            ),

            SizedBox(height: spacingSmall),

            // Posts count shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: postsWidth,
                height: postsHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(borderRadiusPosts),
                ),
              ),
            ),

            SizedBox(height: spacingLarge),

            // Public posts label shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: labelWidth,
                height: labelHeight,
                color: Colors.grey[300],
              ),
            ),

            SizedBox(height: spacingSmall),

            // List shimmer
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: spacingSmall),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: listItemWidth,
                      height: listItemHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(borderRadiusCard),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
