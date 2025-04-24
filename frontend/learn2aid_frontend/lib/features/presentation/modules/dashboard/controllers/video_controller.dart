import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/video_model.dart';
import '../../../../data/services/video_service.dart';
import '../../../../domain/usecases/app_state/get_video_state_usecase.dart';
import '../../../../domain/usecases/app_state/save_video_state_usecase.dart';

class VideoController extends GetxController {
  final VideoService _videoService = VideoService();
  final GetVideoStateUseCase _getVideoStateUseCase = Get.find<GetVideoStateUseCase>();
  final SaveVideoStateUseCase _saveVideoStateUseCase = Get.find<SaveVideoStateUseCase>();
  
  // Video lists
  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final RxList<VideoModel> forYouVideos = <VideoModel>[].obs;
  final RxList<VideoModel> inProgressVideos = <VideoModel>[].obs;
  final RxList<VideoModel> completedVideos = <VideoModel>[].obs;
  
  // Selected video
  final Rx<VideoModel?> selectedVideo = Rx<VideoModel?>(null);
  
  // Video watch status
  final RxMap<String, double> videoProgress = <String, double>{}.obs;
  
  // Status
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxString searchQuery = ''.obs;
  
  // FocusNode to manage search bar focus
  final FocusNode searchFocusNode = FocusNode();
  
  // List of in-progress video IDs (using Hive)
  final RxList<String> inProgressVideoIds = <String>[].obs;
  
  // List of completed video IDs (using Hive)
  final RxList<String> completedVideoIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Restore state
    _loadState();
    
    // Load video list
    loadVideos();
  }
  
  // Load state
  Future<void> _loadState() async {
    try {
      // Restore selected category
      // selectedCategory.value = await _getVideoStateUseCase.getSelectedCategory();
      
      // Restore search query
      // searchQuery.value = await _getVideoStateUseCase.getSearchQuery();
      
      // Restore completed video list
      completedVideoIds.value = await _getVideoStateUseCase.getCompletedVideoIds();
      
      // Restore in-progress video list
      inProgressVideoIds.value = await _getVideoStateUseCase.getInProgressVideoIds();
      
      print('DEBUG - State loaded');
      print('DEBUG - Category: ${selectedCategory.value}');
      print('DEBUG - Completed videos: ${completedVideoIds.length}');
      print('DEBUG - In-progress videos: ${inProgressVideoIds.length}');
    } catch (e) {
      print('DEBUG - Error loading state: $e');
    }
  }
  
  @override
  void onClose() {
    // Save state
    _saveState();
    
    // Release FocusNode when controller is destroyed
    searchFocusNode.dispose();
    super.onClose();
  }
  
  // Save state
  Future<void> _saveState() async {
    try {
      // Save selected category
      await _saveVideoStateUseCase.saveSelectedCategory(selectedCategory.value);
      
      // Save search query
      await _saveVideoStateUseCase.saveSearchQuery(searchQuery.value);
      
      // Save completed video list
      await _saveVideoStateUseCase.saveCompletedVideoIds(completedVideoIds);
      
      // Save in-progress video list
      await _saveVideoStateUseCase.saveInProgressVideoIds(inProgressVideoIds);
      
      print('DEBUG - State saved');
    } catch (e) {
      print('DEBUG - Error saving state: $e');
    }
  }
  
  Future<void> loadVideos() async {
    isLoading.value = true;
    try {
      if (selectedCategory.value == 'all') {
        videos.value = await _videoService.getAllVideos();
      } else {
        videos.value = await _videoService.getVideosByCategory(selectedCategory.value);
      }
      
      // Update video lists by type
      updateVideoLists();
      
      // Restore selected video if exists
      final selectedVideoId = await _getVideoStateUseCase.getSelectedVideoId();
      if (selectedVideoId != null) {
        final video = videos.firstWhereOrNull((v) => v.id == selectedVideoId);
        if (video != null) {
          selectedVideo.value = video;
          print('DEBUG - Selected video restored: ${video.title}');
        }
      }
    } catch (e) {
      print('Error loading videos: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update video lists based on search and filter
  void updateVideoLists() async {
    try {
      // Load video progress
      videoProgress.clear();
      for (final video in videos) {
        final progress = await _getVideoStateUseCase.getVideoProgress(video.id);
        if (progress > 0) {
          videoProgress[video.id] = progress;
        }
      }
      
      // Update "For you" list - remove completed videos
      forYouVideos.value = videos.where((video) {
        // Search in video title
        final searchMatch = searchQuery.isEmpty || 
                            video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        // Check if video is completed
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Only show uncompleted videos
        return searchMatch && !isCompleted;
      }).toList();
      
      // Update "In progress" list - videos being watched
      inProgressVideos.value = videos.where((video) {
        // Check if video is in progress
        final isInProgress = inProgressVideoIds.contains(video.id);
        
        // Search in video title
        final searchMatch = searchQuery.isEmpty || 
                             video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        // Check if video is completed
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Only get in-progress and uncompleted videos
        return isInProgress && !isCompleted && searchMatch;
      }).toList();
      
      // Update completed video list
      completedVideos.value = videos.where((video) {
        // Check if video is completed
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Search in video title
        final searchMatch = searchQuery.isEmpty || 
                             video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        return isCompleted && searchMatch;
      }).toList();
    } catch (e) {
      print('Error updating video lists: $e');
    }
  }
  
  // Change selected category
  void changeCategory(String category) {
    selectedCategory.value = category;
    loadVideos();
    
    // Remove focus from search bar
    searchFocusNode.unfocus();
  }
  
  // Search videos by name
  void searchVideos(String query) {
    searchQuery.value = query;
    updateVideoLists();
  }
  
  // Add video to in-progress list
  void addToInProgress(String videoId) {
    if (!inProgressVideoIds.contains(videoId)) {
      inProgressVideoIds.add(videoId);
      _saveVideoStateUseCase.addInProgressVideoId(videoId);
      updateVideoLists();
    }
  }
  
  // Set selected video
  void setSelectedVideo(VideoModel video) {
    selectedVideo.value = video;
    _saveVideoStateUseCase.saveSelectedVideoId(video.id);
    // Add to in-progress list
    addToInProgress(video.id);
  }
  
  // Update video watch progress
  void updateVideoProgress(String videoId, double progress) {
    videoProgress[videoId] = progress;
    _saveVideoStateUseCase.saveVideoProgress(videoId, progress);
  }
  
  // Get video watch progress
  Future<double> getVideoProgressAsync(String videoId) async {
    return _getVideoStateUseCase.getVideoProgress(videoId);
  }
  
  // Get video watch progress (synchronous version)
  double getVideoProgress(String videoId) {
    return videoProgress[videoId] ?? 0.0;
  }
  
  // Mark video as completed
  void markVideoAsCompleted(String videoId) {
    try {
      print('DEBUG - VideoController.markVideoAsCompleted()');
      print('DEBUG - Video ID: $videoId');
      
      // Check valid ID
      if (videoId.isEmpty) {
        print('DEBUG - ERROR: Empty videoId');
        Get.snackbar(
          'Error',
          'Could not mark video as completed: Invalid ID',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      // Add video ID to completed list
      if (!completedVideoIds.contains(videoId)) {
        completedVideoIds.add(videoId);
        _saveVideoStateUseCase.addCompletedVideoId(videoId);
        print('DEBUG - Added to completedVideoIds: $videoId');
        print('DEBUG - CompletedVideoIds list: $completedVideoIds');
      } else {
        print('DEBUG - Video already exists in completedVideoIds: $videoId');
      }
      
      // Update video model if selected - safer handling
      try {
        if (selectedVideo.value?.id == videoId) {
          final updatedVideo = selectedVideo.value?.copyWith(completed: true);
          if (updatedVideo != null) {
            selectedVideo.value = updatedVideo;
            print('DEBUG - Updated selectedVideo.completed = true');
          } else {
            print('DEBUG - selectedVideo.copyWith returned null');
          }
        }
      } catch (e) {
        print('DEBUG - Error updating selectedVideo: $e');
      }
      
      // Update in videos list - safer handling
      try {
        final index = videos.indexWhere((v) => v.id == videoId);
        if (index != -1) {
          final updatedVideo = videos[index].copyWith(completed: true);
          videos[index] = updatedVideo;
          print('DEBUG - Updated video in videos list');
        }
      } catch (e) {
        print('DEBUG - Error updating videos list: $e');
      }
      
      // Update video lists
      updateVideoLists();
      
      // Show success message
      Get.snackbar(
        'Success',
        'Video marked as completed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('DEBUG - ERROR marking video as completed: $e');
      Get.snackbar(
        'Error',
        'Could not mark video as completed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add openVideo method if not exists
  void openVideo(String videoUrl, String videoId) async {
    try {
      // Update video being watched
      addToInProgress(videoId);
      
      // Use url_launcher to open video
      final Uri url = Uri.parse(videoUrl);
      final bool canLaunch = await canLaunchUrl(url);
      
      if (canLaunch) {
        // Show snackbar notification
        Get.snackbar(
          'Opening video',
          'Video is being opened in the application...',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open video. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Check if video ID exists in video list
  bool hasVideoWithId(String videoId) {
    final exists = videos.any((video) => video.id == videoId);
    print('DEBUG - Check video ID $videoId in video list: ${exists ? 'YES' : 'NO'}');
    return exists;
  }

  // Add test video for debugging
  void addTestVideo() {
    final newVideo = VideoModel(
      id: 'test_video_1',
      title: 'Test Video',
      description: 'Video for testing completion marking',
      videoUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://example.com/thumbnail.jpg',
      category: 'Test',
      duration: 120,
      uploadedBy: 'admin',
      uploaderName: 'Admin',
    );
    
    // Add to video list
    videos.add(newVideo);
    
    // Update lists
    updateVideoLists();
    
    // In output
    print('DEBUG - Added test video: ${newVideo.id}');
    print('DEBUG - Video list length: ${videos.length}');
  }
} 