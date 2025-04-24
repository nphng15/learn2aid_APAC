import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/video_analysis.dart';
import './analysis_details_page.dart';
import '../controllers/lesson_controller.dart';
import '../../dashboard/controllers/video_controller.dart';

class AnalysisResultDialog extends StatelessWidget {
  final VideoAnalysis analysis;
  final VoidCallback? onSave;
  final String videoId;
  
  const AnalysisResultDialog({
    super.key,
    required this.analysis,
    this.onSave,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    final LessonController lessonController = Get.find<LessonController>();
    final VideoController videoController = Get.find<VideoController>();
    
    // Debug logging
    print('DEBUG - AnalysisResultDialog.build()');
    print('DEBUG - Video ID ban đầu: $videoId');
    
    // Nếu không có videoId, thêm video thử nghiệm
    String finalVideoId = videoId;
    if (finalVideoId.isEmpty) {
      // Kiểm tra video test đã có chưa, nếu chưa thì thêm vào
      if (!videoController.hasVideoWithId('test_video_1')) {
        videoController.addTestVideo();
        print('DEBUG - Đã thêm video thử nghiệm vào danh sách');
      }
      finalVideoId = 'test_video_1';
      print('DEBUG - Sử dụng video thử nghiệm ID: $finalVideoId');
    }
    
    print('DEBUG - Video ID cuối cùng: $finalVideoId');
    print('DEBUG - Analysis score: ${analysis.score}');
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tiêu đề kết quả
            const Text(
              'Kết quả phân tích',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
                color: Color(0xff215273),
              ),
            ),
            const SizedBox(height: 24),
            
            // Điểm số với CircularProgressIndicator
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: analysis.score / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xff55c595),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${analysis.score.round()}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff55c595),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Mô tả kết quả
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                _getShortDescription(analysis),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  height: 1.5,
                  color: Color(0xff333333),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Nút điều hướng
            Row(
              children: [
                // View details button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Đóng dialog trước
                      Navigator.of(context).pop();
                      
                      // Mở trang chi tiết
                      Get.to(() => AnalysisDetailsPage(analysis: analysis));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xff215273)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        color: Color(0xff215273),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Continue button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (onSave != null) onSave!();
                      
                      print('DEBUG - Continue button pressed');
                      print('DEBUG - Video ID: $finalVideoId');
                      
                      // Đánh dấu video đã hoàn thành nếu có ID hợp lệ
                      if (finalVideoId.isNotEmpty) {
                        // Đánh dấu video đã hoàn thành nếu điểm > 80
                        lessonController.markVideoAsCompletedWithScore(
                          finalVideoId, 
                          analysis.score
                        );
                        
                        // Hiển thị thông báo nếu điểm > 80
                        if (analysis.score > 80) {
                          Get.snackbar(
                            'Chúc mừng!',
                            'Bạn đã hoàn thành video này với điểm ${analysis.score.round()}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xff55c595),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      } else {
                        print('DEBUG - ERROR: videoId rỗng trong Continue button');
                        Get.snackbar(
                          'Lỗi',
                          'Không thể đánh dấu video hoàn thành: ID không hợp lệ',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff55c595),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Trả về mô tả ngắn gọn dựa trên phân tích
  String _getShortDescription(VideoAnalysis analysis) {
    // Nếu có điểm mạnh thì dùng điểm mạnh đầu tiên, ngược lại dùng mô tả chung
    if (analysis.strengths.isNotEmpty) {
      return analysis.strengths.first;
    } else if (analysis.analysis.isNotEmpty) {
      return analysis.analysis;
    }
    return "Chuyển động của bạn đã được phân tích!";
  }
} 