import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/components/user.card.dart';

class UserDataCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String email;
  final bool isDarkText;

  const UserDataCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.email,
    required this.isDarkText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserCard(
          imageUrl: imageUrl,
          isEdit: false,
          selectImage: () {},
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color:isDarkText?AppColors.textColor: AppColors.whiteColor,
              ),
        ),
        Text(
          email,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color:isDarkText?AppColors.textColor: AppColors.whiteColor,
              ),
        ),
      ],
    );
  }
}
