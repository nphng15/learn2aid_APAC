import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entities/video_analysis.dart';
import '../../../../domain/usecases/analyze_video_usecase.dart';
import '../../../../domain/usecases/save_analysis_result_usecase.dart';
import '../../../../domain/usecases/app_state/get_video_state_usecase.dart';
import '../../../../domain/usecases/app_state/save_video_state_usecase.dart';

class VideoAnalysisController extends GetxController {
  // Dependencies
  final AnalyzeVideoUseCase _analyzeVideoUseCase;
  final SaveAnalysisResultUseCase _saveAnalysisResultUseCase;
  final GetVideoStateUseCase _getVideoStateUseCase = Get.find<GetVideoStateUseCase>();
  final SaveVideoStateUseCase _saveVideoStateUseCase = Get.find<SaveVideoStateUseCase>();
  final ImagePicker _picker = ImagePicker();
  
  VideoAnalysisController({
    AnalyzeVideoUseCase? analyzeVideoUseCase,
    SaveAnalysisResultUseCase? saveAnalysisResultUseCase,
  }) : _analyzeVideoUseCase = analyzeVideoUseCase ?? Get.find<AnalyzeVideoUseCase>(),
       _saveAnalysisResultUseCase = saveAnalysisResultUseCase ?? Get.find<SaveAnalysisResultUseCase>();
  
  // State variables
  final Rx<File?> videoFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<VideoAnalysis?> analysisResult = Rx<VideoAnalysis?>(null);
  final RxString selectedMovementType = 'cpr'.obs; 
  
  @override
  void onInit() {
    super.onInit();
    
    // Khôi phục video từ storage nếu có
    _loadVideo();
    
    // Lắng nghe sự kiện tab change
    ever(Get.find<Rx<String>>(tag: 'currentTab'), _onTabChanged);
  }
  
  // Xử lý sự kiện khi tab thay đổi
  void _onTabChanged(String tabName) {
    print('DEBUG - Tab thay đổi sang: $tabName');
    if (tabName == 'content') {
      resetAll();
    }
  }
  
  // Khôi phục video
  Future<void> _loadVideo() async {
    try {
      final videoPath = await _getVideoStateUseCase.getTempVideoPath();
      if (videoPath != null) {
        final file = File(videoPath);
        if (file.existsSync()) {
          videoFile.value = file;
          print('DEBUG - Đã khôi phục video: $videoPath');
        } else {
          print('DEBUG - File video không tồn tại: $videoPath');
          _saveVideoStateUseCase.clearTempVideo();
        }
      }
    } catch (e) {
      print('DEBUG - Lỗi khi tải video: $e');
    }
  }
  
  // Chọn video từ thư viện
  Future<void> pickVideoFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (pickedFile != null) {
        videoFile.value = File(pickedFile.path);
        _saveVideoStateUseCase.saveTempVideoPath(pickedFile.path);
        hasError.value = false;
        errorMessage.value = '';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Không thể chọn video: $e';
    }
  }
  
  // Quay video mới
  Future<void> recordNewVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (pickedFile != null) {
        videoFile.value = File(pickedFile.path);
        _saveVideoStateUseCase.saveTempVideoPath(pickedFile.path);
        hasError.value = false;
        errorMessage.value = '';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Không thể quay video: $e';
    }
  }
  
  // Phân tích video
  Future<void> analyzeVideo() async {
    if (videoFile.value == null) {
      hasError.value = true;
      errorMessage.value = 'Vui lòng chọn video trước khi phân tích';
      return;
    }
    
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      // Gọi usecase để phân tích video với loại phong trào được chọn
      final result = await _analyzeVideoUseCase.execute(
        videoFile.value!,
        movementType: selectedMovementType.value,
      );
      analysisResult.value = result;
      
      // Lưu kết quả phân tích
      // await _saveAnalysisResultUseCase.execute(result);
      
      // Xóa video sau khi phân tích xong
      await clearVideo();
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Lỗi khi phân tích video: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> clearVideo() async {
    try {
      // Xóa file video nếu có
      if (videoFile.value != null) {
        final path = videoFile.value!.path;
        
        if (videoFile.value!.existsSync()) {
          videoFile.value!.deleteSync();
        }
      }
      
      // Xóa trong storage
      await _saveVideoStateUseCase.clearTempVideo();
      
      // Xóa tham chiếu đến video để không hiển thị preview
      videoFile.value = null;
    } catch (e) {}
  }
  
  // Reset toàn bộ trạng thái
  Future<void> resetAll() async {
    try {
      await clearVideo();
      
      // Reset các giá trị khác
      hasError.value = false;
      errorMessage.value = '';
      analysisResult.value = null;
    } catch (e) {}
  }
  
  @override
  void onClose() {
    // Không cần xóa video khi controller bị hủy
    // vì nó được lưu trong persistent storage để khôi phục trạng thái
    super.onClose();
  }
} 