import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.onTap,
    required this.text,
    required this.clearOntap,
    this.des = '',
    this.showClear = false,
    super.key,
  });

  final VoidCallback onTap;
  final String text;
  final VoidCallback clearOntap;
  final String des;
  final bool showClear;

  static final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      ImagesAssets.chemistryImage,
      ImagesAssets.groupImage,
      ImagesAssets.languageImage,
      ImagesAssets.mathImage,
      ImagesAssets.timeImage,
      ImagesAssets.vlanImage,
    ];

    final List<Color> colorList = [
      AppColors.redColor,
      AppColors.primaryColor,
      AppColors.yellow500Color,
      AppColors.blue500Color,
      AppColors.green500Color,
    ];

    final String imageRandom = imageList[_random.nextInt(imageList.length)];
    final Color colorRamdom = colorList[_random.nextInt(colorList.length)];

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Responsive.isMobile(context) ? 160 : 252,
            height: 204,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.whiteColor,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x147E8695),
                  offset: Offset(0, 8),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageRandom,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorRamdom,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    des,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          if (showClear)
            Positioned(
              top: -4,
              right: -8,
              child: InkWell(
                onTap: clearOntap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textDesColor,
                  ),
                  child: const Icon(Icons.clear, size: 16, color: AppColors.whiteColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
