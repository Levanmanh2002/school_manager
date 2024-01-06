import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/web/l10n/l10n.dart';
import 'package:school_web/web/utils/assets/icons.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
    required this.isClearVisible,
    required this.searchController,
    this.vertical = 16,
  });

  final ValueNotifier<bool> isClearVisible;
  final TextEditingController searchController;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isClearVisible,
      builder: (context, isVisible, child) {
        return TextFormField(
          controller: searchController,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
            LengthLimitingTextInputFormatter(25),
          ],
          decoration: InputDecoration(
            isDense: true,
            fillColor: const Color(0xFFF7F7FC),
            filled: true,
            hintText: context.l10n.search_text,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7E8695),
            ),
            prefixIcon: Container(
              width: 18,
              height: 18,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: SvgPicture.asset(IconAssets.searchIcon, width: 18, height: 18),
              ),
            ),
            suffix: isVisible
                ? InkWell(
                    onTap: () {
                      searchController.clear();
                      isClearVisible.value = false;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7E8695),
                        ),
                        child: const Icon(Icons.clear_rounded, color: Colors.white, size: 12),
                      ),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(41),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: vertical),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(41),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(41),
              borderSide: const BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(41),
              borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(41),
              borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
            ),
          ),
        );
      },
    );
  }
}
