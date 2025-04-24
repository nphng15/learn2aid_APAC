import 'package:get/get.dart';
import '../../../../data/models/video_model.dart';
import '../../../../data/services/video_service.dart';
import '../../dashboard/controllers/video_controller.dart';
import 'package:flutter/material.dart';

class LessonController extends GetxController {
  final VideoService _videoService = VideoService();
  late final VideoController _videoController;
  
  final RxBool isLoading = false.obs;
  final RxString currentTab = 'content'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _videoController = Get.find<VideoController>();
    
    // Đăng ký currentTab với tag để có thể truy cập từ các controller khác
    Get.put<Rx<String>>(currentTab, tag: 'currentTab');
  }
  
  // Hàm gọi khi tab thay đổi
  void onTabChanged(String tab) {
    // Chỉ cập nhật nếu thực sự có thay đổi
    if (currentTab.value != tab) {
      print('DEBUG - LessonController: Tab thay đổi từ ${currentTab.value} sang $tab');
      currentTab.value = tab;
    }
  }
  
  //cập nhật tiến trình xem video
  void updateVideoProgress(String videoId, double progress) {
    _videoController.updateVideoProgress(videoId, progress);
  }
  
  //đánh dấu video đã hoàn thành
  void markVideoAsCompleted(String videoId) {
    _videoController.updateVideoProgress(videoId, 1.0);
  }
  
  //đánh dấu video đã hoàn thành dựa trên điểm số
  void markVideoAsCompletedWithScore(String videoId, double score) {
    // Debug
    print('DEBUG - markVideoAsCompletedWithScore');
    print('DEBUG - Video ID: $videoId');
    print('DEBUG - Score: $score');
    
    // Kiểm tra ID hợp lệ
    if (videoId.isEmpty) {
      print('DEBUG - ERROR: videoId rỗng');
      Get.snackbar(
        'Lỗi',
        'Không thể đánh dấu video hoàn thành: ID không hợp lệ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Cập nhật tiến trình xem video thành 100%
    _videoController.updateVideoProgress(videoId, 1.0);
    
    // Nếu điểm > 80, đánh dấu video đã hoàn thành 
    if (score > 80) {
      print('DEBUG - Đánh dấu video hoàn thành với điểm: $score');
      _videoController.markVideoAsCompleted(videoId);
      
      // Thêm debug thông báo
      print('DEBUG - Đã gọi markVideoAsCompleted()');
    } else {
      print('DEBUG - Không đánh dấu hoàn thành vì điểm dưới 80: $score');
    }
  }
  
  //lấy video tiếp theo cùng danh mục
  Future<VideoModel?> getNextVideoInCategory(String currentVideoId, String category) async {
    isLoading.value = true;
    try {
      final videos = await _videoService.getVideosByCategory(category);
      isLoading.value = false;
      
      // Tìm vị trí của video hiện tại
      final currentIndex = videos.indexWhere((video) => video.id == currentVideoId);
      if (currentIndex != -1 && currentIndex < videos.length - 1) {
        // Trả về video tiếp theo nếu có
        return videos[currentIndex + 1];
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }
} 