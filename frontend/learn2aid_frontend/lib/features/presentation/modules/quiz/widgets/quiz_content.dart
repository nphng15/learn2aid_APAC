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
          // Hiển thị trạng thái loading
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
                    'Đang tải bài kiểm tra...',
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hiển thị thông báo để người dùng biết quá trình đang diễn ra
                  Text(
                    'Vui lòng đợi trong giây lát',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: AppColors.grey3,
                    ),
                  ),
                ],
              ),
            );
          }

          // Hiển thị lỗi nếu có
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
                    'Đã xảy ra lỗi',
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
                      'Thử lại',
                      style: GoogleFonts.lexend(),
                    ),
                  ),
                ],
              ),
            );
          }

          // Hiển thị các màn hình khác nhau dựa trên trạng thái quiz
          if (quizController.currentQuiz.value == null) {
            // Hiển thị danh sách quiz (đã được tối ưu trong widget QuizList)
            return const QuizList();
          } else if (quizController.showResults.value) {
            // Hiển thị kết quả quiz
            return const QuizResults();
          } else {
            // Hiển thị câu hỏi quiz
            return const QuizQuestion();
          }
        },
      ),
    );
  }
}
