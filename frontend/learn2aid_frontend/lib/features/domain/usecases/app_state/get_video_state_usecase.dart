import '../../repositories/app_state_repository.dart';

/// Use case để lấy trạng thái video từ repository
class GetVideoStateUseCase {
  final AppStateRepository repository;

  GetVideoStateUseCase(this.repository);

  // Lấy ID video đang được chọn
  Future<String?> getSelectedVideoId() {
    return repository.getSelectedVideoId();
  }
  
  // Lấy danh sách ID video đã hoàn thành
  Future<List<String>> getCompletedVideoIds() {
    return repository.getCompletedVideoIds();
  }
  
  // Lấy danh sách ID video đang xem dở
  Future<List<String>> getInProgressVideoIds() {
    return repository.getInProgressVideoIds();
  }
  
  // Lấy tiến trình xem video
  Future<double> getVideoProgress(String videoId) {
    return repository.getVideoProgress(videoId);
  }
  
  // Lấy thông tin danh mục đang chọn
  Future<String> getSelectedCategory() {
    return repository.getSelectedCategory();
  }
  
  // Lấy truy vấn tìm kiếm
  Future<String> getSearchQuery() {
    return repository.getSearchQuery();
  }
  
  // Lấy đường dẫn video tạm thời
  Future<String?> getTempVideoPath() {
    return repository.getTempVideoPath();
  }
} 