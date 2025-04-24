/// Interface để lưu trữ trạng thái ứng dụng
abstract class AppStateRepository {
  // Video state
  Future<void> saveSelectedVideoId(String? videoId);
  Future<String?> getSelectedVideoId();
  
  // Completed videos
  Future<void> saveCompletedVideoIds(List<String> videoIds);
  Future<List<String>> getCompletedVideoIds();
  Future<void> addCompletedVideoId(String videoId);
  
  // In-progress videos
  Future<void> saveInProgressVideoIds(List<String> videoIds);
  Future<List<String>> getInProgressVideoIds();
  Future<void> addInProgressVideoId(String videoId);
  
  // Video progress
  Future<void> saveVideoProgress(String videoId, double progress);
  Future<double> getVideoProgress(String videoId);
  Future<void> clearVideoProgress();
  
  // App preferences
  Future<void> saveSelectedCategory(String category);
  Future<String> getSelectedCategory();
  Future<void> saveSearchQuery(String query);
  Future<String> getSearchQuery();
  
  // Temporary video for analysis
  Future<void> saveTempVideoPath(String? path);
  Future<String?> getTempVideoPath();
  Future<void> clearTempVideo();
} 