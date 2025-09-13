import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class TextInput {
  static Widget textFormField(
    BuildContext context,
    TextEditingController controller,
    bool isEnabled,
  ) {
    return TextFormField(
      autofocus: false,
      enabled: isEnabled,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'What\'s on your mind?',
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.gray,
            ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
