import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/list_data/list_data_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_student_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_teacher_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';

class ListDataTabletWidget extends StatefulWidget {
  const ListDataTabletWidget({super.key});

  @override
  State<ListDataTabletWidget> createState() => _ListDataTabletWidgetState();
}

class _ListDataTabletWidgetState extends State<ListDataTabletWidget> with TickerProviderStateMixin {
  late TabController _tabListController;
  final searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

  ValueNotifier<String> selectedValueNotifier = ValueNotifier<String>('Tất cả');

  final ListDataController listDataController = Get.put(ListDataController());

  @override
  void initState() {
    super.initState();
    _tabListController = TabController(length: 2, vsync: this);
    searchController.addListener(() {
      isClearVisible.value = searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabListController.dispose();
    searchController.dispose();
    isClearVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFFFFFFF),
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
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Danh sách',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF373743),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isClearVisible,
                        builder: (context, isVisible, child) {
                          return TextFormField(
                            controller: searchController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
                              LengthLimitingTextInputFormatter(25),
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              fillColor: const Color(0xFFF7F7FC),
                              filled: true,
                              hintText: 'Tìm kiếm',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7E8695),
                              ),
                              prefixIcon: Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 12),
                                  child: SvgPicture.asset('assets/icons/search.svg', width: 20, height: 20),
                                ),
                              ),
                              suffix: isVisible
                                  ? InkWell(
                                      onTap: () {
                                        searchController.clear();
                                        isClearVisible.value = false;
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF7E8695),
                                          ),
                                          child: const Icon(Icons.clear_rounded, color: Colors.white, size: 12),
                                        ),
                                      ),
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(41),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(41),
                                borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(41),
                                borderSide: const BorderSide(color: Color(0xFFF7F7FC)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // PopupMenuButton(
                    //   position: PopupMenuPosition.under,
                    //   padding: EdgeInsets.zero,
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //   onSelected: (value) {
                    //     selectedValueNotifier.value = value.toString();

                    //     // setState(() {
                    //     //   selectedValue = value.toString();
                    //     // });
                    //   },
                    //   itemBuilder: (context) => [
                    //     _buildPopupMenuItemView(text: 'Tất cả', color: const Color(0xFF7E8695)),
                    //     _buildPopupMenuItemView(text: 'Học sinh mới', color: const Color(0xFF2D9CDB)),
                    //     _buildPopupMenuItemView(text: 'Đang học', color: const Color(0xFF3BB53B)),
                    //     _buildPopupMenuItemView(text: 'Nghỉ học', color: const Color(0xFFFC8805)),
                    //     _buildPopupMenuItemView(text: 'Đình chỉ', color: const Color(0xFF9AA0AC)),
                    //     _buildPopupMenuItemView(text: 'Bị đuổi học', color: const Color(0xFFFC423F)),
                    //   ],
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(48),
                    //       color: const Color(0xFFF7F7FC),
                    //     ),
                    //     child: ValueListenableBuilder(
                    //       valueListenable: selectedValueNotifier,
                    //       builder: (context, selectedValue, _) {
                    //         return Row(
                    //           children: [
                    //             Text(
                    //               selectedValue,
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w400,
                    //                 color: getColorForValue(getValueForText(selectedValue)),
                    //                 height: 1.2,
                    //               ),
                    //             ),
                    //             const SizedBox(width: 8),
                    //             Icon(
                    //               Icons.keyboard_arrow_down_outlined,
                    //               color: getColorForValue(getValueForText(selectedValue)),
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  constraints: const BoxConstraints.expand(height: 48),
                  child: TabBar(
                    controller: _tabListController,
                    isScrollable: true,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    labelColor: const Color(0xFF3A73C2),
                    unselectedLabelColor: const Color(0xFF7E8695),
                    indicatorColor: const Color(0xFF3A73C2),
                    indicatorWeight: 1,
                    tabs: const [
                      Tab(text: 'Học sinh'),
                      Tab(text: 'Giáo viên'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxHeight: 649),
                  child: TabBarView(
                    controller: _tabListController,
                    children: [
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: Responsive.isTablet(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width / 1.26,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                titleTabWidget(
                                  name: 'Họ và tên',
                                  code: 'MSSV',
                                  industry: 'Ngành nghề',
                                  email: 'Email',
                                  phone: 'Số điện thoại',
                                  status: 'Trạng thái',
                                  detail: 'Chi tiết',
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: listDataController.allStudents.length,
                                    itemBuilder: (context, index) {
                                      final student = listDataController.allStudents[index];
                                      return tableInfoStudentWidget(student, context);
                                    },
                                  ),
                                ),
                                // itemPaginationWidget(),
                                InkWell(
                                  onTap: () {
                                    if (listDataController.isLoadingStudent.isFalse) {
                                      listDataController.loadMoreStudentData();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (listDataController.isLoadingStudent.isTrue)
                                          const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(),
                                          ),
                                        if (listDataController.isLoadingStudent.isTrue) const SizedBox(width: 8),
                                        const Text(
                                          'Xem thêm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF3A73C2),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (listDataController.isLoadingStudent.isFalse)
                                          const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Color(0xFF3A73C2),
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
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: Responsive.isTablet(context)
                                ? MediaQuery.of(context).size.width
                                : MediaQuery.of(context).size.width / 1.26,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                titleTabWidget(
                                  name: 'Họ và tên',
                                  code: 'MSGV',
                                  industry: 'Học vấn',
                                  email: 'Email',
                                  phone: 'Số điện thoại',
                                  status: 'Trạng thái',
                                  detail: 'Chi tiết',
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: listDataController.allTeacher.length,
                                    itemBuilder: (context, index) {
                                      final teacher = listDataController.allTeacher[index];
                                      return tableInfoTeacherWidget(teacher, context);
                                    },
                                  ),
                                ),
                                // itemPaginationWidget(),
                                InkWell(
                                  onTap: () {
                                    if (listDataController.isLoadingTeacher.isFalse) {
                                      listDataController.loadMoreTeacherData();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (listDataController.isLoadingTeacher.isTrue)
                                          const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(),
                                          ),
                                        if (listDataController.isLoadingTeacher.isTrue) const SizedBox(width: 8),
                                        const Text(
                                          'Xem thêm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF3A73C2),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (listDataController.isLoadingTeacher.isFalse)
                                          const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Color(0xFF3A73C2),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getColorForValue(int value) {
    switch (value) {
      case 1:
        return const Color(0xFF2D9CDB);
      case 2:
        return const Color(0xFF3BB53B);
      case 3:
        return const Color(0xFFFC8805);
      case 4:
        return const Color(0xFF9AA0AC);
      case 5:
        return const Color(0xFFFC423F);
      default:
        return const Color(0xFF7E8695);
    }
  }

  int getValueForText(String text) {
    switch (text) {
      case 'Học sinh mới':
        return 1;
      case 'Đang học':
        return 2;
      case 'Nghỉ học':
        return 3;
      case 'Đình chỉ':
        return 4;
      case 'Bị đuổi học':
        return 5;
      default:
        return 0;
    }
  }
}

PopupMenuItem<dynamic> _buildPopupMenuItemView({required String text, required Color color}) {
  return PopupMenuItem(
    value: text,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
