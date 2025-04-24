import 'package:get/get.dart';
import '../auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/app_state/clear_local_storage_usecase.dart';
import '../../../domain/repositories/app_state_repository.dart';

class ProfileController extends GetxController {
  final LoginController loginController = Get.find<LoginController>();
  
  // Lazy getter cho ClearLocalStorageUseCase, khởi tạo khi cần
  ClearLocalStorageUseCase get _clearLocalStorageUseCase {
    if (!Get.isRegistered<ClearLocalStorageUseCase>()) {
      final repository = Get.find<AppStateRepository>();
      return ClearLocalStorageUseCase(repository);
    }
    return Get.find<ClearLocalStorageUseCase>();
  }

  // Observable variables cho thông tin profile
  var userEmail = ''.obs;
  var userName = ''.obs;
  var userPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Lấy thông tin từ LoginController
    userEmail.value = loginController.googleUserEmail.value;
    userName.value = loginController.googleUserName.value;
    userPhotoUrl.value = loginController.googleUserPhotoUrl.value;
  }

  Future<void> logout() async {
    await loginController.logout();
  }
  
  // Xóa dữ liệu local
  Future<void> clearLocalData() async {
    try {
      await _clearLocalStorageUseCase.execute();
      
      Get.snackbar(
        'Thành công',
        'Đã xóa tất cả dữ liệu lưu trữ cục bộ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('DEBUG - Lỗi khi xóa dữ liệu local: $e');
      
      Get.snackbar(
        'Lỗi',
        'Không thể xóa dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 