import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PendingIcon extends StatelessWidget {
  const PendingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
       
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.youtubeColor,
      ),
      child: Center(
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: AppColors.whiteColor,
                size: 15,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    "This post is under review and will be approved soon.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
