import 'package:flutter/material.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class UserCard extends StatelessWidget {
  final String imageUrl;
  final bool isEdit;
  final VoidCallback selectImage;
  final bool? isDarkBorder;
  const UserCard({
    super.key,
    required this.imageUrl,
    required this.isEdit,
    required this.selectImage,
    this.isDarkBorder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:isDarkBorder==true?AppColors.textColor:AppColors.secondaryColor,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.secondaryColor.withOpacity(0.2),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                    errorBuilder: (context, error, stackTrace) {
                      // On error, show fallback image
                      return Image.network(
                        AppData.baseUserUrl,
                        fit: BoxFit.cover,
                        width: 110,
                        height: 110,
                      );
                    },
                  ),
                ),
              )),
          isEdit
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryColor,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
