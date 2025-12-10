import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class NoticeCardShimmer extends StatelessWidget {
  const NoticeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.025;
    final verticalPadding = size.height * 0.02;
    final dateWidth = size.width * 0.2;
    final timeWidth = size.width * 0.15;
    final imageHeight = size.height * 0.33;
    final titleHeight = size.height * 0.02;
    final bodyHeight = size.height * 0.015;
    final bodyShortWidth = size.width * 0.4;
    final buttonWidth = size.width * 0.25;
    final buttonHeight = size.height * 0.05;
    final borderRadius = 10.0;

    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: AppColors.gray.withOpacity(0.2),
            highlightColor: AppColors.gray.withOpacity(0.1),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: verticalPadding),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.15),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for date and time placeholders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: dateWidth,
                        height: bodyHeight,
                        color: Colors.white,
                      ),
                      Container(
                        width: timeWidth,
                        height: bodyHeight,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: verticalPadding),

                  // Image placeholder
                  Container(
                    width: double.infinity,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  SizedBox(height: verticalPadding),

                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: titleHeight,
                    color: Colors.white,
                  ),
                  SizedBox(height: verticalPadding * 0.5),

                  // Body text placeholders
                  Container(
                    width: double.infinity,
                    height: bodyHeight,
                    color: Colors.white,
                  ),
                  SizedBox(height: verticalPadding * 0.25),
                  Container(
                    width: double.infinity,
                    height: bodyHeight,
                    color: Colors.white,
                  ),
                  SizedBox(height: verticalPadding * 0.25),
                  Container(
                    width: bodyShortWidth,
                    height: bodyHeight,
                    color: Colors.white,
                  ),
                  SizedBox(height: verticalPadding),

                  // Button placeholder
                  Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
