import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PopupWindow {
  static void showPopupWindow(
    String title,
    String buttonText,
    BuildContext context,
    VoidCallback onConfirm,
    VoidCallback onCancel,
  ) {
    final theme = Theme.of(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: Text(
                      "No, Cancel",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.gray,
                  ),
                  TextButton(
                    onPressed: onConfirm,
                    child: Text(buttonText, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
