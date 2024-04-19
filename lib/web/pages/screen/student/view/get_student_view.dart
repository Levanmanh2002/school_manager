// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';

import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/controllers/student/student_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/build_student_card_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_student_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class GetStudentView extends StatefulWidget {
  const GetStudentView({super.key});

  @override
  State<GetStudentView> createState() => _GetStudentViewState();
}

class _GetStudentViewState extends State<GetStudentView> with TickerProviderStateMixin {
  late TabController _tabListController;
  final searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  final HomeController homeController = Get.put(HomeController());
  final AuthenticationController authController = Get.put(AuthenticationController());
  final StudentController studentController = Get.put(StudentController());

  ValueNotifier<int> tabSelected = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabListController = TabController(length: 6, vsync: this);
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });

    _tabListController.addListener(() {
      tabSelected.value = _tabListController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabListController.dispose();
    searchController.dispose();
    isClearVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
            : const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Quản lý học sinh',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 18 : 24,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blackColor,
                    ),
                  ),
                ),
                Responsive.isMobile(context) ? const Spacer() : const SizedBox.shrink(),
                Responsive.isMobile(context) ? ItemOnTap(authController: authController) : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFFFFFFF),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x143A73C2),
                    blurRadius: 8.0,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color(0x143A73C2),
                    blurRadius: 8.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Danh sách học sinh',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF373743),
                            height: 1.5,
                          ),
                        ),
                      ),
                      Responsive.isMobile(context) ? const SizedBox.shrink() : const Spacer(),
                      Responsive.isMobile(context)
                          ? const SizedBox.shrink()
                          : ItemOnTap(authController: authController),
                    ],
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: tabSelected,
                    builder: (context, selectedTab, child) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selectedTab == 0
                                ? appTheme.primary50Color
                                : selectedTab == 1
                                    ? appTheme.green100Color
                                    : selectedTab == 2
                                        ? appTheme.green100Color
                                        : selectedTab == 3
                                            ? appTheme.yellow100Color
                                            : selectedTab == 4
                                                ? appTheme.strokeColor
                                                : selectedTab == 5
                                                    ? appTheme.red100Color
                                                    : appTheme.primary50Color,
                          ),
                          child: Text(
                            selectedTab == 0
                                ? 'Tất cả: ${homeController.totalAll}'
                                : selectedTab == 1
                                    ? 'Đang học: ${homeController.activeStudents}'
                                    : selectedTab == 2
                                        ? 'Học sinh mới: ${homeController.totalNewStudent}'
                                        : selectedTab == 3
                                            ? 'Nghỉ học: ${homeController.selfSuspendedStudents}'
                                            : selectedTab == 4
                                                ? 'Đình chỉ: ${homeController.suspendedStudents}'
                                                : selectedTab == 5
                                                    ? 'Bị buổi học: ${homeController.expelledStudents}'
                                                    : '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedTab == 0
                                  ? appTheme.appColor
                                  : selectedTab == 1
                                      ? appTheme.successColor
                                      : selectedTab == 2
                                          ? appTheme.successColor
                                          : selectedTab == 3
                                              ? appTheme.yellow500Color
                                              : selectedTab == 4
                                                  ? appTheme.textDesColor
                                                  : selectedTab == 5
                                                      ? appTheme.errorColor
                                                      : appTheme.appColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Expanded(
                            child: TabBar(
                              key: ValueKey<int>(tabSelected.value),
                              controller: _tabListController,
                              isScrollable: true,
                              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              labelColor: appTheme.appColor,
                              unselectedLabelColor: appTheme.textDesColor,
                              indicatorColor: appTheme.appColor,
                              indicatorWeight: 1,
                              tabs: const [
                                Tab(text: 'Tất cả'),
                                Tab(text: 'Đang học'),
                                Tab(text: 'Học sinh mới'),
                                Tab(text: 'Nghỉ học'),
                                Tab(text: 'Đình chỉ'),
                                Tab(text: 'Bị đuổi học'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Responsive.isMobile(context)
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: isClearVisible,
                                builder: (context, isVisible, child) {
                                  return TextFormField(
                                    controller: searchController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
                                      LengthLimitingTextInputFormatter(25),
                                      NoInitialSpaceInputFormatterWidgets(),
                                    ],
                                    onChanged: (value) {
                                      studentController.searchAllStudent(value);
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: const Color(0xFFF7F7FC),
                                      filled: true,
                                      hintText: 'Tìm kiếm',
                                      hintStyle: StyleThemeData.styleSize16Weight400(color: appTheme.textDesColor),
                                      prefixIcon: Container(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.only(start: 12),
                                          child: SvgPicture.asset(IconAssets.searchIcon, width: 20, height: 20),
                                        ),
                                      ),
                                      suffix: isVisible
                                          ? InkWell(
                                              onTap: () {
                                                searchController.clear();
                                                isClearVisible.value = false;
                                                studentController.searchAllStudent('');
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Container(
                                                  padding: const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: appTheme.textDesColor,
                                                  ),
                                                  child: Icon(
                                                    Icons.clear_rounded,
                                                    color: appTheme.whiteColor,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(41),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 649),
                    child: TabBarView(
                      controller: _tabListController,
                      children: [
                        tabBarView1(),
                        tabBarView2(),
                        tabBarView3(),
                        tabBarView4(),
                        tabBarView5(),
                        tabBarView6(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBarView1() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredAllStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredAllStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarView2() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredActiveStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredActiveStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarView3() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredActiveStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredActiveStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarView4() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredInactiveStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredInactiveStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarView5() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredSuspendedStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredSuspendedStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarView6() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isTablet(context)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.26,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentController.filteredExpelledStudents.length,
                  itemBuilder: (context, index) {
                    final student = studentController.filteredExpelledStudents[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemOnTap extends StatelessWidget {
  const ItemOnTap({
    super.key,
    required this.authController,
  });

  final AuthenticationController authController;

  @override
  Widget build(BuildContext context) {
    final SideBarController sideBarController = Get.put(SideBarController());

    return InkWell(
      onTap: () => authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2
          ? sideBarController.index.value = 10
          : showNoSystemWidget(
              context,
              title: 'Bạn không có quyền giáo viên',
              des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
              cancel: 'Hủy',
              confirm: 'Xác nhận',
              ontap: () => Navigator.pop(context),
            ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: appTheme.appColor,
        ),
        child: Row(
          children: [
            SvgPicture.asset(IconAssets.studentIcon),
            const SizedBox(width: 8),
            Text(
              'Thêm học sinh',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
