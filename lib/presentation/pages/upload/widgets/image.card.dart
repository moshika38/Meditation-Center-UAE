import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:meditation_center/presentation/pages/upload/widgets/video.player.dart';


class ImageCard {
  static Widget imageCard(
    String mediaPath,
    VoidCallback deleteImage,
    bool isReel,
  ) {
    Widget mediaContent;

    if (isReel) {
      mediaContent = VideoPlayerWidget(videoPath: mediaPath);
    } else {
      mediaContent = Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(mediaPath),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: AppColors.textColor.withOpacity(0.4),
            child: Center(
              child: IconButton(
                onPressed: deleteImage,
                icon: Icon(
                  Icons.delete,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return mediaContent;
  }
}

 
