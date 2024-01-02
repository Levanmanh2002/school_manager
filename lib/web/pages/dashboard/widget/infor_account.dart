import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/notifications/notifications.dart';
import 'package:school_web/web/pages/search/search_view.dart';

class InforAccount extends StatelessWidget {
  const InforAccount({
    super.key,
    required this.isClearVisible,
    required this.searchController,
    required this.authController,
  });

  final ValueNotifier<bool> isClearVisible;
  final TextEditingController searchController;
  final AuthenticationController authController;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _buildColumnInforAccount(context);
    } else {
      return _buildRowInforAccount();
    }
  }

  Widget _buildColumnInforAccount(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const NotificationsView(),
                const SizedBox(width: 16),
                Container(
                  height: 56,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFF7F7FC),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                        ),
                        radius: 25,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authController.teacherData.value?.fullName ?? 'EDU Management',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF373743),
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authController.teacherData.value?.system == 1
                                ? 'Admin'
                                : authController.teacherData.value?.system == 2
                                    ? 'Manager'
                                    : authController.teacherData.value?.system == 3
                                        ? 'Teacher'
                                        : authController.teacherData.value?.system == 4
                                            ? 'System'
                                            : 'EDU Management',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7E8695),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_drop_down_outlined, size: 30, color: Color(0xFF7E8695)),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFF7F7FC),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'VN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF373743),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down_outlined, size: 30, color: Color(0xFF7E8695)),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 24),
            // SearchView(
            //   isClearVisible: isClearVisible,
            //   searchController: searchController,
            //   vertical: 24,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInforAccount() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: SearchView(
              isClearVisible: isClearVisible,
              searchController: searchController,
              vertical: 24,
            ),
          ),
          const SizedBox(width: 150),
          const NotificationsView(),
          const SizedBox(width: 16),
          Container(
            height: 56,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFFF7F7FC),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    authController.teacherData.value?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                  ),
                  radius: 25,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      authController.teacherData.value?.fullName ?? 'EDU Management',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF373743),
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authController.teacherData.value?.system == 1
                          ? 'Admin'
                          : authController.teacherData.value?.system == 2
                              ? 'Manager'
                              : authController.teacherData.value?.system == 3
                                  ? 'Teacher'
                                  : authController.teacherData.value?.system == 4
                                      ? 'System'
                                      : 'EDU Management',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7E8695),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_drop_down_outlined, size: 30, color: Color(0xFF7E8695)),
                const SizedBox(width: 12),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFFF7F7FC),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'VN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF373743),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down_outlined, size: 30, color: Color(0xFF7E8695)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
