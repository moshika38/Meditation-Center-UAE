import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UploadPageShimmer extends StatelessWidget {
  const UploadPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final verticalSpacing = size.height * 0.025;
    final textInputHeight = size.height * 0.17;
    final buttonHeight = size.height * 0.065;
    final buttonWidth = size.width * 0.44;
    final borderRadius = 8.0;
    final gridSpacing = size.width * 0.025;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: verticalSpacing),

          // TextInput shimmer
          Container(
            height: textInputHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),

          SizedBox(height: verticalSpacing),

          // Buttons shimmer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: buttonHeight,
                width: buttonWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              Container(
                height: buttonHeight,
                width: buttonWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ],
          ),

          SizedBox(height: verticalSpacing),

          // Grid shimmer (2x2)
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: gridSpacing,
                mainAxisSpacing: gridSpacing,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
