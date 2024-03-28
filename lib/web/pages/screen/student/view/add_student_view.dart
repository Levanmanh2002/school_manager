// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/majors/majors_controller.dart';
import 'package:school_web/web/controllers/student/student_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/utils/flash/toast.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final MajorsController majorsController = Get.put(MajorsController());
  final StudentController studentController = Get.put(StudentController());
  final AuthController authController = Get.put(AuthController());
  final SideBarController sideBarController = Get.put(SideBarController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController customYearController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController contactAddressController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController beneficiaryController = TextEditingController();
  final TextEditingController fatherFullNameController = TextEditingController();
  final TextEditingController motherFullNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  ValueNotifier<DateTime> selectedBirthDateNotifier = ValueNotifier<DateTime>(DateTime.now());

  DateTime? selectedBirthDate;

  String? selectedClassValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null) {
      selectedBirthDateNotifier.value = picked;
      selectedBirthDate = picked;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    gmailController.dispose();
    phoneController.dispose();
    cccdController.dispose();
    customYearController.dispose();
    genderController.dispose();
    contactPhoneController.dispose();
    contactAddressController.dispose();
    ethnicityController.dispose();
    beneficiaryController.dispose();
    fatherFullNameController.dispose();
    motherFullNameController.dispose();
    notesController.dispose();
    addressController.dispose();
    selectedBirthDateNotifier.dispose();
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
                  'Thêm học sinh mới',
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
                              //     color: AppColors.primaryColor,
                              //   ),
                              //   child: const Text(
                              //     'Chọn ảnh',
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w700,
                              //       color: AppColors.whiteColor,
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
                                    child: Text(
                                      '1. Thông tin học sinh',
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
                                          controller: fullNameController,
                                          title: 'Họ và Tên',
                                          hintText: 'Nhập họ và tên',
                                          keyboardType: TextInputType.name,
                                          validator: true,
                                          borderRadius: 8,
                                          checkLength: true,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: gmailController,
                                          title: 'Email',
                                          hintText: 'Nhập email',
                                          keyboardType: TextInputType.emailAddress,
                                          validator: true,
                                          borderRadius: 8,
                                          checkEmail: true,
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
                                          controller: phoneController,
                                          title: 'Số điện thoại',
                                          hintText: 'Nhập số điện thoại',
                                          keyboardType: TextInputType.phone,
                                          validator: true,
                                          borderRadius: 8,
                                          checkPhone: true,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Chuyên ngành',
                                                    style: StyleThemeData.styleSize14Weight500(
                                                      color: appTheme.textDesColor,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '*',
                                                  style: StyleThemeData.styleSize14Weight500(
                                                    color: appTheme.textDesColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFFD2D5DA)),
                                              ),
                                              child: Center(
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Danh sách',
                                                      style: StyleThemeData.styleSize14Weight400(height: 0),
                                                    ),
                                                    items: majorsController.majorsList
                                                        .map((item) => DropdownMenuItem<String>(
                                                              value: item.sId,
                                                              child: Text(
                                                                item.name.toString(),
                                                                style: const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedClassValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedClassValue = value;
                                                      });
                                                    },
                                                    buttonStyleData: const ButtonStyleData(
                                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                                      height: 50,
                                                      width: double.maxFinite,
                                                    ),
                                                    dropdownStyleData: const DropdownStyleData(
                                                      maxHeight: 300,
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(
                                                      height: 60,
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
                                                'Giới tính',
                                                style: StyleThemeData.styleSize14Weight500(
                                                  color: appTheme.textDesColor,
                                                ),
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
                                                alignment: Alignment.center,
                                                decoration: const InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(bottom: 10),
                                                ),
                                                value: "Khác",
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down_outlined,
                                                  color: appTheme.blackColor,
                                                ),
                                                padding: const EdgeInsets.only(left: 16, right: 24),
                                                items:
                                                    ["Nam", "Nữ", "Khác"].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: StyleThemeData.styleSize14Weight400(height: 0),
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
                                              child: Text(
                                                'Ngày sinh',
                                                style:
                                                    StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            InkWell(
                                              onTap: () async {
                                                await _selectDate(context);
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable: selectedBirthDateNotifier,
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
                                                      selectedBirthDate != null
                                                          ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                                                          : 'Chọn ngày sinh',
                                                      style: StyleThemeData.styleSize14Weight500(height: 0),
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
                                  const SizedBox(height: 32),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '2. Địa chỉ',
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
                                  const SizedBox(height: 32),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '3. Thông tin liên hệ',
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
                                          controller: contactPhoneController,
                                          title: 'Số điện thoại liên lạc',
                                          hintText: 'Nhập số điện thoại liên lạc',
                                          borderRadius: 8,
                                          keyboardType: TextInputType.phone,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: contactAddressController,
                                          title: 'Địa chỉ liên lạc',
                                          hintText: 'Nhập địa chỉ liên lạc',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: ethnicityController,
                                          title: 'Dân tộc học sinh',
                                          hintText: 'Nhập dân tộc học sinh',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: fatherFullNameController,
                                          title: 'Họ tên cha học sinh',
                                          hintText: 'Nhập họ tên cha học sinh',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: motherFullNameController,
                                          title: 'Họ tên mẹ học sinh',
                                          hintText: 'Nhập họ tên mẹ học sinh',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: beneficiaryController,
                                          title: 'Đối tượng học sinh',
                                          hintText: 'Nhập đối tượng học sinh',
                                          borderRadius: 8,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Responsive.isMobile(context) ? null : 200,
                                        child: CustomTextWidgets(
                                          controller: notesController,
                                          title: 'Ghi chú',
                                          hintText: 'Nhập ghi chú',
                                          borderRadius: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                        sideBarController.index.value = 2;
                        authController.loadData();
                      },
                    );
                  },
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
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
                      if (selectedClassValue != null) {
                        studentController.addStudent(
                          fullName: fullNameController.text,
                          gmail: gmailController.text,
                          phone: phoneController.text,
                          cccd: cccdController.text,
                          birthDate: selectedBirthDate != null ? selectedBirthDate.toString() : '',
                          customYear: customYearController.text,
                          gender: genderController.text,
                          major: selectedClassValue.toString(),
                          contactPhone: contactPhoneController.text,
                          contactAddress: contactAddressController.text,
                          ethnicity: ethnicityController.text,
                          beneficiary: beneficiaryController.text,
                          fatherFullName: fatherFullNameController.text,
                          motherFullName: motherFullNameController.text,
                          notes: notesController.text,
                          address: addressController.text,
                          city: authController.selectedProvince.toString(),
                          district: authController.selectedDistrict.toString(),
                          ward: authController.selectedWard.toString(),
                        );
                      } else {
                        showSimpleIconsToast('Vui lòng chọn chuyên ngành');
                      }
                    }
                  },
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: studentController.isLoading.value
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
