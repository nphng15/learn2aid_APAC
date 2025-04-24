import 'package:get/get.dart';
import '../../profile/profile_controller.dart';
import '../../app_state_binding.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    // Đảm bảo AppStateBinding đã được đăng ký
    AppStateBinding().dependencies();
    
    // Inject ProfileController trực tiếp
    Get.put<ProfileController>(ProfileController());
  }
}
