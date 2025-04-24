import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/dashboard_navbar.dart';
import '../widgets/quiz_header.dart';
import '../widgets/quiz_content.dart';
import '../quiz_controller.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đảm bảo QuizController đã được inject
    Get.find<QuizController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Quiz Header - hiển thị tiêu đề, thời gian, thông tin quiz
            const QuizHeader(),
            
            // Quiz Content - hiển thị danh sách quiz, câu hỏi, kết quả
            const Expanded(child: QuizContent()),
            
            // Dashboard NavBar - điều hướng giữa các trang
            const DashboardNavBar(),
          ],
        ),
      ),
    );
  }
}
