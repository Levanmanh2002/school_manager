// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/build_teacher_card_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_teacher_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';
import 'package:school_web/web/pages/screen/teacher/controller/teacher_controller.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class GetTeachersView extends StatefulWidget {
  const GetTeachersView({super.key});

  @override
  State<GetTeachersView> createState() => _GetTeachersViewState();
}

class _GetTeachersViewState extends State<GetTeachersView> with TickerProviderStateMixin {
  late TabController _tabListController;
  final searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  final controller = Get.put(TeacherController());
  final AuthenticationController authController = Get.put(AuthenticationController());
  List<TeacherData> workingTeachers = [];
  List<TeacherData> retiredTeachers = [];
  ValueNotifier<int> tabSelected = ValueNotifier<int>(0);
  final ctl = SideBarController();

  @override
  void initState() {
    super.initState();
    _tabListController = TabController(length: 2, vsync: this);
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });
    if (workingTeachers.isEmpty || retiredTeachers.isEmpty) {
      fetchData();
    }
    _tabListController.addListener(() {
      tabSelected.value = _tabListController.index;
    });
  }

  Future<void> fetchData() async {
    try {
      workingTeachers = await controller.fetchWorkingTeachers();
      retiredTeachers = await controller.fetchRetiredTeachers();
      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
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
                    'Quản lý giáo viên',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 18 : 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
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
                          'Danh sách giáo viên',
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
                            color: selectedTab == 0 ? AppColors.green100Color : AppColors.yellow100Color,
                          ),
                          child: Text(
                            selectedTab == 0
                                ? 'Giáo viên đang làm việc: ${workingTeachers.length}'
                                : 'Giáo viên nghỉ việc: ${retiredTeachers.length}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedTab == 0 ? AppColors.green500Color : AppColors.yellow500Color,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      TabBar(
                        key: ValueKey<int>(tabSelected.value),
                        controller: _tabListController,
                        isScrollable: true,
                        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        labelColor: const Color(0xFF3A73C2),
                        unselectedLabelColor: const Color(0xFF7E8695),
                        indicatorColor: const Color(0xFF3A73C2),
                        indicatorWeight: 1,
                        tabs: const [
                          Tab(text: 'Đang làm việc'),
                          Tab(text: 'Nghỉ việc'),
                        ],
                      ),
                      Responsive.isMobile(context) ? const SizedBox.shrink() : const Spacer(),
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
                                    ],
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: const Color(0xFFF7F7FC),
                                      filled: true,
                                      hintText: 'Tìm kiếm',
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF7E8695),
                                      ),
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
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 16),
                                                child: Container(
                                                  padding: const EdgeInsets.all(3),
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
                        Column(
                          children: [
                            Responsive.isMobile(context)
                                ? const SizedBox.shrink()
                                : titleTabWidget(
                                    name: 'Họ và tên',
                                    code: 'MSGV',
                                    industry: 'Ngành dạy',
                                    email: 'Email',
                                    phone: 'Số điện thoại',
                                    status: 'Trạng thái',
                                    detail: 'Chi tiết',
                                  ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: workingTeachers.length,
                                itemBuilder: (context, index) {
                                  final teacher = workingTeachers[index];
                                  return Responsive.isMobile(context)
                                      ? buildTeacherCard(teacher, context)
                                      : tableInfoTeacherWidget(teacher, context);
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Responsive.isMobile(context)
                                ? const SizedBox.shrink()
                                : titleTabWidget(
                                    name: 'Họ và tên',
                                    code: 'MSGV',
                                    industry: 'Ngành dạy',
                                    email: 'Email',
                                    phone: 'Số điện thoại',
                                    status: 'Trạng thái',
                                    detail: 'Chi tiết',
                                  ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: retiredTeachers.length,
                                itemBuilder: (context, index) {
                                  final teacher = retiredTeachers[index];
                                  return Responsive.isMobile(context)
                                      ? buildTeacherCard(teacher, context)
                                      : tableInfoTeacherWidget(teacher, context);
                                },
                              ),
                            ),
                          ],
                        ),
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
}

class ItemOnTap extends StatelessWidget {
  const ItemOnTap({
    super.key,
    required this.authController,
  });

  final AuthenticationController authController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2
          ? Get.toNamed(Routes.ADDTEACHER)
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
          color: AppColors.primaryColor,
        ),
        child: Row(
          children: [
            SvgPicture.asset(IconAssets.teacherIcon),
            const SizedBox(width: 8),
            const Text(
              'Thêm giáo viên',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
