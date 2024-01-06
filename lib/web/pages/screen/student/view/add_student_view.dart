// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController customYearController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  // final TextEditingController classController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController contactAddressController = TextEditingController();
  final TextEditingController educationLevelController = TextEditingController();
  // final TextEditingController graduationCertificateController = TextEditingController();
  final TextEditingController academicPerformanceController = TextEditingController();
  final TextEditingController conductController = TextEditingController();
  final TextEditingController classRanking10Controller = TextEditingController();
  final TextEditingController classRanking11Controller = TextEditingController();
  final TextEditingController classRanking12Controller = TextEditingController();
  final TextEditingController graduationYearController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController beneficiaryController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController idCardIssuedDateController = TextEditingController();
  final TextEditingController idCardIssuedPlaceController = TextEditingController();
  final TextEditingController fatherFullNameController = TextEditingController();
  final TextEditingController motherFullNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  ValueNotifier<DateTime> selectedBirthDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> selectedDateCccdNotifier = ValueNotifier<DateTime>(DateTime.now());

  late bool isCivilServant = true;
  late bool isSeletedIsWorking = false;

  DateTime? selectedBirthDate;
  DateTime? selectedDateCccd;

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
        case 'data_cccd':
          selectedDateCccdNotifier.value = picked;
          selectedDateCccd = picked;
          break;
        default:
          break;
      }
    }
  }

  Future<dynamic> addStudent() async {
    isLoading(true);

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/signup'));
    request.body = json.encode({
      "fullName": fullNameController.text,
      "gmail": gmailController.text,
      "phone": phoneController.text,
      "birthDate": birthDateController.text,
      "cccd": cccdController.text,
      "birthPlace": birthPlaceController.text,
      "customYear": customYearController.text,
      "gender": genderController.text,
      "hometown": hometownController.text,
      "permanentAddress": permanentAddressController.text,
      "occupation": occupationController.text,
      "contactPhone": contactPhoneController.text,
      "contactAddress": contactAddressController.text,
      "educationLevel": educationLevelController.text,
      "academicPerformance": academicPerformanceController.text,
      "conduct": conductController.text,
      "classRanking10": classRanking10Controller.text,
      "classRanking11": classRanking11Controller.text,
      "classRanking12": classRanking12Controller.text,
      "graduationYear": graduationYearController.text,
      "ethnicity": ethnicityController.text,
      "religion": religionController.text,
      "beneficiary": beneficiaryController.text,
      "area": areaController.text,
      "idCardIssuedDate": idCardIssuedDateController.text,
      "idCardIssuedPlace": idCardIssuedPlaceController.text,
      "fatherFullName": fatherFullNameController.text,
      "motherFullName": motherFullNameController.text,
      "notes": notesController.text,
      "address": addressController.text,
      "city": cityController.text,
      "district": districtController.text,
      "ward": wardController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final res = await json.decode(await response.stream.bytesToString());

    if (res['status'] == 'check_email') {
      Get.snackbar(
        "Thất bại",
        "Email đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'check_phone') {
      Get.snackbar(
        "Thất bại",
        "Số điện thoại đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'check_cccd') {
      Get.snackbar(
        "Thất bại",
        "CCCD đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (res['status'] == 'SUCCESS') {
      Get.snackbar(
        "Thành công",
        "Học sinh đã được thêm thành công, kiểm tra email của bạn để biết thông tin tài khoản!",
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
    gmailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    cccdController.dispose();
    birthPlaceController.dispose();
    customYearController.dispose();
    genderController.dispose();
    hometownController.dispose();
    permanentAddressController.dispose();
    occupationController.dispose();
    // classController.dispose();
    contactPhoneController.dispose();
    contactAddressController.dispose();
    educationLevelController.dispose();
    // graduationCertificateController.dispose();
    academicPerformanceController.dispose();
    conductController.dispose();
    classRanking10Controller.dispose();
    classRanking11Controller.dispose();
    classRanking12Controller.dispose();
    graduationYearController.dispose();
    ethnicityController.dispose();
    religionController.dispose();
    beneficiaryController.dispose();
    areaController.dispose();
    idCardIssuedDateController.dispose();
    idCardIssuedPlaceController.dispose();
    fatherFullNameController.dispose();
    motherFullNameController.dispose();
    notesController.dispose();
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
            'Thêm học sinh mới',
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
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  '1. Thông tin học sinh',
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
                                      hintText: 'Nhập họ và tên',
                                      keyboardType: TextInputType.name,
                                      validator: true,
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: cccdController,
                                      title: 'CCCD',
                                      hintText: 'Nhập CCCD',
                                      validator: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: phoneController,
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF373A43),
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
                                            'Ngày sinh',
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
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
                                ],
                              ),
                              const SizedBox(height: 32),
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
                              const SizedBox(height: 32),
                              Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  '3. Quá trình học',
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
                                      controller: educationLevelController,
                                      title: 'Trình độ học vấn',
                                      hintText: 'Nhập trình độ học vấn',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: academicPerformanceController,
                                      title: 'Học lực',
                                      hintText: 'Nhập học lực',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: conductController,
                                      title: 'Hạnh kiểm',
                                      hintText: 'Nhập hạnh kiểm',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: classRanking10Controller,
                                      title: 'Học lực lớp 10',
                                      hintText: 'Nhập học lực',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: classRanking11Controller,
                                      title: 'Học lực lớp 11',
                                      hintText: 'Nhập học lực',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: classRanking12Controller,
                                      title: 'Học lực lớp 12',
                                      hintText: 'Nhập học lực',
                                      initialData: '',
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: graduationYearController,
                                      title: 'Năm học tốt nghiệp',
                                      hintText: 'Nhập năm tốt nghiệp',
                                      initialData: '',
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
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
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
                    addStudent();
                  }
                },
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
