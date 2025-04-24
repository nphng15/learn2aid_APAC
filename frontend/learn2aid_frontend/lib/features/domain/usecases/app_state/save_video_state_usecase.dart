import '../../repositories/app_state_repository.dart';

/// Use case để lưu trạng thái video vào repository
class SaveVideoStateUseCase {
  final AppStateRepository repository;

  SaveVideoStateUseCase(this.repository);

  // Lưu ID video đang được chọn
  Future<void> saveSelectedVideoId(String? videoId) {
    return repository.saveSelectedVideoId(videoId);
  }
  
  // Lưu danh sách ID video đã hoàn thành
  Future<void> saveCompletedVideoIds(List<String> videoIds) {
    return repository.saveCompletedVideoIds(videoIds);
  }
  
  // Thêm ID video vào danh sách đã hoàn thành
  Future<void> addCompletedVideoId(String videoId) {
    return repository.addCompletedVideoId(videoId);
  }
  
  // Lưu danh sách ID video đang xem dở
  Future<void> saveInProgressVideoIds(List<String> videoIds) {
    return repository.saveInProgressVideoIds(videoIds);
  }
  
  // Thêm ID video vào danh sách đang xem dở
  Future<void> addInProgressVideoId(String videoId) {
    return repository.addInProgressVideoId(videoId);
  }
  
  // Lưu tiến trình xem video
  Future<void> saveVideoProgress(String videoId, double progress) {
    return repository.saveVideoProgress(videoId, progress);
  }
  
  // Lưu thông tin danh mục đang chọn
  Future<void> saveSelectedCategory(String category) {
    return repository.saveSelectedCategory(category);
  }
  
  // Lưu truy vấn tìm kiếm
  Future<void> saveSearchQuery(String query) {
    return repository.saveSearchQuery(query);
  }
  
  // Lưu đường dẫn video tạm thời
  Future<void> saveTempVideoPath(String? path) {
    return repository.saveTempVideoPath(path);
  }
  
  // Xóa video tạm thời
  Future<void> clearTempVideo() {
    return repository.clearTempVideo();
  }
} 