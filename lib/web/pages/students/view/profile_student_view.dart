// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/component_library/image_picker_dialog.dart';
import 'package:school_web/web/controllers/student/student_controller.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class ProfileStudentView extends StatefulWidget {
  const ProfileStudentView({super.key});

  @override
  State<ProfileStudentView> createState() => _ProfileStudentViewState();
}

class _ProfileStudentViewState extends State<ProfileStudentView> {
  final authController = Get.put(AuthenticationController());
  final studentController = Get.put(StudentController());
  final isLoading = false.obs;
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _customYearController = TextEditingController();
  final TextEditingController _mssvController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _hometownController = TextEditingController();
  final TextEditingController _permanentAddressController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _contactAddressController = TextEditingController();
  final TextEditingController _educationLevelController = TextEditingController();
  final TextEditingController _academicPerformanceController = TextEditingController();
  final TextEditingController _conductController = TextEditingController();
  final TextEditingController _classRanking10Controller = TextEditingController();
  final TextEditingController _classRanking11Controller = TextEditingController();
  final TextEditingController _classRanking12Controller = TextEditingController();
  final TextEditingController _graduationYearController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _beneficiaryController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _idCardIssuedDateController = TextEditingController();
  final TextEditingController _idCardIssuedPlaceController = TextEditingController();
  final TextEditingController _fatherFullNameController = TextEditingController();
  final TextEditingController _motherFullNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _isStudyingController = TextEditingController();

  ValueNotifier<DateTime> selectedBirthDateNotifier = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<DateTime> selectedJoinDateNotifier = ValueNotifier<DateTime>(DateTime.now());

  DateTime? selectedBirthDate;
  DateTime? selectedJoinDate;

  String? selectedImagePath;

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
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
  void initState() {
    super.initState();
    getProfileStudentData();
  }

  Future<dynamic> getProfileStudentData() async {
    final token = await const FlutterSecureStorage().read(key: 'token');

    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse('https://backend-shool-project.onrender.com/user/profile_student'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      final jsonData = await response.stream.bytesToString();
      final student = Students.fromJson(json.decode(jsonData));
    } else {
      print(response.reasonPhrase);
      authController.logout();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _gmailController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    _cccdController.dispose();
    _birthPlaceController.dispose();
    _customYearController.dispose();
    _mssvController.dispose();
    _genderController.dispose();
    _hometownController.dispose();
    _permanentAddressController.dispose();
    _occupationController.dispose();
    _studentsController.dispose();
    _contactPhoneController.dispose();
    _contactAddressController.dispose();
    _educationLevelController.dispose();
    _academicPerformanceController.dispose();
    _conductController.dispose();
    _classRanking10Controller.dispose();
    _classRanking11Controller.dispose();
    _classRanking12Controller.dispose();
    _graduationYearController.dispose();
    _ethnicityController.dispose();
    _religionController.dispose();
    _beneficiaryController.dispose();
    _areaController.dispose();
    _idCardIssuedDateController.dispose();
    _idCardIssuedPlaceController.dispose();
    _fatherFullNameController.dispose();
    _motherFullNameController.dispose();
    _notesController.dispose();
    _isStudyingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = false;

    // final birthDateJson = studentController.studentData.value?.birthDate;

    final dateFormatter = DateFormat('dd/MM/yyyy');
    // DateTime? birthDate;
    // if (birthDateJson != null && birthDateJson.isNotEmpty) {
    //   birthDate = DateTime.tryParse(birthDateJson);
    // }

    // final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black)),
            // Obx(
            //   () => Text(
            //     isEditing ? 'Edit Profile' : studentController.studentData.value?.fullName ?? '',
            //     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            //   ),
            // ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Obx(
              () => IconButton(
                onPressed: () async {
                  if (isEditing) {
                    // await studentController.getPutProfileStudent(
                    //   _gmailController.text,
                    //   _phoneController.text,
                    //   _fullNameController.text,
                    //   selectedBirthDateNotifier.value.toString(),
                    //   _cccdController.text,
                    //   _birthPlaceController.text,
                    //   _customYearController.text,
                    //   _genderController.text,
                    //   _hometownController.text,
                    //   _permanentAddressController.text,
                    //   _occupationController.text,
                    //   _contactPhoneController.text,
                    //   _contactAddressController.text,
                    //   _educationLevelController.text,
                    //   _academicPerformanceController.text,
                    //   _conductController.text,
                    //   _classRanking10Controller.text,
                    //   _classRanking11Controller.text,
                    //   _classRanking12Controller.text,
                    //   _graduationYearController.text,
                    //   _ethnicityController.text,
                    //   _religionController.text,
                    //   _beneficiaryController.text,
                    //   _areaController.text,
                    //   selectedJoinDateNotifier.value.toString(),
                    //   _idCardIssuedPlaceController.text,
                    //   _fatherFullNameController.text,
                    //   _motherFullNameController.text,
                    //   _notesController.text,
                    // );
                  } else {
                    isEditing = true;
                  }
                },
                icon: Icon(isEditing ? Icons.save : Icons.edit, size: 20, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageScreen(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                        ),
                        radius: 60,
                      ),
                    ),
                    isEditing
                        ? Positioned(
                            bottom: 3,
                            right: 2,
                            child: SizedBox(
                              child: InkWell(
                                onTap: () async {
                                  final result = await ImagePickerDialog.imgFromGallery();
                                  if (result.isNotEmpty) {
                                    selectedImagePath = result[0];
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000),
                                    color: Colors.grey[400],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.camera_alt, size: 16),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 8,
                  color: const Color(0xFFFAFAFA),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '1. Thông tin chung',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // isEditing == true
                      //     ? InkWell(
                      //         onTap: () async {
                      //           await _selectDate(context, 'birth');
                      //         },
                      //         child: ValueListenableBuilder(
                      //             valueListenable: selectedBirthDateNotifier,
                      //             builder: (context, date, child) {
                      //               return CustomTextWidgets(
                      //                 title: 'Ngày sinh',
                      //                 initialData: selectedBirthDate != null
                      //                     ? '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                      //                     : formattedBirthDate,
                      //                 keyboardType: TextInputType.datetime,
                      //               );
                      //             }),
                      //       )
                      //     : CustomTextWidgets(
                      //         title: 'Ngày sinh',
                      //         // initialData: studentController.studentData.value?.birthDate,
                      //         keyboardType: TextInputType.datetime,
                      //         initialData: formattedBirthDate,
                      //       ),
                      // const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '2. Thông học lực học sinh',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          '3. Thông học liên lạc',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
