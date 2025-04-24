import 'package:get/get.dart';
import '../../domain/repositories/app_state_repository.dart';
import '../../domain/usecases/app_state/get_video_state_usecase.dart';
import '../../domain/usecases/app_state/save_video_state_usecase.dart';
import '../../domain/usecases/app_state/clear_local_storage_usecase.dart';

class AppStateBinding implements Bindings {
  @override
  void dependencies() {
    // Đăng ký các use case sử dụng repository đã được đăng ký trong main.dart
    Get.lazyPut<GetVideoStateUseCase>(
      () => GetVideoStateUseCase(Get.find<AppStateRepository>()),
      fenix: true,
    );
    
    Get.lazyPut<SaveVideoStateUseCase>(
      () => SaveVideoStateUseCase(Get.find<AppStateRepository>()),
      fenix: true,
    );
    
    Get.lazyPut<ClearLocalStorageUseCase>(
      () => ClearLocalStorageUseCase(Get.find<AppStateRepository>()),
      fenix: true,
    );
  }
} 