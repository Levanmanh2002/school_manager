// ignore_for_file: unnecessary_type_check, unnecessary_null_comparison, prefer_if_null_operators

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/class/class_controller.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/controllers/student/student_controller.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/classes/detail/class_info_detail.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/button_status_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/data_widget.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class ClassesInfoView extends StatefulWidget {
  const ClassesInfoView({super.key});

  @override
  State<ClassesInfoView> createState() => _ClassesInfoViewState();
}

class _ClassesInfoViewState extends State<ClassesInfoView> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClassesController classesController = Get.put(ClassesController());
  final AuthController authController = Get.put(AuthController());
  final HomeController homeController = Get.put(HomeController());
  final StudentController studentController = Get.put(StudentController());

  final TextEditingController nameClassController = TextEditingController();
  final TextEditingController editNameClassController = TextEditingController();

  String selectedTeacher = '';
  TeacherData? showSelectedTeacher;
  MajorsData? nameListMajors;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameClassController.dispose();
    editNameClassController.dispose();
    isClearVisible.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: Responsive.isMobile(context) ? 16 : 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách lớp học',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 18 : 24,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blackColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (authController.teacherData.value?.system == 1 ||
                          authController.teacherData.value?.system == 2) {
                        addClasses(context);
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
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appTheme.appColor,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(IconAssets.booksIcon),
                          const SizedBox(width: 8),
                          Text(
                            'Tạo lớp học',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: appTheme.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách lớp học',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: appTheme.blackColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appTheme.primary50Color,
                      ),
                      child: Obx(
                        () => Text(
                          'Tổng số lớp học: ${classesController.classesList.length.toString()}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.appColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          itemText(context),
                          const SizedBox(height: 12),
                          Obx(
                            () {
                              if (classesController.filteredClassList != null) {
                                if (classesController.filteredClassList.isNotEmpty) {
                                  return Column(
                                    children: classesController.filteredClassList.map((classInfo) {
                                      return itemDataText(
                                        nameClass: classInfo.className ?? '',
                                        teacher: classInfo.teacher != null && classInfo.teacher!.isNotEmpty
                                            ? classInfo.teacher!.first.fullName ?? ''
                                            : '',
                                        job: classInfo.job.toString(),
                                        listStudent: classInfo.className ?? '',
                                        viewClassOnTap: () {
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => ClassesInfoDetail(
                                          //       students: classInfo.students,
                                          //       classes: classInfo.className.toString(),
                                          //     ),
                                          //   ),
                                          // );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                ),
                                                alignment: Alignment.center,
                                                insetPadding: const EdgeInsets.all(40),
                                                child: ClassesInfoDetail(
                                                  students: classInfo.students,
                                                  classes: classInfo.className.toString(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        deleteOnTap: () {
                                          if (authController.teacherData.value?.system == 1 ||
                                              authController.teacherData.value?.system == 2) {
                                            showNoSystemWidget(
                                              context,
                                              title: 'Xác nhận xóa lớp?',
                                              des: 'Bạn có chắc chắn muốn xóa, không thể khôi phục khi đã xóa?',
                                              cancel: 'Hủy',
                                              confirm: 'Xác nhận',
                                              ontap: () {
                                                Navigator.of(context).pop();
                                                classesController.deleteClass(classInfo.id.toString(), context);
                                              },
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
                                        },
                                        editOnTap: () {
                                          if (authController.teacherData.value?.system == 1 ||
                                              authController.teacherData.value?.system == 2 ||
                                              authController.teacherData.value?.system == 3) {
                                            editClasses(
                                              context,
                                              classInfo,
                                              () {
                                                List<String> studentIds = [];

                                                if (classInfo.students != null) {
                                                  for (var student in classInfo.students!) {
                                                    studentIds.add(student.sId.toString());
                                                  }
                                                }

                                                if (_formKey.currentState!.validate()) {
                                                  classesController.editClass(
                                                    classInfo.id.toString(),
                                                    updatedClassName: editNameClassController.text,
                                                    updatedTeacherId: selectedTeacher == null
                                                        ? classInfo.teacher!.first.sId.toString()
                                                        : selectedTeacher,
                                                    updatedJob: nameListMajors == null
                                                        ? classInfo.job.toString()
                                                        : nameListMajors?.name ?? '',
                                                    updatedStudentIds: classesController.selectedStudents == null
                                                        ? studentIds
                                                        : classesController.selectedStudents,
                                                  );
                                                }
                                              },
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
                                        },
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              } else {
                                return const Text('Data is null');
                              }
                            },
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
    );
  }

  Widget itemDataText({
    required String nameClass,
    required String teacher,
    required String job,
    required String listStudent,
    required VoidCallback deleteOnTap,
    required VoidCallback editOnTap,
    required VoidCallback viewClassOnTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 4
                : MediaQuery.of(context).size.width / 8,
            child: Text(
              nameClass,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              teacher,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6.6,
            child: Text(
              job,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 7.8,
            child: InkWell(
              onTap: viewClassOnTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: appTheme.appColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Danh sách lớp $listStudent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: appTheme.whiteColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(IconAssets.shareIcon),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6.2,
            child: Row(
              children: [
                InkWell(
                  onTap: deleteOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.errorColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: appTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.clear, size: 12, color: appTheme.whiteColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: editOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sửa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: appTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(IconAssets.editIcon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addClasses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: Text(
              'Thêm lớp học mới',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidgets(
                      controller: nameClassController,
                      title: 'Tên lớp học',
                      hintText: 'Nhập tên lớp',
                      validator: true,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Danh sách giáo viên',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor, height: 0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.strokeColor),
                        ),
                        child: DropdownButton2<TeacherData>(
                          isExpanded: true,
                          hint: Text(
                            'Danh sách giáo viên',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                          ),
                          value: showSelectedTeacher,
                          iconStyleData:
                              IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: appTheme.textDesColor)),
                          onChanged: (TeacherData? newValue) {
                            setState(() {
                              selectedTeacher = newValue!.sId.toString();
                              showSelectedTeacher = newValue;
                            });
                          },
                          underline: Container(height: 0),
                          items: classesController.teachers.map((TeacherData teacher) {
                            return DropdownMenuItem<TeacherData>(
                              value: teacher,
                              child: DataWidget(
                                name: teacher.fullName ?? '',
                                code: 'MSGV',
                                codeData: teacher.teacherCode ?? '',
                                phone: teacher.phoneNumber ?? '',
                                show: false,
                                color: appTheme.appColor,
                                showPhone: false,
                                showDivider: false,
                                imageUrl: teacher.avatarUrl,
                              ),
                            );
                          }).toList(),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            width: double.maxFinite,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 500,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            'Ngành nghề',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '*',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor, height: 0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.strokeColor),
                        ),
                        child: DropdownButton2<MajorsData>(
                          isExpanded: true,
                          hint: Text(
                            'Ngành nghề',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                          ),
                          value: nameListMajors,
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down, color: appTheme.textDesColor),
                          ),
                          onChanged: (MajorsData? newValue) {
                            setState(() {
                              nameListMajors = newValue;
                            });
                          },
                          underline: Container(height: 0),
                          items: classesController.listMajors.map((MajorsData majorsData) {
                            return DropdownMenuItem<MajorsData>(
                              value: majorsData,
                              child: Text(majorsData.name ?? '', style: StyleThemeData.styleSize14Weight400()),
                            );
                          }).toList(),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            width: double.maxFinite,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 500,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: appTheme.textDesColor),
                            ),
                            child: Text(
                              'Hủy',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.textDesColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(
                          () => InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (selectedTeacher.isNotEmpty) {
                                  if (nameListMajors != null &&
                                      nameListMajors!.name != null &&
                                      nameListMajors!.name!.isNotEmpty) {
                                    classesController.createListClass(
                                      context,
                                      className: nameClassController.text,
                                      teacherId: selectedTeacher,
                                      studentIds: classesController.selectedStudents,
                                      job: nameListMajors?.name ?? '',
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Lỗi",
                                      "Vui lòng lựa chọn ngành nghề.",
                                      backgroundColor: appTheme.errorColor,
                                      colorText: appTheme.whiteColor,
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    "Lỗi",
                                    "Vui lòng lựa chọn giáo viên.",
                                    backgroundColor: appTheme.errorColor,
                                    colorText: appTheme.whiteColor,
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              width: 110,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: appTheme.appColor,
                              ),
                              child: classesController.isLoading.isTrue
                                  ? SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(color: appTheme.whiteColor),
                                    )
                                  : Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.whiteColor),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    listStudent(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void editClasses(BuildContext context, ClassInfoData classInfo, VoidCallback editOnTap) {
    editNameClassController.text = classInfo.className.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'Chỉnh sửa thông tin lớp học',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidgets(
                      controller: editNameClassController,
                      title: 'Tên lớp học',
                      hintText: classInfo.className!.isNotEmpty ? classInfo.className.toString() : 'Nhập tên lớp',
                      borderRadius: 8,
                      validator: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Danh sách giáo viên',
                        style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.strokeColor),
                        ),
                        child: DropdownButton2<TeacherData>(
                          isExpanded: true,
                          hint: (showSelectedTeacher != null)
                              ? Text(
                                  showSelectedTeacher!.fullName.toString(),
                                  style: StyleThemeData.styleSize14Weight400(height: 0),
                                )
                              : (classInfo != null && classInfo.teacher != null && classInfo.teacher!.isNotEmpty)
                                  ? Text(
                                      classInfo.teacher!.first.fullName.toString(),
                                      style:
                                          StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                                    )
                                  : Text(
                                      'Danh sách giáo viên',
                                      style:
                                          StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                                    ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down, color: appTheme.textDesColor),
                          ),
                          onChanged: (TeacherData? newValue) {
                            setState(() {
                              selectedTeacher = newValue!.sId.toString();
                              showSelectedTeacher = newValue;
                            });
                          },
                          underline: Container(height: 0),
                          items: classesController.teachers.map((TeacherData teacher) {
                            return DropdownMenuItem<TeacherData>(
                              value: teacher,
                              child: DataWidget(
                                name: teacher.fullName ?? '',
                                code: 'MSGV',
                                codeData: teacher.teacherCode ?? '',
                                phone: teacher.phoneNumber ?? '',
                                show: false,
                                color: appTheme.appColor,
                                showPhone: false,
                                showDivider: false,
                                imageUrl: teacher.avatarUrl,
                              ),
                            );
                          }).toList(),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            width: double.maxFinite,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 500,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Ngành nghề',
                        style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.strokeColor),
                        ),
                        child: DropdownButton2<MajorsData>(
                          isExpanded: true,
                          hint: (classInfo != null)
                              ? Text(
                                  classInfo.job.toString(),
                                  style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                                )
                              : Text(
                                  'Ngành nghề',
                                  style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
                                ),
                          value: nameListMajors,
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down, color: appTheme.textDesColor),
                          ),
                          onChanged: (MajorsData? newValue) {
                            setState(() {
                              nameListMajors = newValue;
                            });
                          },
                          underline: Container(height: 0),
                          items: classesController.listMajors.map((MajorsData majorsData) {
                            return DropdownMenuItem<MajorsData>(
                              value: majorsData,
                              child: Text(majorsData.name ?? '', style: StyleThemeData.styleSize14Weight400()),
                            );
                          }).toList(),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            width: double.maxFinite,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 500,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 32,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: appTheme.textDesColor),
                            ),
                            child: Text(
                              'Hủy',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.textDesColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(
                          () => InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                editOnTap();
                              }
                            },
                            child: Container(
                              width: 110,
                              height: 32,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: appTheme.appColor,
                              ),
                              child: classesController.isLoadingEdit.isTrue
                                  ? SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(color: appTheme.whiteColor),
                                    )
                                  : Text(
                                      'Xác nhận',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: appTheme.whiteColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    listStudent(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row itemText(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 4
              : MediaQuery.of(context).size.width / 8,
          child: Text(
            'Tên lớp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6,
          child: Text(
            'Giáo viên chủ nhiệm',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6.6,
          child: Text(
            'Ngành nghề',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 7.8,
          child: Text(
            'Danh sách học sinh',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6,
          child: Text(
            'Hành động',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
          ),
        ),
      ],
    );
  }

  Widget listStudent() {
    void clearSearchText() {
      searchController.clear();
      isClearVisible.value = false;
      studentController.searchStudent('');
    }

    return Obx(
      () => BoxShadowWidget(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách học sinh',
                style: StyleThemeData.styleSize16Weight600(),
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: isClearVisible,
              builder: (context, isVisible, child) {
                return CustomTextWidgets(
                  controller: searchController,
                  hintText: 'Tìm kiếm học sinh',
                  prefixIcon: IconButton(
                    onPressed: null,
                    icon: SvgPicture.asset(IconAssets.searchIcon, width: 18, height: 18),
                  ),
                  boolTitle: true,
                  suffixIcon: isVisible
                      ? IconButton(
                          onPressed: clearSearchText,
                          icon: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appTheme.textDesColor,
                            ),
                            child: Icon(Icons.clear_rounded, color: appTheme.whiteColor, size: 12),
                          ),
                        )
                      : null,
                  borderRadius: 41,
                  fillColor: appTheme.background700Color,
                  showBorder: BorderSide(color: appTheme.background700Color),
                  onChanged: (query) {
                    studentController.searchStudent(query);
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ButtonStatusWidget(
                  text: 'Số lượng học sinh',
                  data: homeController.totalAll.toString(),
                  borderColor: appTheme.primary50Color,
                  color: appTheme.appColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...studentController.filteredActiveList.map((student) {
              final isSelected = classesController.selectedStudents.contains(student.sId);

              return GestureDetector(
                onTap: () {
                  classesController.toggleStudentSelection(student.sId.toString());
                },
                onLongPressStart: (details) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetailScreen(student: student),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? appTheme.appColor : appTheme.transparentColor,
                          width: 2,
                        ),
                      ),
                      child: DataWidget(
                        name: student.fullName ?? '',
                        code: 'MSSV',
                        codeData: student.mssv ?? '',
                        phone: student.phone ?? '',
                        show: false,
                        color: appTheme.appColor,
                        showDivider: false,
                        imageUrl: student.avatarUrl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 0, color: appTheme.strokeColor),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
