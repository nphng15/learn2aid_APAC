import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../features/data/models/video_model.dart';
import '../controllers/lesson_controller.dart';

class LessonInteractive extends StatefulWidget {
  const LessonInteractive({super.key});

  @override
  State<LessonInteractive> createState() => _LessonInteractiveState();
}

class _LessonInteractiveState extends State<LessonInteractive> {
  late final LessonController _lessonController;
  late final VideoModel _video;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _lessonController = Get.find<LessonController>();
    
    // Lấy thông tin video từ arguments hoặc từ controller
    _video = Get.arguments?['video'];
    
    if (_video == null) {
      Get.back();
      return;
    }
    
    // Xử lý hiển thị UI
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    
    // Thực hiện mở video trong trình duyệt
    _openVideoInBrowser();
  }
  
  Future<void> _openVideoInBrowser() async {
    if (_video.videoUrl.isNotEmpty) {
      try {
        final Uri url = Uri.parse(_video.videoUrl);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        Get.snackbar(
          'Lỗi',
          'Không thể mở video. Hãy thử lại sau.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem video: ${_video.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hiển thị thông báo
                        const Icon(
                          Icons.ondemand_video,
                          size: 80,
                          color: Color(0xff215273),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Video đang được phát trong trình duyệt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Nút mở lại video
                        ElevatedButton.icon(
                          onPressed: _openVideoInBrowser,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Mở lại video'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff215273),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Quay lại bài học'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff55c595),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
} 