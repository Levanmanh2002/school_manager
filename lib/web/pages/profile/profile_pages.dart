// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> with SingleTickerProviderStateMixin {
  TeacherData? teacherData;
  final authController = Get.put(AuthenticationController());

  @override
  void initState() {
    authController.getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final birthDateJson = authController.teacherData.value?.birthDate;
    final joinDateJson = authController.teacherData.value?.joinDate;

    final dateFormatter = DateFormat('dd/MM/yyyy');
    DateTime? birthDate;
    if (birthDateJson != null && birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    DateTime? joinDate;
    if (joinDateJson != null && joinDateJson.isNotEmpty) {
      joinDate = DateTime.tryParse(joinDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';
    final formattedJoinDate = joinDate != null ? dateFormatter.format(joinDate) : 'N/A';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Thông tin cá nhân',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          bottom: TabBar(
            labelColor: const Color(0xFFFF0162E2),
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF7E8695)),
            indicatorSize: TabBarIndicatorSize.tab,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            dividerColor: Colors.red,
            splashBorderRadius: const BorderRadius.all(Radius.circular(8)),
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            unselectedLabelColor: const Color(0xFF7E8695),
            tabs: const [
              Tab(text: 'Thông tin chung'),
              Tab(text: 'Thông tin công việc'),
              Tab(text: 'Trình độ chuyên môn'),
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Obx(
            () => TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imageUrl: authController.teacherData.value!.avatarUrl ??
                                    'https://i.stack.imgur.com/l60Hf.png',
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                          ),
                          radius: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: Responsive.isMobile(context) ? 12 : 32,
                          children: [
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Mã giáo viên',
                                initialData: authController.teacherData.value?.teacherCode,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Họ và Tên',
                                initialData: authController.teacherData.value?.fullName,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'CMND/CCCD',
                                initialData: authController.teacherData.value?.cccd,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Gmail',
                                initialData: authController.teacherData.value?.email,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Số điện thoại',
                                initialData: authController.teacherData.value?.phoneNumber,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Giới tính',
                                initialData: authController.teacherData.value?.gender,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Ngày sinh',
                                keyboardType: TextInputType.datetime,
                                initialData: formattedBirthDate,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Nơi sinh',
                                initialData: authController.teacherData.value?.birthPlace,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Dân tộc',
                                initialData: authController.teacherData.value?.ethnicity,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Biệt danh',
                                initialData: authController.teacherData.value?.nickname,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imageUrl: authController.teacherData.value!.avatarUrl ??
                                    'https://i.stack.imgur.com/l60Hf.png',
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                          ),
                          radius: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: Responsive.isMobile(context) ? 12 : 32,
                          children: [
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Trình độ giảng dạy',
                                initialData: authController.teacherData.value?.teachingLevel,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Chức vụ',
                                initialData: authController.teacherData.value?.position,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Kinh nghiệm',
                                initialData: authController.teacherData.value?.experience,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Bộ môn',
                                initialData: authController.teacherData.value?.department,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Vai trò',
                                initialData: authController.teacherData.value?.role,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Ngày tham gia',
                                initialData: formattedJoinDate,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Là cán bộ công chức',
                                initialData: authController.teacherData.value?.civilServant == true ? 'Có' : 'Không',
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Loại hợp đồng',
                                initialData: authController.teacherData.value?.contractType,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Môn dạy chính',
                                initialData: authController.teacherData.value?.primarySubject,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Môn dạy phụ',
                                initialData: authController.teacherData.value?.secondarySubject,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : 200,
                              child: CustomTextWidgets(
                                title: 'Đang làm việc',
                                initialData: authController.teacherData.value?.isWorking == true
                                    ? 'Đang làm việc'
                                    : 'Đã nghỉ làm',
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imageUrl: authController.teacherData.value!.avatarUrl ??
                                    'https://i.stack.imgur.com/l60Hf.png',
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                          ),
                          radius: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: Responsive.isMobile(context) ? 12 : 32,
                          children: [
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                              child: CustomTextWidgets(
                                title: 'Trình độ học vấn',
                                initialData: authController.teacherData.value?.academicDegree,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                              child: CustomTextWidgets(
                                title: 'Trình độ chuẩn',
                                initialData: authController.teacherData.value?.standardDegree,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                              child: CustomTextWidgets(
                                title: 'Chính trị',
                                initialData: authController.teacherData.value?.politicalTheory,
                                enabled: false,
                                colorHint: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.EDITPROFILR);
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.pink,
                    ),
                    child: const Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
