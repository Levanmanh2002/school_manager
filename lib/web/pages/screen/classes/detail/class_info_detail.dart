import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';

class ClassesInfoDetail extends StatefulWidget {
  const ClassesInfoDetail({required this.students, required this.classes, super.key});

  final List<Students>? students;
  final String classes;

  @override
  State<ClassesInfoDetail> createState() => _ClassesInfoDetailState();
}

class _ClassesInfoDetailState extends State<ClassesInfoDetail> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<bool> isClearVisible = ValueNotifier<bool>(false);

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
    searchController.dispose();
    isClearVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: appTheme.blackColor),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Lớp: ${widget.classes}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.clear, color: appTheme.blackColor),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.students != null && widget.students!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text('Danh sách học sinh', style: StyleThemeData.styleSize16Weight600())),
                  const SizedBox(width: 24),
                  Flexible(
                    child: ValueListenableBuilder<bool>(
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
                                  onPressed: () {
                                    searchController.clear();
                                    isClearVisible.value = false;
                                  },
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
                          fillColor: appTheme.primary50Color,
                          showBorder: BorderSide(color: appTheme.primary50Color),
                          onChanged: (query) {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (widget.students != null && widget.students!.isNotEmpty) const SizedBox(height: 24),
            Expanded(
              child: (widget.students != null && widget.students!.isNotEmpty)
                  ? Responsive.isMobile(context)
                      ? itemViewMobile()
                      : itemViewWidget()
                  : Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          SvgPicture.asset(IconAssets.noStudentIcon, width: 110, height: 110),
                          const SizedBox(height: 12),
                          Text('Lớp học chưa có học sinh', style: StyleThemeData.styleSize14Weight400()),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemViewMobile() {
    return ListView.builder(
      itemCount: widget.students?.length ?? 0,
      itemBuilder: (context, index) {
        final student = widget.students![index];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            color: appTheme.whiteColor,
            child: ListTile(
              leading: ClipRRect(
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
              title: Text(
                student.fullName ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: appTheme.blackColor,
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
      },
    );
  }

  Column itemViewWidget() {
    return Column(
      children: [
        titleTabWidget(
          name: 'Họ và tên',
          code: 'MSSV',
          industry: 'Ngành nghề',
          email: 'Email',
          phone: 'Số điện thoại',
          status: 'Trạng thái',
          colorStatus: appTheme.textDesColor,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.students?.length ?? 0,
            itemBuilder: (context, index) {
              final student = widget.students![index];
              return titleTabWidget(
                name: student.fullName ?? '',
                code: student.mssv ?? '',
                industry: student.major?.name ?? '',
                email: student.gmail ?? '',
                phone: student.phone ?? '',
                status: student.status == 1
                    ? 'Đang học'
                    : student.status == 2
                        ? 'Nghỉ học'
                        : student.status == 3
                            ? 'Đình chỉ'
                            : student.status == 4
                                ? 'Bị đuổi học'
                                : '',
                colorStatus: student.status == 1
                    ? appTheme.successColor
                    : student.status == 2
                        ? appTheme.yellow500Color
                        : student.status == 3
                            ? appTheme.neutral40Color
                            : student.status == 4
                                ? appTheme.errorColor
                                : appTheme.successColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget titleTabWidget({
    required String name,
    required String code,
    required String industry,
    required String email,
    required String phone,
    required String status,
    required Color colorStatus,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 200),
                width: 200,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTheme.textDesColor,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 100),
                width: 100,
                child: Text(
                  code,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTheme.textDesColor,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 110),
                width: 110,
                child: Text(
                  industry,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTheme.textDesColor,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 200),
                width: 200,
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTheme.textDesColor,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 100),
                width: 100,
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTheme.textDesColor,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                // constraints: const BoxConstraints(maxWidth: 110),
                width: 110,
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: colorStatus,
                    height: 1.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 0),
          ),
        ],
      ),
    );
  }
}
