// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController teacherCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController teachingLevelController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController civilServantController = TextEditingController();
  final TextEditingController contractTypeController = TextEditingController();
  final TextEditingController primarySubjectController = TextEditingController();
  final TextEditingController secondarySubjectController = TextEditingController();
  final TextEditingController isWorkingController = TextEditingController();
  final TextEditingController academicDegreeController = TextEditingController();
  final TextEditingController standardDegreeController = TextEditingController();
  final TextEditingController politicalTheoryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  ValueNotifier<DateTime> selectedBirthDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> selectedJoinDateNotifier = ValueNotifier<DateTime>(DateTime.now());

  late bool isCivilServant = true;
  late bool isSeletedIsWorking = true;

  DateTime? selectedBirthDate;
  DateTime? selectedJoinDate;

  final isLoading = false.obs;

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

  Future<dynamic> addTeacher() async {
    isLoading(true);

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/add'));
    request.body = json.encode({
      "fullName": fullNameController.text,
      "teacherCode": teacherCodeController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phoneNumber": phoneNumberController.text,
      "gender": genderController.text,
      "cccd": cccdController.text,
      "birthDate": selectedBirthDateNotifier.value.toString(),
      "birthPlace": birthPlaceController.text,
      "ethnicity": ethnicityController.text,
      "nickname": nicknameController.text,
      "teachingLevel": teachingLevelController.text,
      "position": positionController.text,
      "experience": experienceController.text,
      "department": departmentController.text,
      "role": roleController.text,
      "joinDate": selectedJoinDateNotifier.value.toString(),
      "civilServant": isCivilServant.toString(),
      "contractType": contractTypeController.text,
      "primarySubject": primarySubjectController.text,
      "secondarySubject": secondarySubjectController.text,
      "isWorking": isSeletedIsWorking.toString(),
      "academicDegree": academicDegreeController.text,
      "standardDegree": standardDegreeController.text,
      "politicalTheory": politicalTheoryController.text,
      "address": addressController.text,
      "city": cityController.text,
      "district": districtController.text,
      "ward": wardController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final res = await json.decode(await response.stream.bytesToString());
    if (res['status'] == 'email_check') {
      Get.snackbar(
        "Thất bại",
        "Email đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'phone_check') {
      Get.snackbar(
        "Thất bại",
        "Số điện thoại đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'code_check') {
      Get.snackbar(
        "Thất bại",
        "Mã giáo viên đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'cccd_check') {
      Get.snackbar(
        "Thất bại",
        "CCCD đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'SUCCESS') {
      Get.snackbar(
        "Thành công",
        "Giáo viên đã được thêm thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.of(context);
      Navigator.of(context);
    } else {
      Get.snackbar(
        "Thất bại",
        "Lỗi kết nối!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading(false);
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
    birthDateController.dispose();
    birthPlaceController.dispose();
    ethnicityController.dispose();
    nicknameController.dispose();
    teachingLevelController.dispose();
    positionController.dispose();
    experienceController.dispose();
    departmentController.dispose();
    roleController.dispose();
    joinDateController.dispose();
    civilServantController.dispose();
    contractTypeController.dispose();
    primarySubjectController.dispose();
    secondarySubjectController.dispose();
    isWorkingController.dispose();
    academicDegreeController.dispose();
    standardDegreeController.dispose();
    politicalTheoryController.dispose();
    selectedBirthDateNotifier.dispose();
    selectedJoinDateNotifier.dispose();
    addressController.dispose();
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Thêm giáo viên mới',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.only(left: 24, right: 24, bottom: 36)
              : const EdgeInsets.only(left: 24 + 24, right: 24 + 24, bottom: 48),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
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
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/school-manager-793a1.appspot.com/o/image_email%2Fadmin.png?alt=media&token=7523b31b-0184-420c-86b6-b2b873086d60',
                            ),
                            radius: 100,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 24),
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
                                child: const Text(
                                  '1. Thông tin cá nhân',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: teacherCodeController,
                                      title: 'MSGV',
                                      hintText: 'Nhập mã giáo viên',
                                      initialData: '',
                                      validator: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: emailController,
                                      title: 'Email',
                                      hintText: 'Nhập email',
                                      initialData: '',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: passwordController,
                                      title: 'Mật khẩu',
                                      hintText: 'Nhập mật khẩu',
                                      initialData: '',
                                      validator: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: cccdController,
                                      title: 'CCCD',
                                      hintText: 'Nhập CCCD',
                                      initialData: '',
                                      validator: true,
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Giới tính',
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
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
                                            items: ["Nam", "Nữ", "Khác"].map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.blackColor,
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
                                          child: const Text(
                                            'Ngày tháng năm sinh',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
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
                                child: const Text(
                                  '2. Địa chỉ',
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 24),
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
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: cityController,
                                      title: 'Thành phố',
                                      hintText: 'Nhập thành phố',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: districtController,
                                      title: 'Quận/Huyện',
                                      hintText: 'Nhập quận huyện',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: wardController,
                                      title: 'Phường/Xã',
                                      hintText: 'Nhập phường xã',
                                      initialData: '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  '3. Trình độ chuyên môn',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Wrap(
                                spacing: 12,
                                runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                children: [
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                                    child: CustomTextWidgets(
                                      controller: academicDegreeController,
                                      title: 'Học vấn',
                                      hintText: 'Nhập học vấn',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: positionController,
                                      title: 'Chức vụ',
                                      hintText: 'Nhập chức vụ',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: experienceController,
                                      title: 'Kinh nghiệm giảng dạy',
                                      hintText: 'Nhập kinh nghiệm',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Ngày nhận công việc',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF373A43),
                                            ),
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
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: contractTypeController,
                                      title: 'Loại hợp đồng',
                                      hintText: 'Nhập tên hợp đồng',
                                      initialData: '',
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
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 40),
          child: Row(
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: Container(
                  height: 35,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    addTeacher();
                  }
                },
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryColor,
                  ),
                  child: isLoading.value
                      ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                      : const Text(
                          'Cập nhật thông tin',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                        ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
