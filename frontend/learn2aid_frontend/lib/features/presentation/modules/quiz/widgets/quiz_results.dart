import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/theme/app_color.dart';
import '../quiz_controller.dart';

class QuizResults extends StatelessWidget {
  const QuizResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();

    return Obx(() {
      final score = quizController.score.value;
      final totalQuestions = quizController.questions.length;
      final percentageScore = totalQuestions > 0
          ? (score / totalQuestions * 100).toInt()
          : 0;

      return Column(
        children: [
          // Tiêu đề
          Text(
            'Kết quả bài kiểm tra',
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),

          // Điểm số
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Biểu đồ tròn
                SizedBox(
                  height: 160,
                  width: 160,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 160,
                          width: 160,
                          child: CircularProgressIndicator(
                            value: totalQuestions > 0
                                ? score / totalQuestions
                                : 0,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(percentageScore),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$percentageScore%',
                              style: GoogleFonts.lexend(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: _getScoreColor(percentageScore),
                              ),
                            ),
                            Text(
                              'Đúng $score/$totalQuestions',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: AppColors.grey3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Thông tin quiz
                if (quizController.currentQuiz.value != null)
                  Text(
                    quizController.currentQuiz.value!.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                const SizedBox(height: 8),

                // Đánh giá
                Text(
                  _getScoreMessage(percentageScore),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _getScoreColor(percentageScore),
                  ),
                ),
                const SizedBox(height: 16),

                // Thời gian làm bài
                if (quizController.currentQuiz.value != null)
                  Text(
                    'Thời gian: ${_formatTime(quizController.currentQuiz.value!.timeLimit * 60 - quizController.timeRemaining.value)}',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: AppColors.grey3,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Nút hành động
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => quizController.resetQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.secondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  child: Text(
                    'Quay lại',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Cách đơn giản hơn - Quay về danh sách quiz trước
                    quizController.resetQuiz();
                    
                    // Thông báo cho người dùng
                    Get.snackbar(
                      'Thành công',
                      'Vui lòng chọn lại bài kiểm tra để làm lại',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.secondary,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Làm lại',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Color _getScoreColor(int percentageScore) {
    if (percentageScore >= 80) return const Color(0xff55c595);
    if (percentageScore >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int percentageScore) {
    if (percentageScore >= 80) return 'Xuất sắc!';
    if (percentageScore >= 60) return 'Tốt!';
    if (percentageScore >= 40) return 'Đạt!';
    return 'Cần cố gắng hơn!';
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
} 