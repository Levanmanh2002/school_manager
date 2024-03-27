import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/models/other_payment.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class OtherPaymentPages extends StatefulWidget {
  const OtherPaymentPages({super.key});

  @override
  State<OtherPaymentPages> createState() => _OtherPaymentPagesState();
}

class _OtherPaymentPagesState extends State<OtherPaymentPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationController authController = Get.put(AuthenticationController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editDescriptionController = TextEditingController();
  final TextEditingController editAddressController = TextEditingController();
  final TextEditingController editPriceController = TextEditingController();

  void addConfirm() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/expense'));
    request.body = json.encode({
      "name": nameController.text,
      "description": descriptionController.text,
      "address": addressController.text,
      "price": priceController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      Get.snackbar(
        "Thành công",
        "Tạo khoản thu thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Lỗi",
        "Lỗi tạo khoản thu thất bại.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  Future<List<OtherPayment>> fetchData() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/get_all_expenses'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<OtherPayment> majors = data.map((e) => OtherPayment.fromJson(e)).toList();

      return majors;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<dynamic> onDeleteOtherPayment(String id) async {
    var request =
        http.Request('DELETE', Uri.parse('https://backend-shool-project.onrender.com/admin/delete_expense/$id'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {});
      Get.snackbar(
        "Thành công",
        "Khoản thu đã được xóa!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print(await response.stream.bytesToString());
    } else {
      Get.snackbar(
        "Thất bại",
        "Lỗi xóa khoản thu!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  Future<void> onUpdateOtherPayment(String id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PUT', Uri.parse('https://backend-shool-project.onrender.com/admin/update_expense/$id'));

    request.body = json.encode({
      "name": editNameController.text,
      "description": editDescriptionController.text,
      "address": editAddressController.text,
      "price": editPriceController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      Get.snackbar(
        "Thành công",
        "Chỉnh sửa khoản thu thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      editNameController.clear();
      editDescriptionController.clear();
      editAddressController.clear();
      editPriceController.clear();
    } else {
      Get.snackbar(
        "Lỗi",
        "Chỉnh sửa khoản thu thất bại.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    priceController.dispose();
    editNameController.dispose();
    editDescriptionController.dispose();
    editAddressController.dispose();
    editPriceController.dispose();
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
                  const Text(
                    'Các khoản thu khác',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      if (authController.teacherData.value?.system == 1 ||
                          authController.teacherData.value?.system == 2) {
                        _showAddOtherPaymentDialog(context, addConfirm);
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.primaryColor),
                      child: const Text(
                        'Thêm khoản thu',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<OtherPayment>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Wrap(
                      spacing: 12,
                      runSpacing: Responsive.isMobile(context) ? 12 : 32,
                      children: List.generate(snapshot.data!.length, (index) {
                        final expense = snapshot.data![index];

                        return CardOtherPayment(
                          onTap: () {
                            if (authController.teacherData.value?.system == 1 ||
                                authController.teacherData.value?.system == 2 ||
                                authController.teacherData.value?.system == 3) {
                              _showAddEditOtherPaymentDialog(context, onUpdateOtherPayment, expense);
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
                          clearOntap: () {
                            if (authController.teacherData.value?.system == 1 ||
                                authController.teacherData.value?.system == 2) {
                              _showDeleteOtherPaymentDialog(context, expense, onDeleteOtherPayment);
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
                          title: expense.name ?? '',
                          des: expense.description ?? '',
                          address: expense.address ?? '',
                          price: expense.price.toString(),
                        );
                      }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAddOtherPaymentDialog(BuildContext context, dynamic addConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Tạo khoản thu mới',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Tên khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên khoản thu',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tên khoản thu không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Mô tả khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Mô tả khoản thu',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mô tả khoản thu không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Nơi nhận',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: addressController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Nhập nơi nhận',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nơi nhận không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Giá khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: priceController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      FilteringTextInputFormatter.deny(' '),
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Nhập giá khoản thu',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Giá khoản thu không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: AppColors.textDesColor),
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            addConfirm();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor,
                          ),
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showAddEditOtherPaymentDialog(BuildContext context, dynamic addConfirm, OtherPayment otherPayment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Chỉnh sửa khoản thu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Tên khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editNameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: InputDecoration(
                      hintText: otherPayment.name,
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập tên khoản thu mới';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Mô tả khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editDescriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: otherPayment.description,
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập mô tả khoản thu mới';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Nơi nhận',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editAddressController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: otherPayment.address,
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập nơi nhận khoản thu mới';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Giá khoản thu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textDesColor,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text('*', style: TextStyle(color: AppColors.redColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editPriceController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      FilteringTextInputFormatter.deny(' '),
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: InputDecoration(
                      hintText: '${otherPayment.price.toString()}đ',
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy nhập giá khoản thu mới';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: AppColors.textDesColor),
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            addConfirm(otherPayment.sId);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor,
                          ),
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteOtherPaymentDialog(
      BuildContext context, OtherPayment otherPayment, dynamic onDeleteMajors) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            "Xác nhận xóa ngành học",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
          content: Row(
            children: [
              const Text(
                "Bạn có chắc chắn muốn xóa khoản thu",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
              ),
              const SizedBox(width: 4),
              Text(
                "${otherPayment.name}?",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDesColor),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
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
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                onDeleteMajors(otherPayment.sId);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardOtherPayment extends StatelessWidget {
  const CardOtherPayment({
    super.key,
    this.image = '',
    required this.title,
    required this.des,
    required this.address,
    required this.price,
    required this.onTap,
    required this.clearOntap,
  });

  final String image;
  final String title;
  final String des;
  final String address;
  final String price;
  final VoidCallback onTap;
  final VoidCallback clearOntap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: Responsive.isMobile(context) ? 160 : 311,
            padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
                  child: Image.network(
                    image.isNotEmpty
                        ? image
                        : 'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                    width: Responsive.isMobile(context) ? 64 : 170,
                    height: Responsive.isMobile(context) ? 64 : 170,
                  ),
                ),
                SizedBox(height: Responsive.isMobile(context) ? 12 : 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    des,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      address,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.blackColor),
                      maxLines: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'Giá: $priceđ',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                      maxLines: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: clearOntap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textDesColor,
                ),
                child: const Icon(Icons.clear, size: 16, color: AppColors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
