// // ignore_for_file: unnecessary_null_comparison

// import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:school_web/web/constants/style.dart';
// import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
// import 'package:school_web/web/models/fee.dart';
// import 'package:school_web/web/pages/dashboard/config/responsive.dart';
// import 'package:school_web/web/utils/assets/icons.dart';
// import 'package:http/http.dart' as http;
// import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class FeePages extends StatefulWidget {
  const FeePages({super.key});

  @override
  State<FeePages> createState() => _FeePagesState();
}

class _FeePagesState extends State<FeePages> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final AuthenticationController authController = Get.put(AuthenticationController());
//   final TextEditingController searchCodeController = TextEditingController();
//   final TextEditingController contentController = TextEditingController();
//   final TextEditingController issuedAmountController = TextEditingController();
//   final TextEditingController remainingAmountController = TextEditingController();
//   final TextEditingController editSearchCodeController = TextEditingController();
//   final TextEditingController editContentController = TextEditingController();
//   final TextEditingController editIssuedAmountController = TextEditingController();
//   final TextEditingController editRemainingAmountController = TextEditingController();

//   /// Tạm thời bỏ paidAmount, debtAmount
//   final Rx<DateTime> selectedStartTimeDate = DateTime.now().obs;
//   final Rx<DateTime> editSelectedStartTimeDate = DateTime.now().obs;
//   final RxList<Fees> fees = <Fees>[].obs;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/all_fees'));

//       if (response.statusCode == 201) {
//         final List<dynamic> data = json.decode(response.body)['data'];

//         fees.assignAll(data.map((e) => Fees.fromJson(e)).toList());
//       } else {
//         print(response.reasonPhrase);
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> onFeesAddSubfees(String id) async {
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request(
//       'POST',
//       Uri.parse('https://backend-shool-project.onrender.com/admin/fees/$id/subfees'),
//     );

//     /// Tạm thời bỏ paidAmount, debtAmount
//     request.body = json.encode({
//       "searchCode": searchCodeController.text,
//       "content": contentController.text,
//       "issuedAmount": issuedAmountController.text,
//       "paidAmount": 0,
//       "remainingAmount": remainingAmountController.text,
//       "debtAmount": 0,
//       "dueDate": DateFormat('yyyy-MM-dd').format(selectedStartTimeDate.value),
//     });

//     print(request.body);
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     print(response.statusCode);
//     if (response.statusCode == 201) {
//       Get.snackbar(
//         "Thành công",
//         "Thêm học phí mới thành công!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       searchCodeController.clear();
//       contentController.clear();
//       issuedAmountController.clear();
//       remainingAmountController.clear();
//       await fetchData();
//     } else {
//       Get.snackbar(
//         "Lỗi",
//         "Thêm học phí mới thất bại.",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       print(response.reasonPhrase);
//     }
//   }

//   /// Tạm thời bỏ paidAmount, debtAmount
//   Future<void> onEditSubFees(String feeId, String subFeeId) async {
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request(
//       'PUT',
//       Uri.parse('https://backend-shool-project.onrender.com/admin/edit_fees/$feeId/edit_subfees/$subFeeId'),
//     );
//     request.body = json.encode({
//       "searchCode": editSearchCodeController.text,
//       "content": editContentController.text,
//       "issuedAmount": editIssuedAmountController.text,
//       "paidAmount": 0,
//       "remainingAmount": editRemainingAmountController.text,
//       "debtAmount": 0,
//       "dueDate": DateFormat('yyyy-MM-dd').format(editSelectedStartTimeDate.value),
//     });
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 201) {
//       Get.snackbar(
//         "Thành công",
//         "Chỉnh sửa học phí thành công!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       editSearchCodeController.clear();
//       editContentController.clear();
//       editIssuedAmountController.clear();
//       editRemainingAmountController.clear();
//       await fetchData();
//       print(await response.stream.bytesToString());
//     } else {
//       Get.snackbar(
//         "Lỗi",
//         "Chỉnh sửa học phí thất bại.",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       print(response.reasonPhrase);
//     }
//   }

//   Future<dynamic> onDeleteSubfees(String feeId, String subFeeId) async {
//     var request = http.Request(
//       'DELETE',
//       Uri.parse('https://backend-shool-project.onrender.com/admin/fees/$feeId/subfees/$subFeeId'),
//     );

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 201) {
//       Get.snackbar(
//         "Thành công",
//         "Khoản thu đã được xóa!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       await fetchData();
//       print(await response.stream.bytesToString());
//     } else {
//       Get.snackbar(
//         "Thất bại",
//         "Lỗi xóa khoản thu!",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       print(response.reasonPhrase);
//     }
//   }

//   Future<void> _selectStartTimeDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedStartTimeDate.value,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       selectedStartTimeDate(picked);
//     } else {
//       selectedStartTimeDate(DateTime.now());
//     }
//   }

//   Future<void> _editSelectStartTimeDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: editSelectedStartTimeDate.value,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       editSelectedStartTimeDate(picked);
//     } else {
//       editSelectedStartTimeDate(DateTime.now());
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     searchCodeController.dispose();
//     contentController.dispose();
//     issuedAmountController.dispose();
//     remainingAmountController.dispose();
//     editSearchCodeController.dispose();
//     editContentController.dispose();
//     editIssuedAmountController.dispose();
//     editRemainingAmountController.dispose();
//   }

//   @override
  Widget build(BuildContext context) {
    return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 24, horizontal: Responsive.isMobile(context) ? 16 : 32),
//           child: Column(
//             children: [
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Học phí',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.blackColor),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Container(
//                 padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 24),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(24),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x143A73C2),
//                       blurRadius: 8.0,
//                       offset: Offset(0, 0),
//                     ),
//                     BoxShadow(
//                       color: Color(0x143A73C2),
//                       blurRadius: 8.0,
//                       offset: Offset(0, 0),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Thông tin học phí',
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackColor),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             if (authController.teacherData.value?.system == 1 ||
//                                 authController.teacherData.value?.system == 2) {
//                               _showAddCreateFeeDialog(context, () => onFeesAddSubfees(fees.first.sId.toString()));
//                             } else {
//                               showNoSystemWidget(
//                                 context,
//                                 title: 'Bạn không có quyền giáo viên',
//                                 des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
//                                 cancel: 'Hủy',
//                                 confirm: 'Xác nhận',
//                                 ontap: () => Navigator.pop(context),
//                               );
//                             }
//                           },
//                           child: Container(
//                             padding:
//                                 EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: AppColors.primaryColor),
//                             ),
//                             child: Row(
//                               children: [
//                                 SvgPicture.asset(IconAssets.coinsIcon),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   'Thêm học phí mới',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: AppColors.trokeColor,
//                       ),
//                       child: SizedBox(
//                         width: Responsive.isMobile(context)
//                             ? MediaQuery.of(context).size.width / 1.3
//                             : MediaQuery.of(context).size.width,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Column(
//                             children: [
//                               itemTextWidget(),
//                               Obx(() {
//                                 return Column(
//                                   children: List.generate(
//                                     fees.length,
//                                     (index) {
//                                       final fee = fees[index];
//                                       return Column(
//                                         children: fee.subFees!.map((subFees) {
//                                           DateTime dueDate = DateTime.parse(subFees.dueDate!);

//                                           return itemDataText(
//                                             editOnTap: () {
//                                               if (authController.teacherData.value?.system == 1 ||
//                                                   authController.teacherData.value?.system == 2 ||
//                                                   authController.teacherData.value?.system == 3) {
//                                                 _showEditSubFeesDialog(
//                                                   context,
//                                                   subFees,
//                                                   () => onEditSubFees(fee.sId.toString(), subFees.sId.toString()),
//                                                 );
//                                               } else {
//                                                 showNoSystemWidget(
//                                                   context,
//                                                   title: 'Bạn không có quyền giáo viên',
//                                                   des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
//                                                   cancel: 'Hủy',
//                                                   confirm: 'Xác nhận',
//                                                   ontap: () => Navigator.pop(context),
//                                                 );
//                                               }
//                                             },
//                                             deleteOnTap: () {
//                                               if (authController.teacherData.value?.system == 1 ||
//                                                   authController.teacherData.value?.system == 2) {
//                                                 showNoSystemWidget(
//                                                   context,
//                                                   title: 'Xác nhận xóa học phí?',
//                                                   des: 'Bạn có chắc chắn muốn xóa, không thể khôi phục khi đã xóa? ',
//                                                   cancel: 'Hủy',
//                                                   confirm: 'Xác nhận',
//                                                   ontap: () {
//                                                     Navigator.of(context).pop();
//                                                     onDeleteSubfees(fee.sId.toString(), subFees.sId.toString());
//                                                   },
//                                                 );
//                                               } else {
//                                                 showNoSystemWidget(
//                                                   context,
//                                                   title: 'Bạn không có quyền giáo viên',
//                                                   des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
//                                                   cancel: 'Hủy',
//                                                   confirm: 'Xác nhận',
//                                                   ontap: () => Navigator.pop(context),
//                                                 );
//                                               }
//                                             },
//                                             searchCode: subFees.searchCode ?? '',
//                                             content: subFees.content ?? '',
//                                             issuedAmount: subFees.issuedAmount.toString(),
//                                             remainingAmount: subFees.remainingAmount.toString(),
//                                             dueDate: DateFormat('dd-MM-yyyy').format(dueDate),
//                                           );
//                                         }).toList(),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget itemDataText({
//     required VoidCallback deleteOnTap,
//     required VoidCallback editOnTap,
//     required String searchCode,
//     required String content,
//     required String issuedAmount,
//     required String remainingAmount,
//     required String dueDate,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         border: Border.all(color: AppColors.trokeColor),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 8,
//               child: Text(
//                 searchCode,
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7,
//               child: Text(
//                 content,
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7,
//               child: Text(
//                 // issuedAmount,
//                 NumberFormat.decimalPattern().format(int.parse(issuedAmount)),
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7.5,
//               child: Text(
//                 // remainingAmount,
//                 NumberFormat.decimalPattern().format(int.parse(remainingAmount)),
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 7.5,
//               child: Text(
//                 dueDate,
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blackColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7.5,
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: deleteOnTap,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: AppColors.redColor,
//                       ),
//                       child: const Row(
//                         children: [
//                           Text(
//                             'Xóa',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.whiteColor,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(Icons.clear, size: 12, color: AppColors.whiteColor),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   InkWell(
//                     onTap: editOnTap,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: AppColors.primaryColor,
//                       ),
//                       child: Row(
//                         children: [
//                           const Text(
//                             'Sửa',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.whiteColor,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           SvgPicture.asset(IconAssets.editIcon),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Container itemTextWidget() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: const BoxDecoration(
//         color: AppColors.primaryColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(8),
//           topRight: Radius.circular(8),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 8,
//               child: const Text(
//                 'Mã tra cứu',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7,
//               child: const Text(
//                 'Nội dung',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7,
//               child: const Text(
//                 'Số tiền phát hành',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7.5,
//               child: const Text(
//                 'Số tiền phải đóng',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 7.5,
//               child: const Text(
//                 'Hạn đóng',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//             SizedBox(
//               width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 7.5,
//               child: const Text(
//                 'Hành động',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _showAddCreateFeeDialog(BuildContext context, VoidCallback addConfirm) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           title: const Text(
//             'Tạo học phí mới',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//             textAlign: TextAlign.center,
//           ),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 16),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Mã số học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: searchCodeController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(12),
//                       ],
//                       decoration: const InputDecoration(
//                         hintText: 'Nhập mã số học phí',
//                         hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
//                         errorStyle: TextStyle(color: Colors.red),
//                         labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: OutlineInputBorder(),
//                         prefix: SizedBox(width: 12),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Mã số học phí không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Nội dung học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: contentController,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(300),
//                       ],
//                       decoration: const InputDecoration(
//                         hintText: 'Nhập nội dung học phí',
//                         hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
//                         errorStyle: TextStyle(color: Colors.red),
//                         labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: OutlineInputBorder(),
//                         prefix: SizedBox(width: 12),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Nội dung học phí không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Số tiền phát hành ban đầu',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: issuedAmountController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(15),
//                       ],
//                       decoration: const InputDecoration(
//                         hintText: 'Nhập số tiền phát hành ban đầu',
//                         hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
//                         errorStyle: TextStyle(color: Colors.red),
//                         labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: OutlineInputBorder(),
//                         prefix: SizedBox(width: 12),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Số tiền phát hành ban đầu không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Số tiền phải đóng',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: remainingAmountController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(15),
//                       ],
//                       decoration: const InputDecoration(
//                         hintText: 'Nhập số tiền phải đóng',
//                         hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
//                         errorStyle: TextStyle(color: Colors.red),
//                         labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: OutlineInputBorder(),
//                         prefix: SizedBox(width: 12),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Số tiền phải đóng không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Hạn đóng học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () async {
//                         await _selectStartTimeDate(context);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           border: Border.all(color: AppColors.borderColor),
//                         ),
//                         child: Row(
//                           children: [
//                             Obx(() {
//                               return Text(
//                                 selectedStartTimeDate.value != null
//                                     ? DateFormat('dd-MM-yyyy').format(selectedStartTimeDate.value)
//                                     : 'Chưa chọn thời gian',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: selectedStartTimeDate.value != null
//                                       ? AppColors.blackColor
//                                       : AppColors.textDesColor,
//                                 ),
//                               );
//                             }),
//                             const Spacer(),
//                             const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textDesColor, size: 14),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             searchCodeController.clear();
//                             contentController.clear();
//                             issuedAmountController.clear();
//                             remainingAmountController.clear();
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: AppColors.textDesColor),
//                             ),
//                             child: const Text(
//                               'Hủy',
//                               style:
//                                   TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 24),
//                         InkWell(
//                           onTap: () {
//                             if (_formKey.currentState!.validate()) {
//                               addConfirm();
//                               Navigator.of(context).pop();
//                             }
//                           },
//                           child: Container(
//                             width: 99,
//                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: AppColors.primaryColor,
//                             ),
//                             child: const Text(
//                               'Xác nhận',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   _showEditSubFeesDialog(BuildContext context, SubFees subFees, VoidCallback addEditConfirm) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           title: const Text(
//             'Chỉnh sửa học phí',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//             textAlign: TextAlign.center,
//           ),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 16),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Mã số học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: editSearchCodeController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(12),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: subFees.searchCode,
//                         hintStyle: const TextStyle(
//                           color: Color(0xFFB6BBC3),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorStyle: const TextStyle(color: Colors.red),
//                         labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: const OutlineInputBorder(),
//                         prefix: const SizedBox(width: 12),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Mã số học phí không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Nội dung học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: editContentController,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(300),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: subFees.content,
//                         hintStyle: const TextStyle(
//                           color: Color(0xFFB6BBC3),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorStyle: const TextStyle(color: Colors.red),
//                         labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: const OutlineInputBorder(),
//                         prefix: const SizedBox(width: 12),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Nội dung học phí không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Số tiền phát hành ban đầu',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: editIssuedAmountController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(15),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: subFees.issuedAmount.toString(),
//                         hintStyle: const TextStyle(
//                           color: Color(0xFFB6BBC3),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorStyle: const TextStyle(color: Colors.red),
//                         labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: const OutlineInputBorder(),
//                         prefix: const SizedBox(width: 12),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Số tiền phát hành ban đầu không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Số tiền phải đóng',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: editRemainingAmountController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp('[0-9]')),
//                         FilteringTextInputFormatter.deny(' '),
//                         LengthLimitingTextInputFormatter(15),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: subFees.remainingAmount.toString(),
//                         hintStyle: const TextStyle(
//                           color: Color(0xFFB6BBC3),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         errorStyle: const TextStyle(color: Colors.red),
//                         labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//                         border: const OutlineInputBorder(),
//                         prefix: const SizedBox(width: 12),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                         errorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         focusedErrorBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                         focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xFFD2D5DA)),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Số tiền phải đóng không được để trống';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Row(
//                         children: [
//                           Text(
//                             'Hạn đóng học phí',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.textDesColor,
//                             ),
//                           ),
//                           SizedBox(width: 4),
//                           Text('*', style: TextStyle(color: AppColors.redColor)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     InkWell(
//                       onTap: () async {
//                         await _editSelectStartTimeDate(context);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           border: Border.all(color: AppColors.borderColor),
//                         ),
//                         child: Row(
//                           children: [
//                             Obx(() {
//                               return Text(
//                                 editSelectedStartTimeDate.value != null
//                                     ? DateFormat('dd-MM-yyyy').format(editSelectedStartTimeDate.value)
//                                     : 'Chưa chọn thời gian',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: editSelectedStartTimeDate.value != null
//                                       ? AppColors.blackColor
//                                       : AppColors.textDesColor,
//                                 ),
//                               );
//                             }),
//                             const Spacer(),
//                             const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textDesColor, size: 14),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             editSearchCodeController.clear();
//                             editContentController.clear();
//                             editIssuedAmountController.clear();
//                             editRemainingAmountController.clear();
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: AppColors.textDesColor),
//                             ),
//                             child: const Text(
//                               'Hủy',
//                               style:
//                                   TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 24),
//                         InkWell(
//                           onTap: () {
//                             if (_formKey.currentState!.validate()) {
//                               addEditConfirm();
//                               Navigator.of(context).pop();
//                             }
//                           },
//                           child: Container(
//                             width: 160,
//                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: AppColors.primaryColor,
//                             ),
//                             child: const Text(
//                               'Cập nhật chỉnh sửa',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
        );
  }
}
