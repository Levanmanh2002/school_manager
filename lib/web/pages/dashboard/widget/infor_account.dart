import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/pages/language/language_value.dart';
import 'package:school_web/web/pages/notifications/notifications.dart';
import 'package:school_web/web/pages/search/search_view.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/images.dart';

class InforAccount extends StatefulWidget {
  const InforAccount({
    super.key,
    required this.isClearVisible,
    required this.searchController,
    required this.authController,
    required this.sideBarController,
  });

  final ValueNotifier<bool> isClearVisible;
  final TextEditingController searchController;
  final AuthenticationController authController;
  final SideBarController sideBarController;

  @override
  State<InforAccount> createState() => _InforAccountState();
}

class _InforAccountState extends State<InforAccount> {
  final languageNotifier = ValueNotifier<Language>(Language.english);
  late Map<String, dynamic>? language;
  late Language currentLanguage;
  Function(Locale)? changeLocale;

  @override
  void initState() {
    super.initState();
    getLocale().then((value) {
      currentLanguage = value;
      languageNotifier.value = value;
    });
  }

  @override
  void dispose() {
    languageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      // return _buildColumnInforAccount(context);
      return const SizedBox.shrink();
    } else {
      return _buildRowInforAccount(context);
    }
  }

  Widget _buildColumnInforAccount(BuildContext context) {
    return Container(
      color: appTheme.whiteColor,
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NotificationsView(sideBarController: widget.sideBarController),
                const SizedBox(width: 16),
                Container(
                  height: 56,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: appTheme.background700Color,
                  ),
                  child: Row(
                    children: [
                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //     widget.authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                      //   ),
                      //   radius: 25,
                      // ),

                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.authController.teacherData.value?.fullName ?? 'EDU Management',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: appTheme.blackColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.authController.teacherData.value?.system == 1
                                ? 'Admin'
                                : widget.authController.teacherData.value?.system == 2
                                    ? 'Manager'
                                    : widget.authController.teacherData.value?.system == 3
                                        ? 'Teacher'
                                        : widget.authController.teacherData.value?.system == 4
                                            ? 'System'
                                            : 'EDU Management',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: appTheme.textDesColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_drop_down_outlined, size: 30, color: appTheme.textDesColor),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: appTheme.background700Color,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appTheme.blackColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down_outlined, size: 30, color: appTheme.textDesColor),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 24),
            // SearchView(
            //   isClearVisible: isClearVisible,
            //   searchController: searchController,
            //   vertical: 24,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInforAccount(BuildContext context) {
    return Obx(
      () => Container(
        color: appTheme.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: SearchView(
                isClearVisible: widget.isClearVisible,
                searchController: widget.searchController,
                vertical: 12,
              ),
            ),
            const SizedBox(width: 150),
            NotificationsView(sideBarController: widget.sideBarController),
            const SizedBox(width: 16),
            InkWell(
              onTap: () => Get.toNamed(Routes.PROFILE),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: appTheme.background700Color,
                ),
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage(
                    //     widget.authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                    //   ),
                    //   radius: 25,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: CachedNetworkImage(
                        imageUrl: widget.authController.teacherData.value?.avatarUrl.toString() ?? '',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.authController.teacherData.value?.fullName ?? 'EDU Management',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: appTheme.blackColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.authController.teacherData.value?.system == 1
                              ? 'Admin'
                              : widget.authController.teacherData.value?.system == 2
                                  ? 'Manager'
                                  : widget.authController.teacherData.value?.system == 3
                                      ? 'Teacher'
                                      : widget.authController.teacherData.value?.system == 4
                                          ? 'System'
                                          : 'EDU Management',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: appTheme.textDesColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.arrow_drop_down_outlined, size: 30, color: appTheme.textDesColor),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
            // const SizedBox(width: 24),
            // Container(
            //   height: 56,
            //   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(40),
            //     color: const Color(0xFFF7F7FC),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         height: 100,
            //         width: 300,
            //         child: ValueListenableBuilder(
            //           valueListenable: languageNotifier,
            //           builder: (context, value, child) =>
            //               child ??
            //               ListView(
            //                 padding: const EdgeInsets.only(bottom: 50),
            //                 children: getLanguageListWithContext(context)
            //                     .map(
            //                       (language) => language == null
            //                           ? const SizedBox()
            //                           : Padding(
            //                               padding: EdgeInsets.only(top: language['languageCode'] != 'vi' ? 0 : 0),
            //                               child: LanguageWidgets(
            //                                 flagCode: language['flag_code'].toString(),
            //                                 languageCode: language['languageCode'].toString(),
            //                                 countryCode: language['countryCode'] as String? ?? '',
            //                                 languageIcon: language['icon'].toString(),
            //                                 languageText: language['text'].toString(),
            //                                 languageValue: language['value'] as Language,
            //                                 onLanguageTap: (languageCode, countryCode, lang) {
            //                                   this.language = language;
            //                                   if (countryCode != null) {
            //                                     someFunction(context, Locale(languageCode, countryCode));
            //                                   } else {
            //                                     someFunction(context, Locale(languageCode));
            //                                   }
            //                                   // Navigator.pop(context);
            //                                   if (lang != null) {
            //                                     languageNotifier.value = lang;
            //                                   }
            //                                 },
            //                                 groupValue: value,
            //                               ),
            //                             ),
            //                     )
            //                     .toList(),
            //               ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
