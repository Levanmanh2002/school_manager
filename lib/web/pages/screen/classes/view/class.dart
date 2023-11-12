import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';

class ClassView extends StatefulWidget {
  const ClassView({super.key});

  @override
  State<ClassView> createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _createClassController = TextEditingController();
  final _updatedClassController = TextEditingController();
  final isLoading = false.obs;

  Future<List<Classes>> _getClassInfo() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/classes'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['classes'];

      List<Classes> classes = data.map((e) => Classes.fromJson(e)).toList();

      return classes;
    } else {
      throw Exception('Failed to load classes info');
    }
  }

  Future<void> _addClass() async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/create-class'));
      request.body = json.encode({"className": _createClassController.text});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học mới đã được tạo",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _createClassController.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Thất bại",
          "Lớp học đã tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Create class + $e');
    }

    isLoading(false);
  }

  Future<void> _editClass(String id) async {
    try {
      isLoading(true);
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/edit-class/${id}'),
      );
      request.body = json.encode({
        "updatedClassName": _updatedClassController.text,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học đã được chỉnh sửa",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _updatedClassController.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Edit class + $e');
    }

    isLoading(false);
  }

  Future<void> _deleteClass(String id) async {
    isLoading(true);

    try {
      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/admin/delete-class/${id}'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học đã được xóa",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Delete class + $e');
    }

    isLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    _createClassController.dispose();
    _updatedClassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: Colors.black)),
            const Text(
              'Thông tin lớp học',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Classes>>(
        future: _getClassInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có lớp học.'));
          } else {
            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Danh sách lớp học: ${snapshot.data?.length}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final classes = snapshot.data![index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 1,
                              color: Colors.white,
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Lớp: ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: classes.className.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                editClasses(context, classes);
                                              },
                                              icon: const Icon(Icons.edit, color: Colors.black),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text('Xác nhận xóa?'),
                                                      content: const Text('Bạn có chắc chắn muốn xóa lớp học này?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            _deleteClass(classes.id.toString());
                                                          },
                                                          child: const Text(
                                                            'Xác nhận',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
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
                  addClasses(context);
                },
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.pink,
                  ),
                  child: const Text(
                    'Thêm lớp học',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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

  void editClasses(BuildContext context, Classes classes) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'Chỉnh sửa thông tin lớp học',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidgets(
                  controller: _updatedClassController,
                  title: classes.className.toString(),
                  validator: true,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _editClass(classes.id.toString());
                        }
                      },
                      child: isLoading.value
                          ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              width: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue,
                              ),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void addClasses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'Thêm một lớp học mới',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidgets(
                  controller: _createClassController,
                  title: 'Tên lớp học',
                  validator: true,
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      width: MediaQuery.of(context).size.width / 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _addClass();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue,
                        ),
                        child: isLoading.value
                            ? const Center(
                                child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white),
                              ))
                            : const Text(
                                'Xác nhận',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
