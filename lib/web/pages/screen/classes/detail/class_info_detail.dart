import 'package:flutter/material.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';

class ClassesInfoDetail extends StatelessWidget {
  const ClassesInfoDetail({required this.students, required this.classes, super.key});

  final List<Students>? students;
  final String classes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Lớp: $classes',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: ListView.builder(
          itemCount: students?.length ?? 0,
          itemBuilder: (context, index) {
            final student = students![index];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 1,
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(student.avatarUrl ??
                        'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512'),
                    radius: 30,
                  ),
                  title: Text(
                    student.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(student.mssv ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailScreen(student: student),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}

// class ClassesInfoDetail extends StatelessWidget {
//   const ClassesInfoDetail({required this.students, required this.classes, super.key});

//   final List<StudentData>? students;
//   final String classes;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Text(
//           'Lớp: $classes',
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
//         ),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
//               ),
//               Text(
//                 'Lớp: $classes',
//               ),
//             ],
//           ),
//           titleTabWidget(
//             name: 'Họ và tên',
//             code: 'MSSV',
//             industry: 'Ngành học',
//             email: 'Email',
//             phone: 'Số điện thoại',
//             status: 'Trạng thái',
//           ),
//           ListView.builder(
//             itemCount: students?.length ?? 0,
//             itemBuilder: (context, index) {
//               final student = students![index];
//               return titleTabWidget(
//                 // student: student,
//                 name: student.fullName ?? '',
//                 code: student.mssv ?? '',
//                 industry: student.occupation ?? '',
//                 email: student.gmail ?? '',
//                 phone: student.phone ?? '',
//                 status: 'student.isStudying',
//                 //== true
//                 //     ? 'Đang học'
//                 //     : student.selfSuspension == true
//                 //         ? 'Nghỉ học'
//                 //         : student.suspension == true
//                 //             ? 'Đình chỉ'
//                 //             : student.expulsion == true
//                 //                 ? 'Bị đuổi học'
//                 //                 : 'Đang học',
//               );
//             },
//           ),
//         ],
//       ),
//       //   body: ListView.builder(
//       //       itemCount: students?.length ?? 0,
//       //       itemBuilder: (context, index) {
//       //         final student = students![index];

//       //         return Padding(
//       //           padding: const EdgeInsets.all(16),
//       //           child: Card(
//       //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       //             elevation: 1,
//       //             color: Colors.white,
//       //             child: ListTile(
//       //               leading: CircleAvatar(
//       //                 backgroundImage: NetworkImage(student.avatarUrl ??
//       //                     'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512'),
//       //                 radius: 30,
//       //               ),
//       //               title: Text(
//       //                 student.fullName ?? '',
//       //                 style: const TextStyle(
//       //                   fontSize: 16,
//       //                   color: Colors.black,
//       //                   fontWeight: FontWeight.bold,
//       //                 ),
//       //               ),
//       //               subtitle: Text(student.mssv ?? ''),
//       //               trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
//       //               onTap: () {
//       //                 Navigator.push(
//       //                   context,
//       //                   MaterialPageRoute(
//       //                     builder: (context) => StudentDetailScreen(student: student),
//       //                   ),
//       //                 );
//       //               },
//       //             ),
//       //           ),
//       //         );
//       //       }),
//     );
//   }

//   Widget titleTabWidget({
//     required String name,
//     required String code,
//     required String industry,
//     required String email,
//     required String phone,
//     required String status,
//     // StudentData? student,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 200),
//                 width: 200,
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF7E8695),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 100),
//                 width: 100,
//                 child: Text(
//                   code,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF7E8695),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 110),
//                 width: 110,
//                 child: Text(
//                   industry,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF7E8695),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 200),
//                 width: 200,
//                 child: Text(
//                   email,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF7E8695),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 100),
//                 width: 100,
//                 child: Text(
//                   phone,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF7E8695),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 // constraints: const BoxConstraints(maxWidth: 110),
//                 width: 110,
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: const Color(0xFF3BB53B),
//                     height: 1.5,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 12),
//             child: Divider(height: 0),
//           ),
//         ],
//       ),
//     );
//   }
// }
