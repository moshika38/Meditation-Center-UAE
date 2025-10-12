// notice_card_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class NoticeCardShimmer extends StatelessWidget {
  const NoticeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: AppColors.gray
                // ignore: deprecated_member_use
                .withOpacity(0.2),  
            highlightColor: AppColors.gray
                // ignore: deprecated_member_use
                .withOpacity(0.1), 
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.gray.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row for date and time placeholders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
        
                  // Image placeholder
                  Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
        
                  // Body text placeholders
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 150,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
        
                  // Button placeholder
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
