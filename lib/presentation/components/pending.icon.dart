import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PendingIcon extends StatelessWidget {
  const PendingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.primaryColor,
      ),
      child: Center(
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: AppColors.whiteColor,
              size: 15,
            ),
            const SizedBox(width: 8),
            Text(
                "Pending",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.whiteColor,
                ),
            
            ),
          ],
        ),
      ),
    );
  }
}
