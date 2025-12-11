import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class AppLoading extends StatelessWidget {
  final bool? isWhite;
  const AppLoading({super.key, this.isWhite});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color:
            (isWhite ?? false) ? AppColors.whiteColor : AppColors.primaryColor,
        strokeWidth: 3,
      ),
    );
  }
}

class PageLoader extends StatelessWidget {
  const PageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureBlack.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        width: 70,
        height: 70,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  
                  color: AppColors.whiteColor,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Loading...",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
