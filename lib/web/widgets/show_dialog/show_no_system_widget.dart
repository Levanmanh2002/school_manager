import 'package:flutter/material.dart';
import 'package:school_web/web/constants/style.dart';

void showNoSystemWidget(
  BuildContext context, {
  required String title,
  required String des,
  required String cancel,
  required String confirm,
  required VoidCallback ontap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          constraints: const BoxConstraints(maxWidth: 311),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                des,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 131,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Text(
                        cancel,
                        style:
                            const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: ontap,
                    child: Container(
                      width: 131,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      child: Text(
                        confirm,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
