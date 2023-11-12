import 'package:get/get.dart';
import 'package:school_web/web/pages/home/home_view.dart';
import 'package:school_web/web/pages/majors/majors_pages.dart';
import 'package:school_web/web/pages/profile/profile_pages.dart';
import 'package:school_web/web/pages/screen/classes/view/add_student_classes_view.dart';
import 'package:school_web/web/pages/screen/classes/view/add_teacher_classes_view.dart';
import 'package:school_web/web/pages/screen/classes/view/class_info_view.dart';
import 'package:school_web/web/pages/screen/student/view/add_student_view.dart';
import 'package:school_web/web/pages/screen/student/view/get_student_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/add_teacher_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/get_teachers_view.dart';
import 'package:school_web/web/pages/student_transfer/student_transfer_page.dart';
import 'package:school_web/web/pages/timetable/timetable.dart';

class SideBarController extends GetxController {
  RxInt index = 0.obs;

  var pageRoutes = [
    const HomeView(),
    const AddTeacherView(),
    const AddStudentView(),
    const GetTeachersView(),
    const GetStudentView(),
    const MajorsPages(),
    const ClassesInfoView(),
    const AddStudentClassesView(),
    const AddTeacherClassesView(),
    const TimetablePage(),
    const StudentTransferPage(),
    const ProfilePages(),
  ];
}
