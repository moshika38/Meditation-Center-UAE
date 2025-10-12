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
    return Shimmer.fromColors(
      // ignore: deprecated_member_use
      baseColor: AppColors.gray.withOpacity(0.3),
      // ignore: deprecated_member_use
      highlightColor: AppColors.gray.withOpacity(0.1),
      period: const Duration(milliseconds: 1500),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ...List.generate(itemCount, (index) => _buildItemPlaceholder()),
            const SizedBox(height: 20),
            _buildFooterPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              color: AppColors.gray,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Container(
              width: double.infinity,
              height: 14,
              color: AppColors.gray,
              margin: const EdgeInsets.only(bottom: 8),
            ),
            Container(
              width: 200,
              height: 12,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPlaceholder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        3,
        (index) => Container(
          width: 80,
          height: 10,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
