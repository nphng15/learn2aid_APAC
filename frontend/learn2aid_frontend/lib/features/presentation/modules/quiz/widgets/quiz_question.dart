import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/theme/app_color.dart';
import '../quiz_controller.dart';

class QuizQuestion extends StatelessWidget {
  const QuizQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.find<QuizController>();

    // Use both GetBuilder and Obx for optimized performance
    return GetBuilder<QuizController>(
      builder: (_) {
        // Display loading when loading questions and no questions yet
        if (quizController.isLoading.value && quizController.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading questions...',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    color: AppColors.grey3,
                  ),
                ),
              ],
            ),
          );
        }
        
        // Check if there are questions
        if (quizController.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 48,
                  color: AppColors.grey3,
                ),
                const SizedBox(height: 16),
                Text(
                  'No questions available',
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey3,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => quizController.resetQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Go Back',
                    style: GoogleFonts.lexend(),
                  ),
                ),
              ],
            ),
          );
        }

        // Use Obx for question content to only update when currentQuestionIndex changes
        return Obx(() {
          final currentIndex = quizController.currentQuestionIndex.value;
          
          // Check for valid index
          if (currentIndex < 0 || currentIndex >= quizController.questions.length) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: Invalid question',
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => quizController.resetQuiz(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Go Back',
                      style: GoogleFonts.lexend(),
                    ),
                  ),
                ],
              ),
            );
          }

          // Get current question and selected answer
          final currentQuestion = quizController.questions[currentIndex];
          
          // Check userAnswers length
          if (quizController.userAnswers.length != quizController.questions.length) {
            // Automatically reinitialize if mismatch
            quizController.userAnswers.value = List.filled(quizController.questions.length, -1);
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display image if available
                      if (currentQuestion.imageUrl != null && currentQuestion.imageUrl!.isNotEmpty)
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(currentQuestion.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      
                      // Question text
                      Text(
                        currentQuestion.text,
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Options - Use separate Obx for answer selection section
                      ...List.generate(
                        currentQuestion.options.length,
                        (index) => Obx(() => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildOptionItem(
                            index,
                            currentQuestion.options[index],
                            quizController.userAnswers[currentIndex] == index,
                            () => quizController.selectAnswer(currentIndex, index),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: currentIndex > 0 
                          ? () {
                              // Add haptic feedback
                              HapticFeedback.mediumImpact();
                              quizController.previousQuestion();
                            }
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: currentIndex > 0 
                                ? AppColors.secondary 
                                : AppColors.grey4,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: currentIndex > 0 
                                  ? AppColors.secondary 
                                  : AppColors.grey4,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Previous',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: currentIndex > 0 
                                    ? AppColors.secondary 
                                    : AppColors.grey4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Next/Submit button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Add haptic feedback
                        HapticFeedback.mediumImpact();
                        
                        if (currentIndex < quizController.questions.length - 1) {
                          quizController.nextQuestion();
                        } else {
                          // Show confirmation dialog for submission
                          Get.dialog(
                            AlertDialog(
                              title: Text(
                                'Submit Quiz?',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                              content: Text(
                                'You have answered ${quizController.answeredQuestions}/${quizController.questions.length} questions. Are you sure you want to submit?',
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
                                    quizController.submitQuiz();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.lexend(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              currentIndex < quizController.questions.length - 1
                                  ? 'Next'
                                  : 'Submit',
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              currentIndex < quizController.questions.length - 1
                                  ? Icons.arrow_forward_ios
                                  : Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Widget _buildOptionItem(
    int index,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final optionLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    final optionLabel = index < optionLabels.length ? optionLabels[index] : index.toString();

    // Use InkWell instead of GestureDetector for press effects
    return InkWell(
      onTap: () {
        // Add immediate visual feedback
        HapticFeedback.selectionClick();
        // Call callback
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.grey4,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.secondary : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.grey4,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    optionLabel,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.grey3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 