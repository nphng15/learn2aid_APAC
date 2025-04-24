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

    // Sử dụng kết hợp GetBuilder và Obx để tối ưu hiệu năng
    return GetBuilder<QuizController>(
      builder: (_) {
        // Hiển thị loading khi đang tải câu hỏi và chưa có câu hỏi
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
                  'Đang tải câu hỏi...',
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    color: AppColors.grey3,
                  ),
                ),
              ],
            ),
          );
        }
        
        // Kiểm tra xem có questions hay không
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
                  'Không có câu hỏi nào',
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
                    'Quay lại',
                    style: GoogleFonts.lexend(),
                  ),
                ),
              ],
            ),
          );
        }

        // Sử dụng Obx cho phần nội dung câu hỏi để chỉ cập nhật khi currentQuestionIndex thay đổi
        return Obx(() {
          final currentIndex = quizController.currentQuestionIndex.value;
          
          // Kiểm tra index hợp lệ
          if (currentIndex < 0 || currentIndex >= quizController.questions.length) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi: Câu hỏi không hợp lệ',
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
                      'Quay lại',
                      style: GoogleFonts.lexend(),
                    ),
                  ),
                ],
              ),
            );
          }

          // Lấy thông tin câu hỏi và câu trả lời đã chọn
          final currentQuestion = quizController.questions[currentIndex];
          
          // Kiểm tra độ dài mảng userAnswers
          if (quizController.userAnswers.length != quizController.questions.length) {
            // Tự động khởi tạo lại nếu không khớp
            quizController.userAnswers.value = List.filled(quizController.questions.length, -1);
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Câu hỏi
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị hình ảnh (nếu có)
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
                      
                      // Text câu hỏi
                      Text(
                        currentQuestion.text,
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Các lựa chọn - Sử dụng Obx riêng cho phần lựa chọn đáp án
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
              
              // Nút điều hướng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút quay lại
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: currentIndex > 0 
                          ? () {
                              // Thêm phản hồi xúc giác
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
                              'Trước',
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
                  
                  // Nút tiếp theo/nộp bài
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Thêm phản hồi xúc giác
                        HapticFeedback.mediumImpact();
                        
                        if (currentIndex < quizController.questions.length - 1) {
                          quizController.nextQuestion();
                        } else {
                          // Hiển thị dialog xác nhận nộp bài
                          Get.dialog(
                            AlertDialog(
                              title: Text(
                                'Nộp bài?',
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                              content: Text(
                                'Bạn đã trả lời ${quizController.answeredQuestions}/${quizController.questions.length} câu hỏi. Bạn có chắc chắn muốn nộp bài?',
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  color: AppColors.grey3,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Hủy',
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
                                    'Nộp bài',
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
                                  ? 'Tiếp theo'
                                  : 'Nộp bài',
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

    // Sử dụng InkWell thay vì GestureDetector để có hiệu ứng khi nhấn
    return InkWell(
      onTap: () {
        // Thêm phản hồi trực quan ngay lập tức
        HapticFeedback.selectionClick();
        // Gọi callback
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