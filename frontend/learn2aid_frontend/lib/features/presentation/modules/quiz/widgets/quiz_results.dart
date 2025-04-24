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
          // Title
          Text(
            'Quiz Results',
            style: GoogleFonts.lexend(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),

          // Score
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
                // Circular chart
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
                              'Correct $score/$totalQuestions',
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

                // Quiz info
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

                // Evaluation
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

                // Time spent on quiz
                if (quizController.currentQuiz.value != null)
                  Text(
                    'Time: ${_formatTime(quizController.currentQuiz.value!.timeLimit * 60 - quizController.timeRemaining.value)}',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: AppColors.grey3,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
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
                    'Back',
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
                    // Simpler approach - Return to quiz list first
                    quizController.resetQuiz();
                    
                    // Notify the user
                    Get.snackbar(
                      'Success',
                      'Please select a quiz to retake',
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
                    'Retry',
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
    if (percentageScore >= 80) return 'Excellent!';
    if (percentageScore >= 60) return 'Good!';
    if (percentageScore >= 40) return 'Passed!';
    return 'Try harder!';
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}