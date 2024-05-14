import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/utils/assets/images.dart';

fullImageWidget(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: 350,
          height: 350,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                width: Get.size.width,
                height: Get.size.height,
                imageUrl: imageUrl.toString(),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Image.asset(ImagesAssets.noUrlImage, width: Get.size.width, height: Get.size.height);
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.background,
                    ),
                    child: const Icon(Icons.clear, size: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
