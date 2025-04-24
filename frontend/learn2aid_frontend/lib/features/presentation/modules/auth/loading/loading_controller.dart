import 'dart:async';
import 'package:get/get.dart';
import '../../../../../config/routes/app_routes.dart';

class LoadingController extends GetxController {
  // Biến RxInt lưu vị trí chấm đang “active”.
  final RxInt currentDot = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      currentDot.value = (currentDot.value + 1) % 4;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.login); 
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
