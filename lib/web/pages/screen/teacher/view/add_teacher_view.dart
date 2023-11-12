// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';

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
      fullNameController.clear();
      teacherCodeController.clear();
      emailController.clear();
      passwordController.clear();
      phoneNumberController.clear();
      genderController.clear();
      cccdController.clear();
      birthDateController.clear();
      birthPlaceController.clear();
      ethnicityController.clear();
      nicknameController.clear();
      teachingLevelController.clear();
      positionController.clear();
      experienceController.clear();
      departmentController.clear();
      roleController.clear();
      joinDateController.clear();
      civilServantController.clear();
      contractTypeController.clear();
      primarySubjectController.clear();
      secondarySubjectController.clear();
      isWorkingController.clear();
      academicDegreeController.clear();
      standardDegreeController.clear();
      politicalTheoryController.clear();
      selectedBirthDateNotifier.dispose();
      selectedJoinDateNotifier.dispose();
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      '1. Thông tin chung',
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
                          controller: fullNameController,
                          title: 'Họ và Tên',
                          initialData: '',
                          keyboardType: TextInputType.name,
                          validator: true,
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: teacherCodeController,
                          title: 'Mã giáo viên',
                          initialData: '',
                          validator: true,
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: passwordController,
                          title: 'Mật khẩu',
                          initialData: '',
                          validator: true,
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: cccdController,
                          title: 'CMND/CCCD',
                          initialData: '',
                          validator: true,
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: emailController,
                          title: 'Email',
                          initialData: '',
                          keyboardType: TextInputType.emailAddress,
                          validator: true,
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: phoneNumberController,
                          title: 'Số điện thoại',
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
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
                                icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Color(0xFFB6BBC3)),
                                padding: const EdgeInsets.only(left: 16, right: 24),
                                items: ["Nam", "Nữ", "Khác"].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFB6BBC3),
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
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
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
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF373A43),
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
                          controller: birthPlaceController,
                          title: 'Nơi sinh',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: ethnicityController,
                          title: 'Dân tộc',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: nicknameController,
                          title: 'Biệt danh',
                          initialData: '',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      '2. Thông tin công việc',
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
                          controller: teachingLevelController,
                          title: 'Trình độ giảng dạy',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: positionController,
                          title: 'Chức vụ',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: experienceController,
                          title: 'Kinh nghiệm',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: departmentController,
                          title: 'Bộ môn',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: roleController,
                          title: 'Vai trò',
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
                                'Ngày tham gia',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
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
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF373A43),
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
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Là cán bộ công chức',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFD2D5DA)),
                              ),
                              child: DropdownButtonFormField<bool>(
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 9),
                                ),
                                value: false,
                                elevation: 0,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Color(0xFFB6BBC3)),
                                padding: const EdgeInsets.only(left: 16, right: 24),
                                items: const [
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text(
                                      'Có',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFB6BBC3),
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text(
                                      'Không',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFB6BBC3),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (newValue) {
                                  isCivilServant = newValue!;
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
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: primarySubjectController,
                          title: 'Môn dạy chính',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : 200,
                        child: CustomTextWidgets(
                          controller: secondarySubjectController,
                          title: 'Môn dạy phụ',
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
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
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
                          title: 'Trình độ học vấn',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                        child: CustomTextWidgets(
                          controller: standardDegreeController,
                          title: 'Trình độ chuẩn',
                          initialData: '',
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                        child: CustomTextWidgets(
                          controller: politicalTheoryController,
                          title: 'Chính trị',
                          initialData: '',
                        ),
                      ),
                    ],
                  ),

                  // Container(
                  //   alignment: Alignment.topLeft,
                  //   child: const Text(
                  //     'Tình trạng đang làm việc',
                  //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Container(
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: const Color(0xFF9AA0AC)),
                  //   ),
                  //   child: DropdownButtonFormField<bool>(
                  //     decoration: const InputDecoration(
                  //       enabledBorder: InputBorder.none,
                  //       focusedBorder: InputBorder.none,
                  //       contentPadding: EdgeInsets.only(bottom: 9),
                  //     ),
                  //     value: true,
                  //     elevation: 0,
                  //     icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  //     padding: const EdgeInsets.only(left: 16, right: 24),
                  //     items: const [
                  //       DropdownMenuItem(
                  //         value: true,
                  //         child: Text('Đang làm việc'),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: false,
                  //         child: Text('Đã nghỉ làm'),
                  //       ),
                  //     ],
                  //     onChanged: (newValue) {
                  //       isSeletedIsWorking = newValue!;
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(height: 12),
                ],
              ),
            ),
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
                  fullNameController.clear();
                  teacherCodeController.clear();
                  emailController.clear();
                  passwordController.clear();
                  phoneNumberController.clear();
                  genderController.clear();
                  cccdController.clear();
                  birthDateController.clear();
                  birthPlaceController.clear();
                  ethnicityController.clear();
                  nicknameController.clear();
                  teachingLevelController.clear();
                  positionController.clear();
                  experienceController.clear();
                  departmentController.clear();
                  roleController.clear();
                  joinDateController.clear();
                  civilServantController.clear();
                  contractTypeController.clear();
                  primarySubjectController.clear();
                  secondarySubjectController.clear();
                  isWorkingController.clear();
                  academicDegreeController.clear();
                  standardDegreeController.clear();
                  politicalTheoryController.clear();
                  selectedBirthDateNotifier.dispose();
                  selectedJoinDateNotifier.dispose();
                },
                child: Container(
                  height: 35,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.pink),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.pink),
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
                child: Obx(
                  () => Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.pink,
                    ),
                    child: isLoading.value
                        ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                        : const Text(
                            'Thêm',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
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
