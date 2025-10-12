import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class PostCardComponents {
  static Widget imageCard(
    BuildContext context,
    bool lastChild,
    int length,
    String imageUrl1,
    String imageUrl2,
  ) {
    return Row(
      mainAxisAlignment: length == 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          width: length == 1
              ? MediaQuery.of(context).size.width * 0.85
              : MediaQuery.of(context).size.width * 0.43,
          height: length == 1 ? null : 200,
          imageUrl: imageUrl1,
          cacheKey: imageUrl1,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          placeholder: (context, url) => Icon(Icons.downloading_rounded),
        ),
        imageUrl2 != "null"
            ? Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl2,
                    cacheKey: imageUrl2,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    width: MediaQuery.of(context).size.width * 0.43,
                    height: 200,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholder: (context, url) =>
                        Icon(Icons.downloading_rounded),
                  ),
                  lastChild && length > 4
                      ? Container(
                          color: const Color.fromARGB(143, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.43,
                          height: 200,
                          child: Center(
                            child: Text(
                              "${length - 4} +",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              )
            : SizedBox.shrink(),
      ],
    );
  }

  static Widget actionBtn(
    BuildContext context,
    IconData icon,
    String text,
    bool isColors,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // ignore: deprecated_member_use
          color: AppColors.gray.withOpacity(0.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isColors ? AppColors.primaryColor : AppColors.gray,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color:
                        isColors ? AppColors.primaryColor : AppColors.textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
