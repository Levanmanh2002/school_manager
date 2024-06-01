// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/change_majors/change_majors_controller.dart';
import 'package:school_web/web/controllers/majors/majors_controller.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/utils/formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class ChangeMajorsPage extends StatefulWidget {
  const ChangeMajorsPage({super.key});

  @override
  State<ChangeMajorsPage> createState() => _ChangeMajorsPageState();
}

class _ChangeMajorsPageState extends State<ChangeMajorsPage> {
  final ChangeMajorsController changeMajorsController = Get.put(ChangeMajorsController());
  final MajorsController majorsController = Get.put(MajorsController());

  final authController = Get.put(AuthController());

  final TextEditingController studentController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  String? selectedClassValue;
  final textClassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    studentController.addListener(() {
      isClearVisible.value = studentController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    studentController.dispose();
    isClearVisible.dispose();
    textClassController.dispose();
    changeMajorsController.studentList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
              : const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Học sinh chuyển ngành',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              topListDataWidget(),
              const SizedBox(height: 24),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: changeMajorsController.studentList.length,
                  itemBuilder: (context, index) {
                    var student = changeMajorsController.studentList[index];

                    return student != null
                        ? Column(
                            children: [
                              centerListDataWidget(student),
                              const SizedBox(height: 24),
                              SvgPicture.asset(IconAssets.switchUpDownIcon),
                              const SizedBox(height: 24),
                              switchDataWidget(),
                            ],
                          )
                        : null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget centerListDataWidget(Students student) {
    return BoxShadowWidget(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thông tin học sinh',
              style: StyleThemeData.styleSize16Weight600(),
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailScreen(student: student),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: appTheme.primary50Color,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: CachedNetworkImage(
                      imageUrl: student.avatarUrl.toString(),
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.fullName ?? '',
                        style: StyleThemeData.styleSize14Weight600(),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('MSSV: ', style: StyleThemeData.styleSize14Weight500()),
                          Text(
                            student.mssv ?? '',
                            style: StyleThemeData.styleSize14Weight500(color: appTheme.appColor),
                          ),
                        ],
                      ),
                      if (student.major != null) const SizedBox(height: 4),
                      if (student.major != null)
                        Row(
                          children: [
                            Text('Ngành nghề: ',
                                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor)),
                            Text(
                              student.major?.name ?? '',
                              style: StyleThemeData.styleSize14Weight400(color: appTheme.successColor),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Số điện thoại: ${student.phone ?? ''}',
                        style: StyleThemeData.styleSize14Weight500(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(IconAssets.caretRightIcon, width: 24, height: 24, color: appTheme.appColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget switchDataWidget() {
    return BoxShadowWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Chuyển sang ngành', style: StyleThemeData.styleSize16Weight600()),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: appTheme.blackColor),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Danh sách ngành nghề',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
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
                    maxHeight: 500,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 60,
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textClassController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: (selectedClassValue != null)
                ? () async {
                    if (authController.teacherData.value?.system == 1 ||
                        authController.teacherData.value?.system == 2 ||
                        authController.teacherData.value?.system == 3) {
                      await changeMajorsController.changeMajor(
                        studentId: changeMajorsController.studentList.first.sId.toString(),
                        newMajorId: selectedClassValue.toString(),
                      );
                    } else {
                      showNoSystemWidget(
                        context,
                        title: 'Bạn không có quyền giáo viên',
                        des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                        cancel: 'Hủy',
                        confirm: 'Xác nhận',
                        ontap: () => Navigator.pop(context),
                      );
                    }
                  }
                : null,
            child: Obx(
              () => Opacity(
                opacity: selectedClassValue == null ? 0.5 : 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: appTheme.appColor,
                  ),
                  child: changeMajorsController.isLoadingBtn.isTrue
                      ? Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: appTheme.whiteColor),
                          ),
                        )
                      : Text(
                          'Xác nhận chuyển ngành',
                          style: StyleThemeData.styleSize14Weight600(color: appTheme.whiteColor, height: 0),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topListDataWidget() {
    return BoxShadowWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Nhập MSSV', style: StyleThemeData.styleSize16Weight400(color: appTheme.textDesColor)),
          ),
          const SizedBox(height: 8),
          inptData(),
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: isClearVisible,
            builder: (context, isVisible, child) {
              return Opacity(
                opacity: isClearVisible.value ? 1 : 0.5,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (authController.teacherData.value?.system == 1 ||
                          authController.teacherData.value?.system == 2) {
                        if (isClearVisible.value) {
                          FocusScope.of(context).unfocus();
                          changeMajorsController.searchStudent(studentController.text);
                        }
                      } else {
                        showNoSystemWidget(
                          context,
                          title: 'Bạn không có quyền',
                          des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                          cancel: 'Hủy',
                          confirm: 'Xác nhận',
                          ontap: () => Navigator.pop(context),
                        );
                      }
                    },
                    child: Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                        width: 121,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.appColor,
                        ),
                        alignment: Alignment.center,
                        child: changeMajorsController.isLoadingSearch.isTrue
                            ? Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: appTheme.whiteColor),
                                ),
                              )
                            : Text(
                                'Xác nhận',
                                style: StyleThemeData.styleSize14Weight600(color: appTheme.whiteColor),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> inptData() {
    void clearSearchText() {
      studentController.clear();
      isClearVisible.value = false;
      changeMajorsController.studentList.clear();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isClearVisible,
      builder: (context, isVisible, child) {
        return TextFormField(
          controller: studentController,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
            LengthLimitingTextInputFormatter(25),
            NoInitialSpaceInputFormatterWidgets(),
          ],
          cursorColor: appTheme.appColor,
          decoration: InputDecoration(
            isDense: true,
            fillColor: appTheme.whiteColor,
            filled: true,
            hintText: 'Nhập mã MSSV',
            hintStyle: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
            suffix: isVisible
                ? InkWell(
                    onTap: clearSearchText,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.textDesColor,
                      ),
                      child: Icon(Icons.clear_rounded, color: appTheme.whiteColor, size: 12),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.errorColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.strokeColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.strokeColor),
            ),
          ),
        );
      },
    );
  }
}
