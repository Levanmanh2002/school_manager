import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/pages/dashboard/widget/infor_account.dart';
import 'package:school_web/web/pages/notifications/notifications.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthenticationController authController = Get.put(AuthenticationController());
  bool isExpanded = true;
  final sideBarController = SideBarController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    authController.getProfileData();
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    isClearVisible.dispose();
    sideBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: appTheme.whiteColor,
              iconTheme: IconThemeData(color: appTheme.blackColor),
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trang chủ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5, color: appTheme.blackColor),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        'Chào buổi sáng, ${authController.teacherData.value?.fullName ?? 'EDU Management'}! ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: appTheme.textDesColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                NotificationsView(sideBarController: sideBarController),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
                const SizedBox(width: 16),
              ],
            )
          : null,
      drawer: Drawer(
        child: sideBarMe(),
      ),
      body: Row(
        children: [
          Expanded(
            flex: Responsive.isMobile(context) ? 0 : 1,
            child: Responsive.isMobile(context) ? const SizedBox.shrink() : sideBarMe(),
          ),
          Expanded(
            flex: Responsive.isTablet(context) ? 8 : 5,
            child: Column(
              children: [
                InforAccount(
                  isClearVisible: isClearVisible,
                  searchController: searchController,
                  authController: authController,
                  sideBarController: sideBarController,
                ),
                Expanded(
                  child: Obx(
                    () => sideBarController.pageRoutes[sideBarController.index.value],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(String title, String icon, int index, SideBarController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: controller.index.value == index ? appTheme.whiteColor : null,
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: Responsive.isTablet(context) ? MainAxisAlignment.center : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              color: controller.index.value == index ? appTheme.appColor : null,
            ),
            Responsive.isTablet(context) ? const SizedBox.shrink() : const SizedBox(width: 8),
            Responsive.isTablet(context)
                ? const SizedBox.shrink()
                : Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
          ],
        ),
        onTap: () {
          controller.index.value = index;
          Responsive.isMobile(context) ? Navigator.pop(context) : null;
        },
        selected: controller.index.value == index,
        selectedColor: appTheme.appColor,
        selectedTileColor: appTheme.appColor,
        iconColor: appTheme.whiteColor,
        textColor: appTheme.whiteColor,
      ),
    );
  }

  Widget sideBarMe() {
    return Container(
      color: appTheme.appColor,
      child: Obx(
        () => Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Responsive.isTablet(context)
                      ? const SizedBox.shrink()
                      : Image.asset(ImagesAssets.adminImage, width: 40, height: 40),
                  Responsive.isTablet(context) ? const SizedBox.shrink() : const SizedBox(width: 12),
                  Responsive.isTablet(context)
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: Text(
                            'EDU Management',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.whiteColor),
                          ),
                        ),
                  Responsive.isTablet(context) ? const SizedBox.shrink() : const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: SvgPicture.asset(IconAssets.sideBarIcon, width: 24, height: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    buildListTile('Trang chủ', IconAssets.homeIcon, 0, sideBarController),
                    buildListTile('Giáo viên', IconAssets.teacherIcon, 1, sideBarController),
                    buildListTile('Học sinh', IconAssets.studentIcon, 2, sideBarController),
                    buildListTile('Lớp học', IconAssets.bookOpenIcon, 3, sideBarController),
                    buildListTile('Ngành học', IconAssets.booksIcon, 4, sideBarController),
                    buildListTile('Học phí', IconAssets.moneyIcon, 5, sideBarController),
                    buildListTile('Các khoản thu khác', IconAssets.revenueIcon, 6, sideBarController),
                    buildListTile('Học sinh chuyển lớp', IconAssets.tranferIcon, 7, sideBarController),
                    // buildListTile('Quản lý đánh giá', IconAssets.evaluateIcon, 9, controller),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Responsive.isTablet(context)
                ? const SizedBox.shrink()
                : Image.asset(
                    ImagesAssets.eduImage,
                    width: 240,
                    height: 150,
                  ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.PROFILE);
                },
                child: Row(
                  mainAxisAlignment: Responsive.isTablet(context) ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage(
                    //     authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                    //   ),
                    //   radius: 20,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: CachedNetworkImage(
                        imageUrl: authController.teacherData.value?.avatarUrl.toString() ?? '',
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                        },
                      ),
                    ),
                    Responsive.isTablet(context) ? const SizedBox.shrink() : const SizedBox(width: 17),
                    Responsive.isTablet(context)
                        ? const SizedBox.shrink()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authController.teacherData.value?.fullName ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: appTheme.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authController.teacherData.value?.system == 1
                                    ? 'Admin'
                                    : authController.teacherData.value?.system == 2
                                        ? 'Manager'
                                        : authController.teacherData.value?.system == 3
                                            ? 'Teacher'
                                            : authController.teacherData.value?.system == 4
                                                ? 'System'
                                                : 'EDU Management',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: appTheme.whiteColor,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                authController.logout();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: Responsive.isTablet(context)
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.primary50Color,
                        ),
                        child: SvgPicture.asset(IconAssets.logoutIcon, width: 20, height: 20),
                      )
                    : Container(
                        width: double.maxFinite,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.primary50Color,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đăng xuất',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: appTheme.appColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(IconAssets.logoutIcon, width: 20, height: 20),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
