// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final TeacherController teacherController = Get.put(TeacherController());
  final AuthController authController = Get.put(AuthController());
  final SideBarController sideBarController = Get.put(SideBarController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController teacherCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController teachingLevelController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController contractTypeController = TextEditingController();
  final TextEditingController primarySubjectController = TextEditingController();
  final TextEditingController secondarySubjectController = TextEditingController();
  final TextEditingController academicDegreeController = TextEditingController();
  final TextEditingController standardDegreeController = TextEditingController();
  final TextEditingController politicalTheoryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  ValueNotifier<DateTime> selectedBirthDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> selectedJoinDateNotifier = ValueNotifier<DateTime>(DateTime.now());

  DateTime? selectedBirthDate;
  DateTime? selectedJoinDate;

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null) {
      switch (type) {
        case 'birth':
          selectedBirthDateNotifier.value = picked;
          selectedBirthDate = picked;
          break;
        case 'join':
          selectedJoinDateNotifier.value = picked;
          selectedJoinDate = picked;
          break;
        default:
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    teacherCodeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    genderController.dispose();
    cccdController.dispose();
    birthPlaceController.dispose();
    ethnicityController.dispose();
    nicknameController.dispose();
    teachingLevelController.dispose();
    positionController.dispose();
    experienceController.dispose();
    departmentController.dispose();
    roleController.dispose();
    contractTypeController.dispose();
    primarySubjectController.dispose();
    secondarySubjectController.dispose();
    academicDegreeController.dispose();
    standardDegreeController.dispose();
    politicalTheoryController.dispose();
    selectedBirthDateNotifier.dispose();
    selectedJoinDateNotifier.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
              : const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Thêm giáo viên mới',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: appTheme.whiteColor,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Responsive.isMobile(context)
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // CircleAvatar(
                              //   backgroundImage: const NetworkImage(
                              //     'https://firebasestorage.googleapis.com/v0/b/school-manager-793a1.appspot.com/o/image_email%2Fadmin.png?alt=media&token=7523b31b-0184-420c-86b6-b2b873086d60',
                              //   ),
                              //   radius: 100,
                              //   backgroundColor: appTheme.whiteColor,
                              // ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: CachedNetworkImage(
                                  imageUrl: '',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     color: appTheme.appColor,
                              //   ),
                              //   child: Text(
                              //     'Chọn ảnh',
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       color: appTheme.whiteColor,
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                    Responsive.isMobile(context) ? const SizedBox.shrink() : const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      '1. Thông tin cá nhân',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                    children: [
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: fullNameController,
                                          title: 'Họ và Tên',
                                          hintText: 'Nhập họ và tên',
                                          initialData: '',
                                          keyboardType: TextInputType.name,
                                          validator: true,
                                          checkLength: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: teacherCodeController,
                                          title: 'MSGV',
                                          hintText: 'Nhập mã giáo viên',
                                          validator: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: emailController,
                                          title: 'Email',
                                          hintText: 'Nhập email',
                                          keyboardType: TextInputType.emailAddress,
                                          validator: true,
                                          checkEmail: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: passwordController,
                                          title: 'Mật khẩu',
                                          hintText: 'Nhập mật khẩu',
                                          validator: true,
                                          checkLength: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: cccdController,
                                          title: 'CCCD',
                                          hintText: 'Nhập CCCD',
                                          validator: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: phoneNumberController,
                                          title: 'Số điện thoại',
                                          hintText: 'Nhập số điện thoại',
                                          initialData: '',
                                          keyboardType: TextInputType.phone,
                                          validator: true,
                                          checkPhone: true,
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Giới tính',
                                                style:
                                                    StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFFD2D5DA)),
                                              ),
                                              child: DropdownButtonFormField<String>(
                                                decoration: const InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(bottom: 9),
                                                ),
                                                value: "Khác",
                                                elevation: 0,
                                                icon: const Icon(Icons.keyboard_arrow_down_outlined,
                                                    color: Color(0xFFB6BBC3)),
                                                padding: const EdgeInsets.only(left: 16, right: 24),
                                                items:
                                                    ["Nam", "Nữ", "Khác"].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: appTheme.blackColor,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  genderController.text = newValue!;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text('Ngày tháng năm sinh',
                                                  style: StyleThemeData.styleSize14Weight400(
                                                      color: appTheme.textDesColor)),
                                            ),
                                            const SizedBox(height: 8),
                                            InkWell(
                                              onTap: () async {
                                                await _selectDate(context, 'birth');
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: selectedBirthDateNotifier,
                                                builder: (context, date, child) {
                                                  return Container(
                                                    height: 40,
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.only(left: 16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: const Color(0xFFD2D5DA)),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      selectedBirthDate != null
                                                          ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                                                          : 'Chọn ngày sinh',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedBirthDate != null
                                                            ? AppColors.blackColor
                                                            : AppColors.textDesColor,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '2. Địa chỉ',
                                      style: TextStyle(
                                          color: appTheme.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                    children: [
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: addressController,
                                          title: 'Địa chỉ',
                                          hintText: 'Nhập số nhà và tên đường',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Thành phố',
                                                style:
                                                    StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Obx(
                                              () => Container(
                                                width: Responsive.isMobile(context)
                                                    ? MediaQuery.of(context).size.width
                                                    : 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFD2D5DA)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      value: authController.selectedProvince.value.isNotEmpty
                                                          ? authController.selectedProvince.value
                                                          : null,
                                                      hint: Text(
                                                        'Chọn thành phố',
                                                        style: StyleThemeData.styleSize14Weight400(height: 0),
                                                      ),
                                                      onChanged: (value) {
                                                        authController.selectProvince(value!);
                                                      },
                                                      items: authController.provinces
                                                          .where((province) => province.isNotEmpty)
                                                          .map((province) {
                                                        return DropdownMenuItem<String>(
                                                          value: province,
                                                          child: Text(
                                                            province,
                                                            style: StyleThemeData.styleSize14Weight400(height: 0),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      icon: SvgPicture.asset(IconAssets.caretDownIcon),
                                                      menuMaxHeight: 400,
                                                      dropdownColor: appTheme.background,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Quận/Huyện',
                                                style:
                                                    StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Obx(
                                              () => Container(
                                                width: Responsive.isMobile(context)
                                                    ? MediaQuery.of(context).size.width
                                                    : 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFD2D5DA)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      value: (authController.selectedDistrict.value.isNotEmpty &&
                                                              authController.selectedDistrict.value != ' ')
                                                          ? authController.selectedDistrict.value
                                                          : null,
                                                      hint: Text(
                                                        'Chọn quận/huyện',
                                                        style: StyleThemeData.styleSize14Weight400(height: 0),
                                                      ),
                                                      onChanged: (value) {
                                                        authController.selectDistrict(value!);
                                                      },
                                                      items: authController.districts.map((district) {
                                                        return DropdownMenuItem<String>(
                                                          value: district,
                                                          child: Text(
                                                            district,
                                                            style: StyleThemeData.styleSize14Weight400(height: 0),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      icon: SvgPicture.asset(IconAssets.caretDownIcon),
                                                      menuMaxHeight: 400,
                                                      dropdownColor: appTheme.background,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Phường/Xã',
                                                style:
                                                    StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Obx(
                                              () => Container(
                                                width: Responsive.isMobile(context)
                                                    ? MediaQuery.of(context).size.width
                                                    : 200,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFD2D5DA)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      value: authController.selectedWard.value.isNotEmpty
                                                          ? authController.selectedWard.value
                                                          : null,
                                                      hint: Text(
                                                        'Chọn phường/xã',
                                                        style: StyleThemeData.styleSize14Weight400(height: 0),
                                                      ),
                                                      onChanged: (value) {
                                                        authController.selectWard(value!);
                                                      },
                                                      items: authController.wards.map((ward) {
                                                        return DropdownMenuItem<String>(
                                                          value: ward,
                                                          child: Text(
                                                            ward,
                                                            style: StyleThemeData.styleSize14Weight400(height: 0),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      icon: SvgPicture.asset(IconAssets.caretDownIcon),
                                                      menuMaxHeight: 400,
                                                      dropdownColor: appTheme.background,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '3. Trình độ chuyên môn',
                                      style: TextStyle(
                                        color: appTheme.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                    children: [
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: academicDegreeController,
                                          title: 'Học vấn',
                                          hintText: 'Nhập học vấn',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: positionController,
                                          title: 'Chức vụ',
                                          hintText: 'Nhập chức vụ',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: experienceController,
                                          title: 'Kinh nghiệm giảng dạy',
                                          hintText: 'Nhập kinh nghiệm',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Ngày nhận công việc',
                                                style:
                                                    StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            InkWell(
                                              onTap: () async {
                                                await _selectDate(context, 'join');
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: selectedJoinDateNotifier,
                                                builder: (context, date, child) {
                                                  return Container(
                                                    width: double.maxFinite,
                                                    height: 40,
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.only(left: 16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: const Color(0xFFD2D5DA)),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      selectedJoinDate != null
                                                          ? '${selectedJoinDate!.day}/${selectedJoinDate!.month}/${selectedJoinDate!.year}'
                                                          : 'Chọn ngày nhận công việc',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedJoinDate != null
                                                            ? appTheme.blackColor
                                                            : appTheme.textDesColor,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: contractTypeController,
                                          title: 'Loại hợp đồng',
                                          hintText: 'Nhập tên hợp đồng',
                                          borderRadius: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 40),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    showNoSystemWidget(
                      context,
                      title: 'Xác nhận hủy?',
                      des: 'Bạn có chắc chắn muốn hủy và không thể lưu thông tin chỉnh sửa?',
                      cancel: 'Đóng',
                      confirm: 'Đồng ý',
                      ontap: () {
                        Navigator.pop(context);
                        sideBarController.index.value = 1;
                        authController.loadData();
                      },
                    );
                  },
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appTheme.appColor),
                    ),
                    child: Text(
                      'Hủy',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.appColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      teacherController.addTeacher(
                        fullName: fullNameController.text,
                        teacherCode: teacherCodeController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        phoneNumber: phoneNumberController.text,
                        gender: genderController.text,
                        cccd: cccdController.text,
                        birthDate: selectedBirthDate != null ? selectedBirthDate.toString() : '',
                        birthPlace: birthPlaceController.text,
                        ethnicity: ethnicityController.text,
                        nickname: nicknameController.text,
                        teachingLevel: teachingLevelController.text,
                        position: positionController.text,
                        experience: experienceController.text,
                        department: departmentController.text,
                        role: roleController.text,
                        joinDate: selectedJoinDate != null ? selectedJoinDate.toString() : '',
                        contractType: contractTypeController.text,
                        primarySubject: primarySubjectController.text,
                        secondarySubject: secondarySubjectController.text,
                        academicDegree: academicDegreeController.text,
                        standardDegree: standardDegreeController.text,
                        politicalTheory: politicalTheoryController.text,
                        address: addressController.text,
                        city: authController.selectedProvince.toString(),
                        district: authController.selectedDistrict.toString(),
                        ward: authController.selectedWard.toString(),
                      );
                    }
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: teacherController.isLoading.value
                        ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                        : Text(
                            'Cập nhật thông tin',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.whiteColor),
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
