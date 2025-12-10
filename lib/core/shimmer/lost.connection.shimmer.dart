import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:shimmer/shimmer.dart';

class GenericLostConnectionShimmer extends StatelessWidget {
  final int itemCount;

  const GenericLostConnectionShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingHorizontal = size.width * 0.04;
    final paddingVertical = size.height * 0.025;
    final itemHeight = size.height * 0.15;
    final titleHeight = size.height * 0.018;
    final subtitleHeight = size.height * 0.015;
    final footerWidth = size.width * 0.2;
    final footerHeight = size.height * 0.012;

    return Shimmer.fromColors(
      baseColor: AppColors.gray.withOpacity(0.3),
      highlightColor: AppColors.gray.withOpacity(0.1),
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        child: Column(
          children: [
            SizedBox(height: paddingVertical),
            ...List.generate(itemCount, (index) => _buildItemPlaceholder(
                  itemHeight,
                  titleHeight,
                  subtitleHeight,
                )),
            SizedBox(height: paddingVertical),
            _buildFooterPlaceholder(footerWidth, footerHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildItemPlaceholder(double itemHeight, double titleHeight, double subtitleHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: subtitleHeight * 2),
      child: Container(
        padding: EdgeInsets.all(titleHeight),
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: itemHeight,
              color: AppColors.gray,
              margin: EdgeInsets.only(bottom: subtitleHeight * 2),
            ),
            Container(
              width: double.infinity,
              height: titleHeight,
              color: AppColors.gray,
              margin: EdgeInsets.only(bottom: subtitleHeight),
            ),
            Container(
              width: 200,
              height: subtitleHeight,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPlaceholder(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        3,
        (index) => Container(
          width: width,
          height: height,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
