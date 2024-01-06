// ignore_for_file: lines_longer_than_80_chars, prefer_null_aware_method_calls, public_member_api_docs

import 'package:flutter/material.dart';
import 'package:school_web/web/pages/language/language_value.dart';

class LanguageWidgets extends StatelessWidget {
  const LanguageWidgets({
    required this.languageCode,
    required this.languageIcon,
    required this.languageText,
    required this.languageValue,
    required this.groupValue,
    required this.flagCode,
    required this.countryCode,
    this.onLanguageTap,
    super.key,
  });

  final String languageCode;
  final String countryCode;
  final String languageIcon;
  final String languageText;
  final Language languageValue;
  final String flagCode;
  final Language? groupValue;
  final void Function(String, String?, Language?)? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onLanguageTap != null) {
          onLanguageTap!(languageCode, countryCode, languageValue);
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: languageValue == groupValue ? const Color(0xFFFF9F29) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE2E8F0)),
                  child: Text(languageIcon, style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 16),
                Text(
                  countryCode,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                if (languageValue == groupValue) ...[
                  Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(color: Color(0xFFFF9F29), shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ] else ...[
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      shape: BoxShape.circle,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
