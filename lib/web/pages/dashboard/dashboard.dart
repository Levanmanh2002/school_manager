import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final AuthenticationController authController = Get.put(AuthenticationController());
  bool isExpanded = true;
  final controller = SideBarController();

  @override
  void initState() {
    super.initState();
    authController.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          icon: const Icon(Icons.menu, color: Colors.black),
        ),
        title: const Text(
          'SCHOOL MANAGER',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageScreen(
                          imageUrl:
                              authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                    ),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(10, 50, 0, 0),
                      items: [
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            controller.index.value = 11;
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.account_circle, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Hồ sơ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          onTap: () {
                            authController.logout();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.exit_to_app, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        authController.teacherData.value?.fullName ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down_outlined, size: 20, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
      body: Row(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              child: IntrinsicHeight(
                child: NavigationRail(
                  extended: Responsive.isMobile(context)
                      ? false
                      : Responsive.isTablet(context)
                          ? false
                          : isExpanded,
                  selectedIconTheme: const IconThemeData(color: Colors.pink),
                  selectedLabelTextStyle:
                      const TextStyle(color: Colors.pink, fontSize: 16, fontWeight: FontWeight.w600),
                  unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
                  unselectedLabelTextStyle: TextStyle(color: Colors.grey[400]),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Trang chủ'),
                      // selectedIcon: Icon(Icons.favorite, color: Colors.green),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment_ind_rounded),
                      label: Text('Thêm giáo viên mới'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_add),
                      label: Text('Thêm học sinh mới'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.assignment_outlined),
                      label: Text('Danh sách giáo viên'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.local_library),
                      label: Text('Danh sách học sinh'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_stories_rounded),
                      label: Text('Danh sách các ngành học'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_tree_outlined),
                      label: Text('Danh sách lớp học'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.group_add),
                      label: Text('Thêm học sinh vào lớp học'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_business_outlined),
                      label: Text('Thêm giáo viên vào lớp học'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insert_invitation_outlined),
                      label: Text('Tạo thời khóa biểu'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.autorenew_rounded),
                      label: Text('Học sinh chuyển lớp'),
                    ),
                  ],
                  selectedIndex: controller.index.value,
                  onDestinationSelected: (index) {
                    setState(() {
                      controller.index.value = index;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Obx(
              () => controller.pageRoutes[controller.index.value],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Colors.pink.shade400,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
