import 'package:get/get.dart';
import 'profile_controller.dart';
import '../app_state_binding.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    // Đảm bảo AppStateBinding đã được đăng ký
    AppStateBinding().dependencies();
    
    // Đăng ký ProfileController
    Get.put<ProfileController>(ProfileController());
  }
} 