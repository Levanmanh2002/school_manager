import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/component_library/image_picker_dialog.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class EditProfilePages extends StatefulWidget {
  const EditProfilePages({super.key});

  @override
  State<EditProfilePages> createState() => _EditProfilePagesState();
}

class _EditProfilePagesState extends State<EditProfilePages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TeacherData? teacherData;
  final authController = Get.put(AuthenticationController());
  late final String? _selectedGender = authController.teacherData.value?.gender;

  late bool isCivilServant = authController.teacherData.value?.civilServant ?? true;
  late bool isSeletedIsWorking = authController.teacherData.value?.isWorking ?? false;

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

  Future<dynamic> updateAvatar() async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(
        'https://backend-shool-project.onrender.com/admin/edit-avatar/${authController.teacherData.value!.sId}',
      ),
    );
    request.files.add(await http.MultipartFile.fromPath('file', selectedImagePath.toString()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      Get.back();
      Get.snackbar(
        "Thành công",
        "Đổi ảnh đại diện thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print(await response.stream.bytesToString());
    } else {
      Get.snackbar(
        "Thất bại",
        "Lỗi đổi ảnh đại diện!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    authController.getProfileData();
    super.initState();
  }

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _teachingLevelController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _civilServantController = TextEditingController();
  final TextEditingController _contractTypeController = TextEditingController();
  final TextEditingController _primarySubjectController = TextEditingController();
  final TextEditingController _secondarySubjectController = TextEditingController();
  final TextEditingController _academicDegreeController = TextEditingController();
  final TextEditingController _standardDegreeController = TextEditingController();
  final TextEditingController _politicalTheoryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _cccdController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _birthPlaceController.dispose();
    _ethnicityController.dispose();
    _nicknameController.dispose();
    _teachingLevelController.dispose();
    _positionController.dispose();
    _experienceController.dispose();
    _departmentController.dispose();
    _roleController.dispose();
    _civilServantController.dispose();
    _contractTypeController.dispose();
    _primarySubjectController.dispose();
    _secondarySubjectController.dispose();
    _academicDegreeController.dispose();
    _standardDegreeController.dispose();
    _politicalTheoryController.dispose();
    selectedBirthDateNotifier.dispose();
    selectedJoinDateNotifier.dispose();
    addressController.dispose();
    cityController.dispose();
    districtController.dispose();
    wardController.dispose();
    super.dispose();
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : 24),
          child: Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: AppColors.blackColor)),
              const Text(
                'Cập nhật hồ sơ',
                style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Responsive.isMobile(context)
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImageScreen(
                                    imageUrl: authController.teacherData.value!.avatarUrl ??
                                        'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                authController.teacherData.value?.avatarUrl ??
                                    'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                              ),
                              radius: 80,
                            ),
                          ),
                    Responsive.isMobile(context) ? const SizedBox.shrink() : const SizedBox(height: 24),
                    Responsive.isMobile(context)
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: () async {
                              final result = await ImagePickerDialog.imgFromGallery();
                              if (result.isNotEmpty) {
                                selectedImagePath = result[0];
                                updateAvatar();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryColor,
                              ),
                              child: const Text(
                                'Chọn ảnh',
                                style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                              ),
                            ),
                          ),
                  ],
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          Responsive.isMobile(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Responsive.isMobile(context)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenImageScreen(
                                        imageUrl: authController.teacherData.value!.avatarUrl ??
                                            'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    authController.teacherData.value?.avatarUrl ??
                                        'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                  ),
                                  radius: 80,
                                ),
                              )
                            : const SizedBox.shrink(),
                        Responsive.isMobile(context) ? const SizedBox(height: 24) : const SizedBox.shrink(),
                        Responsive.isMobile(context)
                            ? InkWell(
                                onTap: () async {
                                  final result = await ImagePickerDialog.imgFromGallery();
                                  if (result.isNotEmpty) {
                                    selectedImagePath = result[0];
                                    updateAvatar();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: const Text(
                                    'Chọn ảnh',
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      controller: _fullNameController,
                                      title: 'Họ và Tên',
                                      hintText: authController.teacherData.value?.fullName ?? '',
                                      keyboardType: TextInputType.name,
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: _cccdController,
                                      title: 'CMND/CCCD',
                                      hintText: authController.teacherData.value?.cccd ?? '',
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: _emailController,
                                      title: 'Email',
                                      hintText: authController.teacherData.value?.email ?? '',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: _phoneNumberController,
                                      title: 'Số điện thoại',
                                      hintText: authController.teacherData.value?.phoneNumber ?? '',
                                      keyboardType: TextInputType.phone,
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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
                                              color: AppColors.blackColor,
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
                                            value: _selectedGender,
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
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              _genderController.text = newValue!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Ngày sinh',
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
                                          child: ValueListenableBuilder<DateTime?>(
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
                                                      : formattedBirthDate,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blackColor,
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
                                      controller: _academicDegreeController,
                                      title: 'Học vấn',
                                      hintText: authController.teacherData.value?.academicDegree ?? '',
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: _experienceController,
                                      title: 'Kinh nghiệm',
                                      hintText: authController.teacherData.value?.experience ?? '',
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      controller: _contractTypeController,
                                      title: 'Loại hợp đồng',
                                      hintText: authController.teacherData.value?.contractType ?? '',
                                      validator: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Ngày tham gia',
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
                                                      : formattedJoinDate,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Tình trạng đang làm việc',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackColor,
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
                                          child: DropdownButtonFormField<bool>(
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.only(bottom: 9),
                                            ),
                                            value: isSeletedIsWorking,
                                            elevation: 0,
                                            icon: const Icon(Icons.keyboard_arrow_down_outlined,
                                                color: Color(0xFFB6BBC3)),
                                            padding: const EdgeInsets.only(left: 16, right: 24),
                                            isExpanded: true,
                                            alignment: Alignment.topCenter,
                                            items: const [
                                              DropdownMenuItem(
                                                value: true,
                                                child: Text(
                                                  'Đang làm việc',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: false,
                                                child: Text(
                                                  'Đã nghỉ làm',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            onChanged: (newValue) {
                                              isSeletedIsWorking = newValue!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
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
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: Responsive.isMobile(context) ? 24 : 24 + 24),
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
                      Get.offAllNamed(Routes.DASHBOARD);
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.textDesColor),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDesColor),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.getPutProfileTeacher(
                      _fullNameController.text,
                      _cccdController.text,
                      _emailController.text,
                      _phoneNumberController.text,
                      _genderController.text,
                      selectedBirthDateNotifier.value.toString(),
                      _birthPlaceController.text,
                      _ethnicityController.text,
                      _nicknameController.text,
                      _teachingLevelController.text,
                      _positionController.text,
                      _experienceController.text,
                      _departmentController.text,
                      _roleController.text,
                      selectedJoinDateNotifier.value.toString(),
                      isCivilServant.toString(),
                      _contractTypeController.text,
                      _primarySubjectController.text,
                      _secondarySubjectController.text,
                      isSeletedIsWorking.toString(),
                      _academicDegreeController.text,
                      _standardDegreeController.text,
                      _politicalTheoryController.text,
                      addressController.text,
                      cityController.text,
                      districtController.text,
                      wardController.text,
                    );
                  }
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryColor,
                  ),
                  child: const Text(
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
