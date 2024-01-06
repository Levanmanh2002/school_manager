// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/controller/chart_controller.dart';
import 'package:school_web/web/pages/home/controller/controller.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/build_student_card_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_student_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';
import 'package:school_web/web/pages/screen/student/controller/student_controller.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/icons.dart';
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

  final AuthenticationController authController = Get.put(AuthenticationController());
  final controller = Get.put(StudentCtl());
  final ctlNew = Get.put(Controller());
  final ChartController ctlAll = Get.put(ChartController());
  ValueNotifier<int> tabSelected = ValueNotifier<int>(0);

  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  List<StudentData> allStudents = [];
  int currentPage = 1;
  List<StudentData>? newStudentData;

  @override
  void initState() {
    super.initState();
    ctlAll.fetchNumberActiveData();
    ctlAll.fetchNumberInactiveData();
    ctlAll.fetchNumberSuspendedData();
    ctlAll.fetchNumberExpelledData();
    _loadStudent();
    _tabListController = TabController(length: 6, vsync: this);
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });

    if (allStudents.isEmpty) {
      _loadData();
    }

    _tabListController.addListener(() {
      tabSelected.value = _tabListController.index;
    });
  }

  Future<void> _loadStudent() async {
    newStudentData = await ctlNew.getTotalNewListStudent();
  }

  Future<void> _loadData() async {
    List<StudentData> nextBatch = await getNextBatchOfStudents();

    List<StudentData> uniqueNewStudents = nextBatch
        .where((newStudent) => !allStudents.any((existingStudent) => existingStudent.sId == newStudent.sId))
        .toList();

    setState(() {
      allStudents.addAll(uniqueNewStudents);
    });
  }

  Future<List<StudentData>> getNextBatchOfStudents() async {
    currentPage++;
    List<StudentData> nextBatch = await ctlNew.getNewListStudent();

    List<StudentData> uniqueNewStudents = nextBatch
        .where((newStudent) => !allStudents.any((existingStudent) => existingStudent.sId == newStudent.sId))
        .toList();

    allStudents.addAll(uniqueNewStudents);

    return uniqueNewStudents;
  }

  @override
  void dispose() {
    super.dispose();
    _tabListController.dispose();
    searchController.dispose();
    isClearVisible.dispose();
    isLoadingNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudent = ctlAll.numberOfActiveStudents.value.toDouble() +
        ctlAll.numberOfInactiveStudents.value.toDouble() +
        ctlAll.numberOfSuspendedStudents.value.toDouble() +
        ctlAll.numberOfExpelledStudents.value.toDouble();

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
                            color: selectedTab == 0
                                ? AppColors.primary50Color
                                : selectedTab == 1
                                    ? AppColors.green100Color
                                    : selectedTab == 2
                                        ? AppColors.green100Color
                                        : selectedTab == 3
                                            ? AppColors.yellow100Color
                                            : selectedTab == 4
                                                ? AppColors.trokeColor
                                                : selectedTab == 5
                                                    ? AppColors.red100Color
                                                    : AppColors.primary50Color,
                          ),
                          child: Text(
                            selectedTab == 0
                                ? 'Tất cả: $totalStudent'
                                : selectedTab == 1
                                    ? 'Đang học: '
                                    : selectedTab == 2
                                        ? 'Học sinh mới: ${newStudentData?.length.toDouble()}'
                                        : selectedTab == 3
                                            ? 'Nghỉ học: '
                                            : selectedTab == 4
                                                ? 'Đình chỉ: '
                                                : selectedTab == 5
                                                    ? 'Bị buổi học: '
                                                    : 'Tất cả',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedTab == 0
                                  ? AppColors.primaryColor
                                  : selectedTab == 1
                                      ? AppColors.green500Color
                                      : selectedTab == 2
                                          ? AppColors.green500Color
                                          : selectedTab == 3
                                              ? AppColors.yellow500Color
                                              : selectedTab == 4
                                                  ? AppColors.textDesColor
                                                  : selectedTab == 5
                                                      ? AppColors.redColor
                                                      : AppColors.primaryColor,
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
                              labelColor: AppColors.primaryColor,
                              unselectedLabelColor: AppColors.textDesColor,
                              indicatorColor: AppColors.primaryColor,
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
                                    ],
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: const Color(0xFFF7F7FC),
                                      filled: true,
                                      hintText: 'Tìm kiếm',
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textDesColor,
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
                                                    color: AppColors.textDesColor,
                                                  ),
                                                  child: const Icon(
                                                    Icons.clear_rounded,
                                                    color: AppColors.whiteColor,
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
    return Column(
      children: [
        const SizedBox(height: 16),
        Responsive.isMobile(context)
            ? const SizedBox.shrink()
            : titleTabWidget(
                name: 'Họ và tên',
                code: 'MSSV',
                industry: 'Ngành học',
                email: 'Email',
                phone: 'Số điện thoại',
                status: 'Trạng thái',
                detail: 'Chi tiết',
              ),
        Expanded(
          child: ListView.builder(
            itemCount: allStudents.length,
            itemBuilder: (context, index) {
              final student = allStudents[index];
              return Responsive.isMobile(context)
                  ? buildStudentCard(student, context)
                  : tableInfoStudentWidget(student, context);
            },
          ),
        ),
        InkWell(
          onTap: () async {
            isLoadingNotifier.value = true;

            List<StudentData> updatedList = await ctlNew.getNextBatchOfStudents();

            isLoadingNotifier.value = false;

            if (updatedList.isNotEmpty) {
              setState(() {
                List<StudentData> updatedLists = updatedList
                    .where((newStudent) => !allStudents.any((existingStudent) => existingStudent.sId == newStudent.sId))
                    .toList();

                allStudents.addAll(updatedLists);
              });
            } else {
              print('Danh sách Student mobile rỗng hoặc có lỗi khi cập nhật');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(),
                      ),
                    if (isLoading) const SizedBox(width: 8),
                    const Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isLoading)
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.primaryColor,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget tabBarView2() {
    return FutureBuilder<List<StudentData>>(
      future: controller.getActiveStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có học sinh nào đang học.'));
        } else {
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách học sinh đang học: ${snapshot.data?.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final student = snapshot.data![index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget tabBarView3() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Responsive.isMobile(context)
            ? const SizedBox.shrink()
            : titleTabWidget(
                name: 'Họ và tên',
                code: 'MSSV',
                industry: 'Ngành học',
                email: 'Email',
                phone: 'Số điện thoại',
                status: 'Trạng thái',
                detail: 'Chi tiết',
              ),
        Expanded(
          child: ListView.builder(
            itemCount: allStudents.length,
            itemBuilder: (context, index) {
              final student = allStudents[index];
              return Responsive.isMobile(context)
                  ? buildStudentCard(student, context)
                  : tableInfoStudentWidget(student, context);
            },
          ),
        ),
        InkWell(
          onTap: () async {
            isLoadingNotifier.value = true;

            List<StudentData> updatedList = await ctlNew.getNextBatchOfStudents();

            isLoadingNotifier.value = false;

            if (updatedList.isNotEmpty) {
              setState(() {
                List<StudentData> updatedLists = updatedList
                    .where((newStudent) => !allStudents.any((existingStudent) => existingStudent.sId == newStudent.sId))
                    .toList();

                allStudents.addAll(updatedLists);
              });
            } else {
              print('Danh sách Student mobile rỗng hoặc có lỗi khi cập nhật');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(),
                      ),
                    if (isLoading) const SizedBox(width: 8),
                    const Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isLoading)
                      const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.primaryColor,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget tabBarView4() {
    return FutureBuilder<List<StudentData>>(
      future: controller.getInactiveStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có học sinh nào nghỉ học.'));
        } else {
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách học sinh đã nghỉ học: ${snapshot.data?.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final student = snapshot.data![index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget tabBarView5() {
    return FutureBuilder<List<StudentData>>(
      future: controller.getSuspendedStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có học sinh nào bị đình chỉ.'));
        } else {
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách học sinh đang bị đình chỉ: ${snapshot.data?.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final student = snapshot.data![index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget tabBarView6() {
    return FutureBuilder<List<StudentData>>(
      future: controller.getExpelledStudent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có học sinh nào bị đuổi học.'));
        } else {
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách học sinh bị đuổi học: ${snapshot.data?.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final student = snapshot.data![index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          );
        }
      },
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
          ? Get.toNamed(Routes.ADDSTUDENT)
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
            SvgPicture.asset(IconAssets.studentIcon),
            const SizedBox(width: 8),
            const Text(
              'Thêm học sinh',
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
