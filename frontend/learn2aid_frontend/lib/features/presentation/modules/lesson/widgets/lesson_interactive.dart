import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_analysis_controller.dart';
import './video_player_widget.dart';
import './analysis_result_dialog.dart';
import '../../dashboard/controllers/video_controller.dart';


class LessonInteractive extends StatelessWidget {
  // Menu cho loại phong trào
  final List<Map<String, String>> movementTypes = [
    {'value': 'cpr', 'label': '1. CPR'},
    {'value': 'recovery_position', 'label': '2. Tư thế hồi sức'},
    {'value': 'heimlich', 'label': '3. Dị vật đường thở'},
    {'value': 'nose_bleeding', 'label': '4. Chảy máu mũi'},
    {'value': 'fainting', 'label': '5. Choáng ngất'},
  ];

  LessonInteractive({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy controller đã được đăng ký từ binding
    final controller = Get.find<VideoAnalysisController>();
    
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.55,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff215273), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Thực hành cùng AI!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Nội dung chính
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Video preview area với kích thước cố định
                      SizedBox(
                        height: 180, // Chiều cao cố định khớp với VideoPlayerWidget
                        child: Obx(() => controller.videoFile.value != null
                            ? VideoPlayerWidget(videoFile: controller.videoFile.value!)
                            : _buildEmptyVideoArea(),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Movement type dropdown và error message
                      SizedBox(
                        height: 50, // Chiều cao cố đ
                        child: Obx(() => controller.hasError.value
                            ? _buildErrorMessage(controller.errorMessage.value)
                            : _buildMovementDropdown(controller),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Action buttons 
                      SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: controller.isLoading.value
                                    ? null
                                    : controller.pickVideoFromGallery,
                                child: interactiveBox(
                                  icon: Icons.upload,
                                  text: 'Tải lên',
                                  isDisabled: controller.isLoading.value,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: controller.isLoading.value
                                    ? null
                                    : controller.recordNewVideo,
                                child: interactiveBox(
                                  icon: Icons.camera_alt,
                                  text: 'Quay video',
                                  isDisabled: controller.isLoading.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Nút phân tích
                      Obx(() => _buildAnalyzeButton(context, controller)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyVideoArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Chọn hoặc quay video để AI đánh giá kết quả thực hành của bạn!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade900, fontSize: 12),
      ),
    );
  }
  
  Widget _buildMovementDropdown(VideoAnalysisController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('Loại động tác:', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() => DropdownButton<String>(
              value: controller.selectedMovementType.value,
              isExpanded: true,
              isDense: true,
              underline: Container(), // loại bỏ đường gạch dưới mặc định
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.selectedMovementType.value = newValue;
                }
              },
              items: movementTypes.map((type) => DropdownMenuItem(
                value: type['value'],
                child: Text(type['label']!, style: const TextStyle(fontSize: 14)),
              )).toList(),
            )),
          ),
        ],
      ),
    );
  }
  
  Widget interactiveBox({
    required IconData icon,
    required String text,
    bool isDisabled = false,
  }) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isDisabled ? Colors.grey : Colors.black87,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDisabled ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalyzeButton(BuildContext context, VideoAnalysisController controller) {
    final bool isDisabled = controller.isLoading.value || controller.videoFile.value == null;
    
    return Center(
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () async {
                await controller.analyzeVideo();
                
                if (controller.analysisResult.value != null && !controller.hasError.value) {
                  _showAnalysisDialog(context, controller);
                }
              },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey : const Color(0xff55c595),
            borderRadius: BorderRadius.circular(60),
          ),
          child: controller.isLoading.value
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Đang phân tích...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'Phân tích',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
  
  void _showAnalysisDialog(BuildContext context, VideoAnalysisController controller) {
    // Lấy video ID từ LessonPage arguments
    final Map<String, dynamic>? args = Get.arguments;
    String videoId = args != null && args['video'] != null ? args['video'].id : '';
    
    // Debug: In ra thông tin videoId
    print('DEBUG - Show Analysis Dialog');
    print('DEBUG - Video ID: $videoId');
    print('DEBUG - Video từ arguments: ${args != null ? args['video'] : 'null'}');
    print('DEBUG - Điểm phân tích: ${controller.analysisResult.value?.score}');
    
    // Kiểm tra video ID có hợp lệ không
    if (videoId.isEmpty) {
      // Thử lấy ID từ selectedVideo của VideoController
      final videoController = Get.find<VideoController>();
      if (videoController.selectedVideo.value != null) {
        videoId = videoController.selectedVideo.value!.id;
        print('DEBUG - Đã lấy videoId từ selectedVideo: $videoId');
      }
    }
    
    // Kiểm tra lại video ID có hợp lệ không
    if (videoId.isEmpty) {
      // Nếu không có videoId, hiển thị thông báo
      Get.snackbar(
        'Lỗi',
        'Không thể xác định video đang xem. Vui lòng thử lại.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
    
    // Kiểm tra video có tồn tại trong danh sách videos của VideoController
    final videoController = Get.find<VideoController>();
    if (!videoController.hasVideoWithId(videoId)) {
      print('DEBUG - VIDEO ID KHÔNG TỒN TẠI TRONG DANH SÁCH: $videoId');
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnalysisResultDialog(
        analysis: controller.analysisResult.value!,
        videoId: videoId,
      ),
    );
  }
}
