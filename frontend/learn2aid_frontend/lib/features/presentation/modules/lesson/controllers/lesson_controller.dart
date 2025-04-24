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
    
    // Register currentTab with tag to access from other controllers
    Get.put<Rx<String>>(currentTab, tag: 'currentTab');
  }
  
  // Function called when tab changes
  void onTabChanged(String tab) {
    // Only update if there's actually a change
    if (currentTab.value != tab) {
      print('DEBUG - LessonController: Tab changed from ${currentTab.value} to $tab');
      currentTab.value = tab;
    }
  }
  
  // Update video watching progress
  void updateVideoProgress(String videoId, double progress) {
    _videoController.updateVideoProgress(videoId, progress);
  }
  
  // Mark video as completed
  void markVideoAsCompleted(String videoId) {
    _videoController.updateVideoProgress(videoId, 1.0);
  }
  
  // Mark video as completed based on score
  void markVideoAsCompletedWithScore(String videoId, double score) {
    // Debug
    print('DEBUG - markVideoAsCompletedWithScore');
    print('DEBUG - Video ID: $videoId');
    print('DEBUG - Score: $score');
    
    // Check if ID is valid
    if (videoId.isEmpty) {
      print('DEBUG - ERROR: empty videoId');
      Get.snackbar(
        'Error',
        'Cannot mark video as completed: Invalid ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Update video progress to 100%
    _videoController.updateVideoProgress(videoId, 1.0);
    
    // If score > 80, mark video as completed
    if (score > 80) {
      print('DEBUG - Marking video as completed with score: $score');
      _videoController.markVideoAsCompleted(videoId);
      
      // Add debug notification
      print('DEBUG - Called markVideoAsCompleted()');
    } else {
      print('DEBUG - Not marking as completed because score is below 80: $score');
    }
  }
  
  // Get next video in same category
  Future<VideoModel?> getNextVideoInCategory(String currentVideoId, String category) async {
    isLoading.value = true;
    try {
      final videos = await _videoService.getVideosByCategory(category);
      isLoading.value = false;
      
      // Find position of current video
      final currentIndex = videos.indexWhere((video) => video.id == currentVideoId);
      if (currentIndex != -1 && currentIndex < videos.length - 1) {
        // Return next video if available
        return videos[currentIndex + 1];
      }
      return null;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }
} 