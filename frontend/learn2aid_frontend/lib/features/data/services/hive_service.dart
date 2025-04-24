import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Enum cho các loại box trong Hive
enum HiveBoxes {
  appState,
  videoState,
  completedVideos,
  inProgressVideos,
  videoProgress
}

// Các khóa được sử dụng trong các box của Hive
class HiveKeys {
  // Keys cho AppState box
  static const String selectedCategory = 'selectedCategory';
  static const String searchQuery = 'searchQuery';
  
  // Keys cho VideoState box
  static const String selectedVideoId = 'selectedVideoId';
  static const String tempVideoPath = 'tempVideoPath';
}

class HiveService {
  static final HiveService _instance = HiveService._internal();
  
  // Singleton pattern
  factory HiveService() {
    return _instance;
  }
  
  HiveService._internal();
  
  // Khởi tạo Hive
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Mở các box
    await Hive.openBox<dynamic>(HiveBoxes.appState.toString());
    await Hive.openBox<dynamic>(HiveBoxes.videoState.toString());
    await Hive.openBox<String>(HiveBoxes.completedVideos.toString());
    await Hive.openBox<String>(HiveBoxes.inProgressVideos.toString());
    await Hive.openBox<double>(HiveBoxes.videoProgress.toString());
  }
  
  // Getter cho các box
  Box<dynamic> get appStateBox => Hive.box<dynamic>(HiveBoxes.appState.toString());
  Box<dynamic> get videoStateBox => Hive.box<dynamic>(HiveBoxes.videoState.toString());
  Box<String> get completedVideosBox => Hive.box<String>(HiveBoxes.completedVideos.toString());
  Box<String> get inProgressVideosBox => Hive.box<String>(HiveBoxes.inProgressVideos.toString());
  Box<double> get videoProgressBox => Hive.box<double>(HiveBoxes.videoProgress.toString());
  
  // Lưu danh sách ID video đã hoàn thành
  Future<void> saveCompletedVideoIds(List<String> videoIds) async {
    await completedVideosBox.clear();
    for (var id in videoIds) {
      await completedVideosBox.add(id);
    }
  }
  
  // Lấy danh sách ID video đã hoàn thành
  List<String> getCompletedVideoIds() {
    return completedVideosBox.values.toList();
  }
  
  // Thêm ID video vào danh sách đã hoàn thành
  Future<void> addCompletedVideoId(String videoId) async {
    if (!completedVideosBox.values.contains(videoId)) {
      await completedVideosBox.add(videoId);
    }
  }
  
  // Lưu danh sách ID video đang xem dở
  Future<void> saveInProgressVideoIds(List<String> videoIds) async {
    await inProgressVideosBox.clear();
    for (var id in videoIds) {
      await inProgressVideosBox.add(id);
    }
  }
  
  // Lấy danh sách ID video đang xem dở
  List<String> getInProgressVideoIds() {
    return inProgressVideosBox.values.toList();
  }
  
  // Thêm ID video vào danh sách đang xem dở
  Future<void> addInProgressVideoId(String videoId) async {
    if (!inProgressVideosBox.values.contains(videoId)) {
      await inProgressVideosBox.add(videoId);
    }
  }
  
  // Lưu tiến trình xem video
  Future<void> saveVideoProgress(String videoId, double progress) async {
    await videoProgressBox.put(videoId, progress);
  }
  
  // Lấy tiến trình xem video
  double getVideoProgress(String videoId) {
    return videoProgressBox.get(videoId) ?? 0.0;
  }
  
  // Lưu thông tin danh mục đang chọn
  Future<void> saveSelectedCategory(String category) async {
    await appStateBox.put(HiveKeys.selectedCategory, category);
  }
  
  // Lấy thông tin danh mục đang chọn
  String getSelectedCategory() {
    return appStateBox.get(HiveKeys.selectedCategory, defaultValue: 'all');
  }
  
  // Lưu truy vấn tìm kiếm
  Future<void> saveSearchQuery(String query) async {
    await appStateBox.put(HiveKeys.searchQuery, query);
  }
  
  // Lấy truy vấn tìm kiếm
  String getSearchQuery() {
    return appStateBox.get(HiveKeys.searchQuery, defaultValue: '');
  }
  
  // Lưu ID video đang được chọn
  Future<void> saveSelectedVideoId(String? videoId) async {
    await videoStateBox.put(HiveKeys.selectedVideoId, videoId);
  }
  
  // Lấy ID video đang được chọn
  String? getSelectedVideoId() {
    return videoStateBox.get(HiveKeys.selectedVideoId);
  }
  
  // Lưu đường dẫn video tạm thời (dùng cho phân tích video)
  Future<void> saveTempVideoPath(String? path) async {
    await videoStateBox.put(HiveKeys.tempVideoPath, path);
  }
  
  // Lấy đường dẫn video tạm thời
  String? getTempVideoPath() {
    return videoStateBox.get(HiveKeys.tempVideoPath);
  }
  
  // Xóa video tạm thời
  Future<void> clearTempVideo() async {
    final path = getTempVideoPath();
    if (path != null) {
      // Xóa file từ thiết bị
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      // Xóa đường dẫn từ Hive
      await videoStateBox.delete(HiveKeys.tempVideoPath);
    }
  }
} 