import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/app.buttons.dart';

class LostConnectionAlert {
  static void showAlert(BuildContext context,
      {required VoidCallback onCheckAgain}) {
    final theme = Theme.of(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.primaryColor,
                  size: 64,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "You're Offline",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Please check your internet connection to continue using the app.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Troubleshooting Tips:",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildTroubleshootingTip(
                        theme, "1. Verify your mobile data or Wi-Fi settings."),
                    _buildTroubleshootingTip(
                        theme, "2. Try closing and reopening the application."),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: AppButtons(
                  text: "Check again",
                  isPrimary: true,
                  height: 40,
                  icon: Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                   
                  onTap: () {
                    dialogContext.pop();

                    onCheckAgain();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTroubleshootingTip(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Text(
        text,
        style: theme.textTheme.bodySmall!.copyWith(
          color: AppColors.gray,
          height: 1.4,
        ),
      ),
    );
  }
}
