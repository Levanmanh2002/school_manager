import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/other/other_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/status/status.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';
import 'package:school_web/web/widgets/show_loading_dialog.dart';

class OtherPaymentPages extends StatefulWidget {
  const OtherPaymentPages({super.key});

  @override
  State<OtherPaymentPages> createState() => _OtherPaymentPagesState();
}

class _OtherPaymentPagesState extends State<OtherPaymentPages> {
  final AuthController authController = Get.put(AuthController());
  final OtherController otherController = Get.put(OtherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: Responsive.isMobile(context) ? 16 : 32),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Các khoản thu khác',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context)
                        ? 2
                        : Responsive.isTablet(context)
                            ? 3
                            : 5,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: otherController.otherList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () {
                          if (authController.teacherData.value?.system == 1 ||
                              authController.teacherData.value?.system == 2) {
                            showAddOther(context);
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
                        child: BoxShadowWidget(
                          radius: 24,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(IconAssets.addIcon),
                                const SizedBox(height: 24),
                                Flexible(
                                  child: Text(
                                    'Thêm khoản thu',
                                    style: StyleThemeData.styleSize14Weight400(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      final other = otherController.otherList[index - 1];

                      return GestureDetector(
                        onLongPressStart: (delete) {
                          if (authController.teacherData.value?.system == 1 ||
                              authController.teacherData.value?.system == 2) {
                            showNoSystemWidget(
                              context,
                              title: 'Xác nhận xóa khoản thu?',
                              des: 'Bạn có chắc chắn muốn xóa và không thể khôi phục?',
                              cancel: 'Đóng',
                              confirm: 'Đồng ý',
                              ontap: () async {
                                Get.back();

                                showLoadingDialog(context, (p0) async {
                                  await otherController.deleteUniform(other.sId ?? '');
                                });
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
                        child: BoxShadowWidget(
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage(other.image ?? ''),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(other.name ?? '', style: StyleThemeData.styleSize14Weight600()),
                                    Text(
                                      '${other.quantity ?? ''}₫',
                                      style: StyleThemeData.styleSize14Weight600(color: appTheme.appColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAddOther(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final moneyController = TextEditingController();
    final quantityController = TextEditingController();
    final noteController = TextEditingController();

    final ValueNotifier<File?> pickedImageNotifier = ValueNotifier<File?>(null);

    final ImagePicker imagePicker = ImagePicker();
    Future<void> imageFromGallery() async {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImageNotifier.value = File(image.path);
      }
    }

    clear() {
      nameController.clear();
      moneyController.clear();
      quantityController.clear();
      noteController.clear();
      pickedImageNotifier.value?.delete();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Thêm khoản thu mới',
                        style: StyleThemeData.styleSize16Weight800(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomTextWidgets(
                        controller: nameController,
                        title: 'Tên khoản thu',
                        hintText: 'Nhập tên khoản thu',
                        validator: true,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 16),
                      CustomTextWidgets(
                        controller: moneyController,
                        title: 'Giá',
                        hintText: 'Nhập giá',
                        keyboardType: TextInputType.phone,
                        validator: true,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 16),
                      CustomTextWidgets(
                        controller: quantityController,
                        title: 'Số lượng',
                        hintText: 'Nhập số lượng',
                        keyboardType: TextInputType.phone,
                        validator: true,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 16),
                      CustomTextWidgets(
                        controller: noteController,
                        title: 'Ghi chú khoản thu',
                        hintText: 'Nhập ghi chú khoản thu',
                        validator: true,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Hình ảnh',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: appTheme.textDesColor),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => imageFromGallery(),
                          child: ValueListenableBuilder<File?>(
                              valueListenable: pickedImageNotifier,
                              builder: (context, pickedImage, _) {
                                return pickedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 100,
                                          height: 120,
                                          child: Image.network(
                                            pickedImage.path,
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 120,
                                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: appTheme.backgroundContainer,
                                        ),
                                        child: SvgPicture.asset(IconAssets.addIcon, width: 24, height: 24),
                                      );
                              }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: appTheme.textDesColor),
                              ),
                              child: Text(
                                'Hủy',
                                style: StyleThemeData.styleSize16Weight600(color: appTheme.textDesColor, height: 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (pickedImageNotifier.value != null) {
                                  Get.back();

                                  showLoadingDialog(context, (p0) async {
                                    await otherController.addUniform(
                                      name: nameController.text,
                                      money: moneyController.text,
                                      quantity: quantityController.text,
                                      note: noteController.text,
                                      blobUrl: pickedImageNotifier.value!.path.toString(),
                                    );
                                  });
                                } else {
                                  showErrorStatus('Hãy chọn ít nhất 1 hình ảnh');
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: appTheme.appColor,
                              ),
                              child: Text(
                                'Xác nhận',
                                style: StyleThemeData.styleSize16Weight600(color: appTheme.whiteColor, height: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
