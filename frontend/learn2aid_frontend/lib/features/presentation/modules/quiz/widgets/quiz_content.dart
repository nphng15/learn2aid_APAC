import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/theme/app_color.dart';
import '../quiz_controller.dart';
import 'quiz_list.dart';
import 'quiz_question.dart';
import 'quiz_results.dart';

class QuizContent extends StatelessWidget {
  const QuizContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GetBuilder<QuizController>(
        builder: (_) {
          // Display loading state
          if (quizController.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading quiz...',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display message to inform user about the process
                  Text(
                    'Please wait a moment',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: AppColors.grey3,
                    ),
                  ),
                ],
              ),
            );
          }

          // Display error if exists
          if (quizController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'An error occurred',
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quizController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: AppColors.grey3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      quizController.errorMessage.value = '';
                      quizController.loadQuizzes();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.lexend(),
                    ),
                  ),
                ],
              ),
            );
          }

          // Display different screens based on quiz state
          if (quizController.currentQuiz.value == null) {
            // Display quiz list (optimized in QuizList widget)
            return const QuizList();
          } else if (quizController.showResults.value) {
            // Display quiz results
            return const QuizResults();
          } else {
            // Display quiz question
            return const QuizQuestion();
          }
        },
      ),
    );
  }
}
