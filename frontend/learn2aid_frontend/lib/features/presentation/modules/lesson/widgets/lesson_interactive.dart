import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_analysis_controller.dart';
import './video_player_widget.dart';
import './analysis_result_dialog.dart';
import '../../dashboard/controllers/video_controller.dart';


class LessonInteractive extends StatelessWidget {
  // Menu for movement types
  final List<Map<String, String>> movementTypes = [
    {'value': 'cpr', 'label': '1. CPR'},
    {'value': 'recovery_position', 'label': '2. Recovery Position'},
    {'value': 'heimlich', 'label': '3. Airway Obstruction'},
    {'value': 'nose_bleeding', 'label': '4. Nose Bleeding'},
    {'value': 'fainting', 'label': '5. Fainting'},
  ];

  LessonInteractive({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller registered from binding
    final controller = Get.find<VideoAnalysisController>();
    
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(10),
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
                  'Practice with AI!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // Main content
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Video preview area with fixed size
                    SizedBox(
                      height: 160,
                      child: Obx(() => controller.videoFile.value != null
                          ? VideoPlayerWidget(videoFile: controller.videoFile.value!)
                          : _buildEmptyVideoArea(),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Movement type dropdown and error message
                    SizedBox(
                      height: 50,
                      child: Obx(() => controller.hasError.value
                          ? _buildErrorMessage(controller.errorMessage.value)
                          : _buildMovementDropdown(controller),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Action buttons 
                    SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: controller.isLoading.value
                                  ? null
                                  : controller.pickVideoFromGallery,
                              child: interactiveBox(
                                icon: Icons.upload,
                                text: 'Upload',
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
                                text: 'Record Video',
                                isDisabled: controller.isLoading.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Analyze button
                    Obx(() => _buildAnalyzeButton(context, controller)),
                  ],
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
              'Choose or record a video for AI to evaluate your practice results!',
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
          const Text('Movement type:', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() => DropdownButton<String>(
              value: controller.selectedMovementType.value,
              isExpanded: true,
              isDense: true,
              underline: Container(), // remove default underline
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Practice Guide'),
                  content: const Text(
                    'Practice steps:\n\n'
                    '1. Select the type of movement to practice\n'
                    '2. Upload a video or record a new one\n'
                    '3. Press the Analyze button for AI to evaluate your skills'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Understood'),
                    ),
                  ],
                ),
                barrierDismissible: true,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xff215273),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Text(
                'Guide',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Analyze button
          GestureDetector(
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
                          'Analyzing...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Analyze',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAnalysisDialog(BuildContext context, VideoAnalysisController controller) {
    // Get video ID from LessonPage arguments
    final Map<String, dynamic>? args = Get.arguments;
    String videoId = args != null && args['video'] != null ? args['video'].id : '';
    
    // Debug: Print videoId information
    print('DEBUG - Show Analysis Dialog');
    print('DEBUG - Video ID: $videoId');
    print('DEBUG - Video from arguments: ${args != null ? args['video'] : 'null'}');
    print('DEBUG - Analysis score: ${controller.analysisResult.value?.score}');
    
    // Check if video ID is valid
    if (videoId.isEmpty) {
      // Try to get ID from selectedVideo of VideoController
      final videoController = Get.find<VideoController>();
      if (videoController.selectedVideo.value != null) {
        videoId = videoController.selectedVideo.value!.id;
        print('DEBUG - Got videoId from selectedVideo: $videoId');
      }
    }
    
    // Double check if video ID is valid
    if (videoId.isEmpty) {
      // If there's no videoId, show notification
      Get.snackbar(
        'Error',
        'Unable to determine which video is being viewed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
    
    // Check if video exists in the videos list of VideoController
    final videoController = Get.find<VideoController>();
    if (!videoController.hasVideoWithId(videoId)) {
      print('DEBUG - VIDEO ID DOES NOT EXIST IN LIST: $videoId');
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
