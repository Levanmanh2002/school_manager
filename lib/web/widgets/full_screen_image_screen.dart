import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/component_library/generator_util.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';

class FullScreenImageScreen extends StatefulWidget {
  const FullScreenImageScreen({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  bool isDownloading = false;
  final authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    Future<void> saveImage(String imageUrl, {double pixelRatio = 10}) async {
      setState(() {
        isDownloading = true;
      });

      final file = await GeneratorUtils.takePictureFromUrl(imageUrl, pixelRatio: pixelRatio);
      if (file != null) {
        await GeneratorUtils.saveNetworkImage(file.path);
      }

      setState(() {
        isDownloading = false;
      });

      Get.snackbar(
        "Thành công",
        "Đã tải thành công",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    void onButtonTap() {
      saveImage(widget.imageUrl);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          GestureDetector(
            onTap: onButtonTap,
            child: isDownloading
                ? Center(
                    child: Container(
                        padding: const EdgeInsets.only(right: 16),
                        child: const CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF6B58F8))),
                  )
                : const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.file_download_outlined, size: 24, color: Colors.black),
                  ),
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: RepaintBoundary(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
