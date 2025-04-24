import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/theme/app_color.dart';
import '../quiz_controller.dart';
import '../../../../domain/entities/quiz_entity.dart';

class QuizList extends StatelessWidget {
  const QuizList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();

    return GetBuilder<QuizController>(
      builder: (_) {
        if (quizController.quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: AppColors.grey3,
                ),
                const SizedBox(height: 16),
                Text(
                  'No quizzes available',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check back later',
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: AppColors.grey3,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz List',
              style: GoogleFonts.lexend(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quizController.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizController.quizzes[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == quizController.quizzes.length - 1 ? 0 : 12),
                    child: _buildQuizItem(context, quiz, quizController),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuizItem(BuildContext context, QuizEntity quiz, QuizController controller) {
    return InkWell(
      onTap: () {
        if (controller.isLoading.value || controller.quizInitializing.value) {
          Get.snackbar(
            'Notice',
            'Processing, please wait...',
            duration: const Duration(seconds: 1),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.7),
            colorText: Colors.white,
          );
          return;
        }
        
        controller.initQuiz(quiz.id);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    quiz.title,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${quiz.timeLimit} minutes',
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              quiz.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: AppColors.grey3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.question_answer_outlined,
                  size: 16,
                  color: AppColors.grey3,
                ),
                const SizedBox(width: 4),
                Text(
                  '${quiz.totalQuestions} questions',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: AppColors.grey3,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (controller.isLoading.value || controller.quizInitializing.value) {
                      Get.snackbar(
                        'Notice',
                        'Processing, please wait...',
                        duration: const Duration(seconds: 1),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                      return;
                    }
                    
                    controller.initQuiz(quiz.id);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Start',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
} 