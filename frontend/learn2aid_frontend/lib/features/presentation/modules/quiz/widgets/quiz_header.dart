import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/theme/app_color.dart';
import '../quiz_controller.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        // If showing quiz list
        if (quizController.currentQuiz.value == null) {
          return Row(
            children: [
              // IconButton(
              //   onPressed: () => Get.back(),
              //   icon: const Icon(Icons.arrow_back_ios, size: 20),
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   color: AppColors.secondary,
              // ),
              // const SizedBox(width: 8),
              Center(
                child: Text(
                  'Quizzes',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          );
        }

        // If taking the quiz
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quizController.showResults.value) {
                          quizController.resetQuiz();
                        } else {
                          // Show exit confirmation dialog
                          Get.dialog(
                            AlertDialog(
                              title: Text(
                                'Exit Quiz?',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                              content: Text(
                                'Your answers will not be saved. Are you sure you want to exit?',
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  color: AppColors.grey3,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.lexend(
                                      color: AppColors.grey3,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    quizController.resetQuiz();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Exit',
                                    style: GoogleFonts.lexend(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        quizController.currentQuiz.value!.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),

                // Timer (only displayed when taking the quiz, not on results page)
                if (!quizController.showResults.value)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          quizController.formattedTime,
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Progress bar (only displayed when taking the quiz, not on results page)
            if (!quizController.showResults.value && quizController.questions.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Question ${quizController.currentQuestionIndex.value + 1}/${quizController.questions.length}',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: AppColors.grey3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(Answered: ${quizController.answeredQuestions})',
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: AppColors.grey3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: quizController.questions.isNotEmpty
                        ? (quizController.currentQuestionIndex.value + 1) /
                            quizController.questions.length
                        : 0,
                    backgroundColor: Colors.grey[200],
                    color: AppColors.secondary,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }
}
