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
  
  // Danh sách video
  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final RxList<VideoModel> forYouVideos = <VideoModel>[].obs;
  final RxList<VideoModel> inProgressVideos = <VideoModel>[].obs;
  final RxList<VideoModel> completedVideos = <VideoModel>[].obs;
  
  // Video đang được chọn
  final Rx<VideoModel?> selectedVideo = Rx<VideoModel?>(null);
  
  // Trạng thái xem video
  final RxMap<String, double> videoProgress = <String, double>{}.obs;
  
  // Trạng thái
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxString searchQuery = ''.obs;
  
  // FocusNode để quản lý focus của thanh tìm kiếm
  final FocusNode searchFocusNode = FocusNode();
  
  // Danh sách ID video đang xem dở (sử dụng Hive)
  final RxList<String> inProgressVideoIds = <String>[].obs;
  
  // Danh sách ID video đã hoàn thành (sử dụng Hive)
  final RxList<String> completedVideoIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Khôi phục trạng thái
    _loadState();
    
    // Tải danh sách video
    loadVideos();
  }
  
  // Tải trạng thái
  Future<void> _loadState() async {
    try {
      // Khôi phục danh mục đã chọn
      // selectedCategory.value = await _getVideoStateUseCase.getSelectedCategory();
      
      // Khôi phục truy vấn tìm kiếm
      // searchQuery.value = await _getVideoStateUseCase.getSearchQuery();
      
      // Khôi phục danh sách video đã hoàn thành
      completedVideoIds.value = await _getVideoStateUseCase.getCompletedVideoIds();
      
      // Khôi phục danh sách video đang xem dở
      inProgressVideoIds.value = await _getVideoStateUseCase.getInProgressVideoIds();
      
      print('DEBUG - Đã tải trạng thái');
      print('DEBUG - Danh mục: ${selectedCategory.value}');
      print('DEBUG - Video hoàn thành: ${completedVideoIds.length}');
      print('DEBUG - Video đang xem: ${inProgressVideoIds.length}');
    } catch (e) {
      print('DEBUG - Lỗi khi tải trạng thái: $e');
    }
  }
  
  @override
  void onClose() {
    // Lưu trạng thái
    _saveState();
    
    // Giải phóng FocusNode khi controller bị hủy
    searchFocusNode.dispose();
    super.onClose();
  }
  
  // Lưu trạng thái
  Future<void> _saveState() async {
    try {
      // Lưu danh mục đã chọn
      // await _saveVideoStateUseCase.saveSelectedCategory(selectedCategory.value);
      
      // Lưu truy vấn tìm kiếm
      // await _saveVideoStateUseCase.saveSearchQuery(searchQuery.value);
      
      // Lưu danh sách video đã hoàn thành
      await _saveVideoStateUseCase.saveCompletedVideoIds(completedVideoIds);
      
      // Lưu danh sách video đang xem dở
      await _saveVideoStateUseCase.saveInProgressVideoIds(inProgressVideoIds);
      
      // Lưu ID video đang được chọn
      // await _saveVideoStateUseCase.saveSelectedVideoId(selectedVideo.value?.id);
      
      // Lưu tiến trình xem video
      for (final entry in videoProgress.entries) {
        await _saveVideoStateUseCase.saveVideoProgress(entry.key, entry.value);
      }
      
      print('DEBUG - Đã lưu trạng thái');
    } catch (e) {
      print('DEBUG - Lỗi khi lưu trạng thái: $e');
    }
  }
  
  // Tải danh sách video
  Future<void> loadVideos() async {
    isLoading.value = true;
    try {
      if (selectedCategory.value == 'all') {
        videos.value = await _videoService.getAllVideos();
      } else {
        videos.value = await _videoService.getVideosByCategory(selectedCategory.value);
      }
      
      // Cập nhật danh sách video theo loại
      updateVideoLists();
      
      // Khôi phục video đang được chọn nếu có
      final selectedVideoId = await _getVideoStateUseCase.getSelectedVideoId();
      if (selectedVideoId != null) {
        final video = videos.firstWhereOrNull((v) => v.id == selectedVideoId);
        if (video != null) {
          selectedVideo.value = video;
          print('DEBUG - Đã khôi phục video đang được chọn: ${video.title}');
        }
      }
    } catch (e) {
      print('Error loading videos: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cập nhật các danh sách video dựa trên tìm kiếm và bộ lọc
  void updateVideoLists() async {
    try {
      // Tải tiến trình video
      videoProgress.clear();
      for (final video in videos) {
        final progress = await _getVideoStateUseCase.getVideoProgress(video.id);
        if (progress > 0) {
          videoProgress[video.id] = progress;
        }
      }
      
      // Cập nhật danh sách "For you" - loại bỏ video đã hoàn thành
      forYouVideos.value = videos.where((video) {
        // Tìm kiếm trong tiêu đề video
        final searchMatch = searchQuery.isEmpty || 
                            video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        // Kiểm tra video có đã hoàn thành không
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Chỉ hiển thị video chưa hoàn thành
        return searchMatch && !isCompleted;
      }).toList();
      
      // Cập nhật danh sách "In progress" - video đang xem dở
      inProgressVideos.value = videos.where((video) {
        // Kiểm tra video có trong danh sách đang xem dở không
        final isInProgress = inProgressVideoIds.contains(video.id);
        
        // Tìm kiếm trong tiêu đề video
        final searchMatch = searchQuery.isEmpty || 
                             video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        // Kiểm tra video có đã hoàn thành không
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Chỉ lấy video đang xem dở và chưa hoàn thành
        return isInProgress && !isCompleted && searchMatch;
      }).toList();
      
      // Cập nhật danh sách video đã hoàn thành
      completedVideos.value = videos.where((video) {
        // Kiểm tra video đã hoàn thành chưa (dựa trên trường completed hoặc ID có trong danh sách)
        final isCompleted = video.completed || completedVideoIds.contains(video.id);
        
        // Tìm kiếm trong tiêu đề video
        final searchMatch = searchQuery.isEmpty || 
                             video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        final result = isCompleted && searchMatch;
        if (isCompleted) {
          print('DEBUG - Video đã hoàn thành: ${video.id} (${video.title})');
        }
        
        return result;
      }).toList();
      
      print('DEBUG - Số video đã hoàn thành: ${completedVideos.length}');
      print('DEBUG - Số video đang xem dở: ${inProgressVideos.length}');
      print('DEBUG - Số video trong For You: ${forYouVideos.length}');
      
      // Lưu trạng thái
      _saveState();
    } catch (e) {
      print('DEBUG - LỖI khi cập nhật danh sách video: $e');
    }
  }

  // Thay đổi danh mục được chọn
  void changeCategory(String category) {
    selectedCategory.value = category;
    loadVideos();
    
    // Xóa focus khỏi thanh tìm kiếm
    searchFocusNode.unfocus();
  }
  
  // Tìm kiếm video theo tên
  void searchVideos(String query) {
    searchQuery.value = query;
    updateVideoLists();
  }
  
  // Thêm video vào danh sách đang xem dở
  void addToInProgress(String videoId) {
    if (!inProgressVideoIds.contains(videoId)) {
      inProgressVideoIds.add(videoId);
      _saveVideoStateUseCase.addInProgressVideoId(videoId);
      updateVideoLists();
    }
  }
  
  // Đặt video đang được chọn
  void setSelectedVideo(VideoModel video) {
    selectedVideo.value = video;
    _saveVideoStateUseCase.saveSelectedVideoId(video.id);
    // Thêm vào danh sách đang xem dở
    addToInProgress(video.id);
  }
  
  // Cập nhật tiến trình xem video
  void updateVideoProgress(String videoId, double progress) {
    videoProgress[videoId] = progress;
    _saveVideoStateUseCase.saveVideoProgress(videoId, progress);
  }
  
  // Lấy tiến trình xem của video
  Future<double> getVideoProgressAsync(String videoId) async {
    return _getVideoStateUseCase.getVideoProgress(videoId);
  }
  
  // Lấy tiến trình xem của video (phiên bản đồng bộ)
  double getVideoProgress(String videoId) {
    return videoProgress[videoId] ?? 0.0;
  }
  
  // Đánh dấu video đã hoàn thành
  void markVideoAsCompleted(String videoId) {
    try {
      print('DEBUG - VideoController.markVideoAsCompleted()');
      print('DEBUG - Video ID: $videoId');
      
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
      
      // Thêm ID video vào danh sách đã hoàn thành
      if (!completedVideoIds.contains(videoId)) {
        completedVideoIds.add(videoId);
        _saveVideoStateUseCase.addCompletedVideoId(videoId);
        print('DEBUG - Đã thêm vào completedVideoIds: $videoId');
        print('DEBUG - Danh sách completedVideoIds: $completedVideoIds');
      } else {
        print('DEBUG - Video đã tồn tại trong completedVideoIds: $videoId');
      }
      
      // Cập nhật mô hình video nếu đang được chọn - xử lý an toàn hơn
      try {
        if (selectedVideo.value?.id == videoId) {
          final updatedVideo = selectedVideo.value?.copyWith(completed: true);
          if (updatedVideo != null) {
            selectedVideo.value = updatedVideo;
            print('DEBUG - Đã cập nhật selectedVideo.completed = true');
          } else {
            print('DEBUG - selectedVideo.copyWith trả về null');
          }
        }
      } catch (e) {
        print('DEBUG - Lỗi khi cập nhật selectedVideo: $e');
      }
      
      // Cập nhật trong danh sách videos - xử lý an toàn hơn
      try {
        final index = videos.indexWhere((v) => v.id == videoId);
        if (index >= 0) {
          final updatedVideo = videos[index].copyWith(completed: true);
          if (updatedVideo != null) {
            videos[index] = updatedVideo;
            print('DEBUG - Đã cập nhật video trong danh sách videos index: $index');
          } else {
            print('DEBUG - videos[index].copyWith trả về null');
            // Thử phương pháp thay thế nếu copyWith không hoạt động
            final originalVideo = videos[index];
            final newVideo = VideoModel(
              id: originalVideo.id,
              title: originalVideo.title,
              description: originalVideo.description,
              videoUrl: originalVideo.videoUrl,
              thumbnailUrl: originalVideo.thumbnailUrl,
              category: originalVideo.category,
              duration: originalVideo.duration,
              uploadedBy: originalVideo.uploadedBy,
              uploaderName: originalVideo.uploaderName,
              completed: true,
            );
            videos[index] = newVideo;
            print('DEBUG - Đã cập nhật video bằng phương pháp thay thế');
          }
        } else {
          print('DEBUG - Không tìm thấy video trong danh sách videos: $videoId');
        }
      } catch (e) {
        print('DEBUG - Lỗi khi cập nhật video trong danh sách: $e');
      }
      
      // Cập nhật các danh sách
      updateVideoLists();
      print('DEBUG - Đã cập nhật các danh sách video');
      print('DEBUG - completedVideos.length: ${completedVideos.length}');
      
      // Hiển thị thông báo thành công
      Get.snackbar(
        'Thành công',
        'Video đã được đánh dấu hoàn thành',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('DEBUG - LỖI khi đánh dấu video hoàn thành: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể đánh dấu video hoàn thành: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Thêm phương thức openVideo nếu chưa tồn tại
  void openVideo(String videoUrl, String videoId) async {
    try {
      // Cập nhật video đang xem
      addToInProgress(videoId);
      
      // Sử dụng url_launcher để mở video
      final Uri url = Uri.parse(videoUrl);
      final bool canLaunch = await canLaunchUrl(url);
      
      if (canLaunch) {
        // Hiển thị snackbar thông báo mở video
        Get.snackbar(
          'Đang mở video',
          'Video đang được mở trong ứng dụng...',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Lỗi',
          'Không thể mở video. Vui lòng thử lại sau.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Kiểm tra xem video ID có trong danh sách videos không
  bool hasVideoWithId(String videoId) {
    final exists = videos.any((video) => video.id == videoId);
    print('DEBUG - Kiểm tra video ID $videoId trong danh sách videos: ${exists ? 'CÓ' : 'KHÔNG'}');
    return exists;
  }

  // Thêm video thử nghiệm để debug
  void addTestVideo() {
    final newVideo = VideoModel(
      id: 'test_video_1',
      title: 'Video Thử Nghiệm',
      description: 'Video để kiểm tra chức năng đánh dấu hoàn thành',
      videoUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://example.com/thumbnail.jpg',
      category: 'Thử nghiệm',
      duration: 120,
      uploadedBy: 'admin',
      uploaderName: 'Admin',
    );
    
    // Thêm vào danh sách videos
    videos.add(newVideo);
    
    // Cập nhật danh sách
    updateVideoLists();
    
    // In thông tin
    print('DEBUG - Đã thêm video thử nghiệm: ${newVideo.id}');
    print('DEBUG - Danh sách videos length: ${videos.length}');
  }
} 