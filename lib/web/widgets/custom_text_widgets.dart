import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_web/web/constants/style.dart';

class CustomTextWidgets extends StatelessWidget {
  const CustomTextWidgets({
    super.key,
    this.controller,
    required this.title,
    this.initialData,
    this.color = AppColors.blackColor,
    this.keyboardType = TextInputType.text,
    this.validator = false,
    this.style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
    this.enabled = true,
    this.prefixIcon,
    this.boolTitle = false,
    this.colorHint = AppColors.trokeColor,
    this.inputFormatters,
    this.hintText = '',
  });

  final String title;
  final String? initialData;
  final Color color;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool validator;
  final TextStyle? style;
  final bool enabled;
  final Icon? prefixIcon;
  final bool boolTitle;
  final Color colorHint;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        boolTitle == true
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Container(alignment: Alignment.topLeft, child: Text(title, style: style)),
                  validator ? const SizedBox(width: 4) : const SizedBox.shrink(),
                  validator
                      ? const Text(
                          '*',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.redColor),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            isDense: true,
            hintText: enabled == false ? initialData : hintText,
            hintStyle: TextStyle(color: colorHint, fontSize: 14, fontWeight: FontWeight.w400),
            errorStyle: const TextStyle(color: Colors.red),
            labelStyle: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w400),
            border: const OutlineInputBorder(),
            prefix: const SizedBox(width: 12),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            prefixIcon: prefixIcon,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD2D5DA)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD2D5DA)),
            ),
            // suffixIcon: controller!.value.text.isNotEmpty
            //     ? InkWell(
            //         onTap: () {
            //           controller!.clear();
            //         },
            //         child: const Icon(Icons.clear))
            //     : null,
          ),
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color),
          validator: (value) {
            if (validator != false) {
              if (value == null || value.isEmpty) {
                return 'Thông tin không được để trống';
              }
            } else {
              null;
            }

            return null;
          },
        ),
      ],
    );
  }
}
