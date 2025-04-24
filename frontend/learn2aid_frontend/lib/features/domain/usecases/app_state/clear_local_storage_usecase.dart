import '../../repositories/app_state_repository.dart';

/// Use case để xóa toàn bộ dữ liệu được lưu trong local storage
class ClearLocalStorageUseCase {
  final AppStateRepository repository;

  ClearLocalStorageUseCase(this.repository);

  // Xóa tất cả dữ liệu đã lưu trữ
  Future<void> execute() async {
    // Xóa danh sách video đã hoàn thành
    await repository.saveCompletedVideoIds([]);
    
    // Xóa danh sách video đang xem
    await repository.saveInProgressVideoIds([]);
    
    // Xóa tiến trình xem video
    // (Chức năng này không có trong interface, cần thêm vào)
    await repository.clearVideoProgress();
    
    // Xóa video tạm
    await repository.clearTempVideo();
    
    // Đặt lại các giá trị mặc định
    await repository.saveSelectedCategory('all');
    await repository.saveSearchQuery('');
    await repository.saveSelectedVideoId(null);
  }
} 