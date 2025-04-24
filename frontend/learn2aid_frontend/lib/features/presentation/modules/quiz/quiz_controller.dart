import 'package:get/get.dart';
import '../../../domain/entities/quiz_entity.dart';
import '../../../domain/entities/question_entity.dart';
import '../../../domain/usecases/get_quizzes_usecase.dart';
import '../../../domain/usecases/get_quiz_questions_usecase.dart';
import '../../../domain/usecases/submit_quiz_result_usecase.dart';
import '../auth/login/login_controller.dart';
import 'package:flutter/material.dart';

class QuizController extends GetxController {
  // Use cases
  final GetQuizzesUseCase getQuizzesUseCase;
  final GetQuizQuestionsUseCase getQuizQuestionsUseCase;
  final SubmitQuizResultUseCase submitQuizResultUseCase;
  final LoginController loginController = Get.find<LoginController>();

  // Observable variables
  var quizzes = <QuizEntity>[].obs;
  var currentQuiz = Rxn<QuizEntity>();
  var questions = <QuestionEntity>[].obs;
  var currentQuestionIndex = 0.obs;
  var userAnswers = <int>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Timer variables
  var timeRemaining = 0.obs;  // seconds
  var timerRunning = false.obs;
  
  // Kết quả quiz
  var score = 0.obs;
  var showResults = false.obs;

  // ID duy nhất cho mỗi timer để theo dõi
  int? _currentTimerId;

  // Cờ để theo dõi tiến độ khởi tạo quiz
  var quizInitializing = false.obs;

  QuizController({
    required this.getQuizzesUseCase,
    required this.getQuizQuestionsUseCase,
    required this.submitQuizResultUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Lấy danh sách quiz cơ bản mà không cập nhật số câu hỏi
      quizzes.value = await getQuizzesUseCase.execute();
      
      // Kết thúc trạng thái loading để người dùng có thể thấy danh sách
      isLoading.value = false;
      
      // Cập nhật UI
      update();
      
      // Đợi một chút trước khi update số lượng câu hỏi
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Tải số câu hỏi trong background
      _updateQuizQuestionCounts();
    } catch (e) {
      errorMessage.value = 'Lỗi khi tải danh sách quiz: $e';
      isLoading.value = false;
      update();
    } 
  }
  
  // Cập nhật số lượng câu hỏi trong background
  Future<void> _updateQuizQuestionCounts() async {
    try {
      // Tạo một bản sao của quizzes để cập nhật
      final List<QuizEntity> updatedQuizzes = [...quizzes];
      bool hasUpdates = false;
      
      // Cập nhật số lượng câu hỏi từng quiz một
      for (int i = 0; i < updatedQuizzes.length; i++) {
        final currentQuiz = updatedQuizzes[i];
        
        // Bỏ qua nếu quiz đã có số câu hỏi > 0
        if (currentQuiz.totalQuestions > 0) continue;
        
        try {
          // Lấy số lượng câu hỏi thực tế
          final questions = await getQuizQuestionsUseCase.execute(currentQuiz.id);
          
          // Tạo quiz mới với số câu hỏi cập nhật
          updatedQuizzes[i] = QuizEntity(
            id: currentQuiz.id,
            title: currentQuiz.title, 
            description: currentQuiz.description,
            timeLimit: currentQuiz.timeLimit,
            totalQuestions: questions.length,
          );
          
          hasUpdates = true;
          
          // Cập nhật danh sách sau mỗi 3 quiz hoặc khi kết thúc
          if ((i + 1) % 3 == 0 || i == updatedQuizzes.length - 1) {
            if (hasUpdates) {
              quizzes.value = [...updatedQuizzes];
              update();
              hasUpdates = false;
              
              // Đợi một chút trước khi tiếp tục để UI có thể cập nhật
              await Future.delayed(const Duration(milliseconds: 100));
            }
          }
        } catch (e) {
          print('Lỗi khi lấy số câu hỏi cho quiz ${currentQuiz.id}: $e');
        }
      }
    } catch (e) {
      print('Lỗi khi cập nhật số câu hỏi: $e');
    }
  }

  // Khởi tạo quiz khi người dùng bấm nút bắt đầu
  void initQuiz(String quizId) {
    try {
      // Kiểm tra xem đã có quá trình khởi tạo đang chạy không
      if (quizInitializing.value) {
        Get.snackbar(
          'Thông báo',
          'Đang khởi tạo bài kiểm tra, vui lòng đợi...',
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.7),
          colorText: Colors.white,
        );
        return;
      }
      
      // Đặt cờ khởi tạo
      quizInitializing.value = true;
      
      // Chuyển đến màn hình quiz (UI sẽ hiển thị loader)
      isLoading.value = true;
      
      // Dừng timer nếu đang chạy
      if (timerRunning.value) {
        stopTimer();
      }
      
      // Reset trạng thái
      errorMessage.value = '';
      showResults.value = false;
      currentQuestionIndex.value = 0;
      score.value = 0;
      questions.clear();
      userAnswers.value = <int>[];
      
      // Cập nhật UI
      update();
      
      // Bắt đầu khởi tạo quiz trong background
      _startQuizProcess(quizId);
    } catch (e) {
      // Xử lý lỗi và reset trạng thái
      print('Lỗi khi khởi tạo quiz: $e');
      quizInitializing.value = false;
      isLoading.value = false;
      
      Get.snackbar(
        'Lỗi',
        'Không thể bắt đầu bài kiểm tra: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // Quy trình bắt đầu quiz trong background
  Future<void> _startQuizProcess(String quizId) async {
    // Sử dụng Future.delayed để cho phép UI cập nhật trước
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      // Bước 1: Lấy thông tin quiz với timeout
      await _loadQuizInfo(quizId).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw 'Quá thời gian tải thông tin bài kiểm tra',
      );
      
      // Sau khi có thông tin quiz, tải câu hỏi
      if (currentQuiz.value != null) {
        // Khởi tạo lại timer
        timeRemaining.value = currentQuiz.value!.timeLimit * 60;
        
        // Bước 2: Tải câu hỏi với timeout
        await _loadQuizQuestions(quizId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw 'Quá thời gian tải câu hỏi',
        );
      } else {
        throw 'Không thể tải thông tin bài kiểm tra';
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi bắt đầu bài kiểm tra: $e';
      print('Lỗi khi bắt đầu quiz: $e');
      
      Get.snackbar(
        'Lỗi',
        'Không thể bắt đầu bài kiểm tra: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Hoàn thành quá trình khởi tạo
      quizInitializing.value = false;
      
      // Kết thúc loading
      isLoading.value = false;
      update();
    }
  }
  
  // Chỉ lấy thông tin quiz, không tải câu hỏi
  Future<void> _loadQuizInfo(String quizId) async {
    try {
      // Tải thông tin quiz
      final quiz = await getQuizzesUseCase.repository.getQuizById(quizId);
      
      if (quiz == null) {
        errorMessage.value = 'Không tìm thấy bài kiểm tra';
        return;
      }
      
      // Cập nhật thông tin quiz
      currentQuiz.value = quiz;
      
      // Cập nhật UI sau khi có thông tin quiz
      update();
    } catch (e) {
      throw 'Không thể tải thông tin bài kiểm tra';
    }
  }
  
  // Tải câu hỏi quiz
  Future<void> _loadQuizQuestions(String quizId) async {
    try {
      // Tải danh sách câu hỏi
      final loadedQuestions = await getQuizQuestionsUseCase.execute(quizId);
      
      if (loadedQuestions.isEmpty) {
        errorMessage.value = 'Không có câu hỏi nào cho bài kiểm tra này';
        return;
      }
      
      // Gán danh sách câu hỏi vào biến observable
      questions.value = loadedQuestions;
      
      // Khởi tạo mảng câu trả lời mới với kích thước chính xác
      userAnswers.value = List.filled(questions.length, -1);
      
      // Khởi tạo timer nếu chưa có lỗi
      if (errorMessage.value.isEmpty) {
        startTimer();
      }
      
      // Cập nhật UI sau khi có câu hỏi
      update();
    } catch (e) {
      print('Lỗi khi tải câu hỏi quiz: $e');
      throw 'Không thể tải câu hỏi';
    }
  }

  void startTimer() {
    try {
      // Dừng timer hiện tại nếu đang chạy
      if (timerRunning.value) {
        stopTimer();
      }
      
      // Tạo ID duy nhất cho timer này
      _currentTimerId = DateTime.now().millisecondsSinceEpoch;
      final myTimerId = _currentTimerId;
      
      // Bắt đầu timer
      timerRunning.value = true;
      
      Future.doWhile(() async {
        // Kiểm tra nếu timer này đã bị thay thế hoặc dừng
        if (!timerRunning.value || myTimerId != _currentTimerId) {
          return false;
        }
        
        await Future.delayed(const Duration(seconds: 1));
        
        // Kiểm tra lại sau khi delay
        if (!timerRunning.value || myTimerId != _currentTimerId) {
          return false;
        }
        
        if (timeRemaining.value > 0) {
          timeRemaining.value--;
          update(); // Cập nhật UI
          return true;
        } else {
          // Hết thời gian
          if (timerRunning.value) {
            await submitQuiz(); // Tự động nộp bài khi hết giờ
          }
          stopTimer();
          return false;
        }
      }).catchError((e) {
        print('Lỗi trong timer: $e');
        stopTimer();
      });
    } catch (e) {
      print('Lỗi khi bắt đầu timer: $e');
      stopTimer();
    }
  }

  void stopTimer() {
    timerRunning.value = false;
    _currentTimerId = null;
    update();
  }

  String get formattedTime {
    final minutes = (timeRemaining.value / 60).floor();
    final seconds = timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    if (questionIndex < userAnswers.length) {
      // Nếu người dùng chọn đáp án đã chọn trước đó, không làm gì cả
      if (userAnswers[questionIndex] == answerIndex) return;
      
      // Cập nhật đáp án được chọn
      userAnswers[questionIndex] = answerIndex;
      
      // Cập nhật UI không sử dụng update() mà dùng refresh() để chỉ cập nhật widget liên quan
      if (questions.isNotEmpty) {
        userAnswers.refresh();
      }
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      // Tăng index câu hỏi
      currentQuestionIndex.value++;
      
      // Không gọi update() để tránh rebuild toàn bộ UI
      // Thay vào đó, chỉ cập nhật giá trị để Obx sẽ tự động cập nhật UI ở những widget có sử dụng giá trị này
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      // Giảm index câu hỏi
      currentQuestionIndex.value--;
      
      // Không gọi update() để tránh rebuild toàn bộ UI
    }
  }

  Future<void> submitQuiz() async {
    try {
      // Dừng timer nếu đang chạy
      if (timerRunning.value) {
        stopTimer();
      }
      
      isLoading.value = true;
      errorMessage.value = '';

      if (currentQuiz.value == null) {
        Get.snackbar(
          'Lỗi',
          'Không thể nộp bài: Không tìm thấy thông tin bài kiểm tra',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      if (questions.isEmpty) {
        Get.snackbar(
          'Lỗi',
          'Không thể nộp bài: Không có câu hỏi nào',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      // Đảm bảo userAnswers có đúng kích thước
      if (userAnswers.length != questions.length) {
        userAnswers.value = List.filled(questions.length, -1);
      }

      // Tính điểm
      score.value = 0;
      for (int i = 0; i < questions.length; i++) {
        
        if (i < userAnswers.length && userAnswers[i] == questions[i].correctOption) {
          score.value++;
        }
      }

      try {
        // Lưu kết quả vào Firestore
        await submitQuizResultUseCase.execute(
          userId: loginController.googleUserEmail.value,
          userName: loginController.googleUserName.value,
          quizId: currentQuiz.value!.id,
          quizTitle: currentQuiz.value!.title,
          score: score.value,
          totalQuestions: questions.length,
          answers: userAnswers,
          timeSpent: (currentQuiz.value!.timeLimit * 60 - timeRemaining.value),
        );
      } catch (e) {
        print('Lỗi khi lưu kết quả quiz: $e');
        // Vẫn tiếp tục hiển thị kết quả ngay cả khi không lưu được
      }

      // Hiển thị kết quả
      showResults.value = true;
      update();
    } catch (e) {
      errorMessage.value = 'Lỗi khi nộp bài: $e';
      print('Lỗi khi nộp bài: $e');
      
      Get.snackbar(
        'Lỗi',
        'Không thể nộp bài kiểm tra: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetQuiz() {
    try {
      // Dừng timer nếu đang chạy
      if (timerRunning.value) {
        stopTimer();
      }
      
      // Đặt trạng thái loading để tránh tương tác trong quá trình reset
      isLoading.value = true;
      
      // Reset tất cả các trạng thái
      currentQuiz.value = null;
      questions.clear();
      userAnswers.value = <int>[];
      currentQuestionIndex.value = 0;
      showResults.value = false;
      score.value = 0;
      timeRemaining.value = 0;
      errorMessage.value = '';
      
      // Đợi một chút để đảm bảo UI kịp cập nhật
      Future.delayed(const Duration(milliseconds: 100), () {
        // Cập nhật UI
        update();
        
        // Kết thúc trạng thái loading
        isLoading.value = false;
      });
    } catch (e) {
      print('Lỗi khi reset quiz: $e');
      
      // Đảm bảo isLoading được đặt về false trong mọi trường hợp
      isLoading.value = false;
      
      // Hiển thị thông báo nếu có lỗi
      Get.snackbar(
        'Lỗi',
        'Không thể quay lại danh sách: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  double get progressPercentage {
    if (questions.isEmpty) return 0;
    return (currentQuestionIndex.value + 1) / questions.length;
  }
  
  int get answeredQuestions {
    return userAnswers.where((answer) => answer >= 0).length;
  }

  @override
  void onClose() {
    // Dừng timer để tránh memory leak
    if (timerRunning.value) {
      stopTimer();
    }
    
    // Xóa các trạng thái hiện tại
    questions.clear();
    userAnswers.clear();
    currentQuiz.value = null;
    
    super.onClose();
  }
}