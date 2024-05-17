import 'package:get/get.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/home/home_view.dart';
import 'package:school_web/web/pages/majors/majors_pages.dart';
import 'package:school_web/web/pages/notifications/notifications_details.dart';
import 'package:school_web/web/pages/other_payment/other_payment_pages.dart';
import 'package:school_web/web/pages/fees/fee_page.dart';
import 'package:school_web/web/pages/profile/edit_profile_pages.dart';
import 'package:school_web/web/pages/profile/profile_pages.dart';
import 'package:school_web/web/pages/screen/classes/view/class_info_view.dart';
import 'package:school_web/web/pages/screen/student/view/add_student_view.dart';
import 'package:school_web/web/pages/screen/student/view/get_student_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/add_teacher_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/get_teachers_view.dart';
import 'package:school_web/web/pages/change_majors/change_majors_page.dart';
import 'package:school_web/web/pages/system/system_pages.dart';

class SideBarController extends GetxController {
  RxInt index = 0.obs;
  Rx<Students?> currentStudent = Rx<Students?>(null);
  Rx<TeacherData?> currentTeacher = Rx<TeacherData?>(null);

  var pageRoutes = [
    const HomeView(), // 0
    const GetTeachersView(), // 1
    const GetStudentView(), // 2
    const ClassesInfoView(), // 3
    const MajorsPages(), // 4
    const FeePages(), // 5
    const OtherPaymentPages(), // 6
    const ChangeMajorsPage(), // 7
    const SystemPages(), // 8
    const NotificationsDetails(), // 9
    const AddTeacherView(), // 10
    const AddStudentView(), // 11
    const ProfilePages(), // 12
    const EditProfilePages(), // 13
    null, // 14
    null, // 15
  ];

  void navigateToStudentDetail(Students student) {
    currentStudent.value = student;
    index.value = 14;
  }

  void navigateToTeacherDetail(TeacherData teacher) {
    currentTeacher.value = teacher;
    index.value = 15;
  }
}
