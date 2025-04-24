import 'dart:io';
import '../../domain/repositories/app_state_repository.dart';
import '../datasources/local/hive_storage_adapter.dart';

/// Triển khai cụ thể của AppStateRepository sử dụng Hive
class AppStateRepositoryImpl implements AppStateRepository {
  final HiveStorageAdapter _hiveStorage;
  
  AppStateRepositoryImpl({HiveStorageAdapter? hiveStorage}) 
      : _hiveStorage = hiveStorage ?? HiveStorageAdapter();
  
  // Video state
  @override
  Future<void> saveSelectedVideoId(String? videoId) async {
    await _hiveStorage.saveValue(
      HiveKeys.selectedVideoId, 
      videoId, 
      _hiveStorage.videoStateBox
    );
  }
  
  @override
  Future<String?> getSelectedVideoId() async {
    return _hiveStorage.getValue(
      HiveKeys.selectedVideoId, 
      _hiveStorage.videoStateBox
    );
  }
  
  // Completed videos
  @override
  Future<void> saveCompletedVideoIds(List<String> videoIds) async {
    await _hiveStorage.saveList(videoIds, _hiveStorage.completedVideosBox);
  }
  
  @override
  Future<List<String>> getCompletedVideoIds() async {
    return _hiveStorage.getList(_hiveStorage.completedVideosBox);
  }
  
  @override
  Future<void> addCompletedVideoId(String videoId) async {
    await _hiveStorage.addToList(videoId, _hiveStorage.completedVideosBox);
  }
  
  // In-progress videos
  @override
  Future<void> saveInProgressVideoIds(List<String> videoIds) async {
    await _hiveStorage.saveList(videoIds, _hiveStorage.inProgressVideosBox);
  }
  
  @override
  Future<List<String>> getInProgressVideoIds() async {
    return _hiveStorage.getList(_hiveStorage.inProgressVideosBox);
  }
  
  @override
  Future<void> addInProgressVideoId(String videoId) async {
    await _hiveStorage.addToList(videoId, _hiveStorage.inProgressVideosBox);
  }
  
  // Video progress
  @override
  Future<void> saveVideoProgress(String videoId, double progress) async {
    await _hiveStorage.videoProgressBox.put(videoId, progress);
  }
  
  @override
  Future<double> getVideoProgress(String videoId) async {
    return _hiveStorage.videoProgressBox.get(videoId) ?? 0.0;
  }
  
  @override
  Future<void> clearVideoProgress() async {
    await _hiveStorage.videoProgressBox.clear();
  }
  
  // App preferences
  @override
  Future<void> saveSelectedCategory(String category) async {
    await _hiveStorage.saveValue(
      HiveKeys.selectedCategory, 
      category, 
      _hiveStorage.appStateBox
    );
  }
  
  @override
  Future<String> getSelectedCategory() async {
    return _hiveStorage.getValue(
      HiveKeys.selectedCategory, 
      _hiveStorage.appStateBox,
      defaultValue: 'all'
    );
  }
  
  @override
  Future<void> saveSearchQuery(String query) async {
    await _hiveStorage.saveValue(
      HiveKeys.searchQuery, 
      query, 
      _hiveStorage.appStateBox
    );
  }
  
  @override
  Future<String> getSearchQuery() async {
    return _hiveStorage.getValue(
      HiveKeys.searchQuery, 
      _hiveStorage.appStateBox,
      defaultValue: ''
    );
  }
  
  // Temporary video for analysis
  @override
  Future<void> saveTempVideoPath(String? path) async {
    await _hiveStorage.saveValue(
      HiveKeys.tempVideoPath, 
      path, 
      _hiveStorage.videoStateBox
    );
  }
  
  @override
  Future<String?> getTempVideoPath() async {
    return _hiveStorage.getValue(
      HiveKeys.tempVideoPath, 
      _hiveStorage.videoStateBox
    );
  }
  
  @override
  Future<void> clearTempVideo() async {
    final path = await getTempVideoPath();
    await _hiveStorage.deleteFile(path);
    await _hiveStorage.videoStateBox.delete(HiveKeys.tempVideoPath);
  }
} 