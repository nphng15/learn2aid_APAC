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
  
  // Quiz results
  var score = 0.obs;
  var showResults = false.obs;

  // Unique ID for each timer to track
  int? _currentTimerId;

  // Flag to track quiz initialization progress
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
      errorMessage.value = 'Failed to load quizzes: $e';
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
          print('Error when getting number of questions for quiz ${currentQuiz.id}: $e');
        }
      }
    } catch (e) {
      print('Error updating question counts: $e');
    }
  }

  // Initialize quiz when user presses start button
  void initQuiz(String quizId) {
    try {
      // Check if initialization process is already running
      if (quizInitializing.value) {
        Get.snackbar(
          'Notice',
          'Quiz initialization in progress, please wait...',
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.7),
          colorText: Colors.white,
        );
        return;
      }
      
      // Set initialization flag
      quizInitializing.value = true;
      
      // Navigate to quiz screen (UI will show loader)
      isLoading.value = true;
      
      // Stop timer if running
      if (timerRunning.value) {
        stopTimer();
      }
      
      // Reset state
      errorMessage.value = '';
      showResults.value = false;
      currentQuestionIndex.value = 0;
      score.value = 0;
      questions.clear();
      userAnswers.value = <int>[];
      
      // Update UI
      update();
      
      // Start quiz initialization in background
      _startQuizProcess(quizId);
    } catch (e) {
      // Handle errors and reset state
      print('Error initializing quiz: $e');
      quizInitializing.value = false;
      isLoading.value = false;
      
      Get.snackbar(
        'Error',
        'Cannot start the quiz: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // Quiz initiation process in background
  Future<void> _startQuizProcess(String quizId) async {
    // Sử dụng Future.delayed để cho phép UI cập nhật trước
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      // Bước 1: Lấy thông tin quiz với timeout
      await _loadQuizInfo(quizId).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw 'Quiz information loading timed out',
      );
      
      // Sau khi có thông tin quiz, tải câu hỏi
      if (currentQuiz.value != null) {
        // Khởi tạo lại timer
        timeRemaining.value = currentQuiz.value!.timeLimit * 60;
        
        // Bước 2: Tải câu hỏi với timeout
        await _loadQuizQuestions(quizId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw 'Questions loading timed out',
        );
      } else {
        throw 'Cannot load quiz information';
      }
    } catch (e) {
      errorMessage.value = 'Error loading quiz: $e';
      print('Error starting quiz: $e');
      
      Get.snackbar(
        'Error',
        'Cannot load quiz: $e',
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
  
  Future<void> _loadQuizInfo(String quizId) async {
    try {
      // Load quiz info
      final quiz = await getQuizzesUseCase.repository.getQuizById(quizId);
      
      if (quiz == null) {
        errorMessage.value = 'Quiz not found';
        return;
      }
      
      // Update quiz info
      currentQuiz.value = quiz;
      
      // Update UI after getting quiz info
      update();
    } catch (e) {
      throw 'Cannot load quiz information';
    }
  }
  
  // Load quiz questions
  Future<void> _loadQuizQuestions(String quizId) async {
    try {
      // Load question list
      final loadedQuestions = await getQuizQuestionsUseCase.execute(quizId);
      
      if (loadedQuestions.isEmpty) {
        errorMessage.value = 'No questions available for this quiz';
        return;
      }
      
      // Assign question list to observable variable
      questions.value = loadedQuestions;
      
      // Initialize new answer array with correct size
      userAnswers.value = List.filled(questions.length, -1);
      
      // Initialize timer if no errors
      if (errorMessage.value.isEmpty) {
        startTimer();
      }
      
      // Update UI after getting questions
      update();
    } catch (e) {
      print('Error loading quiz questions: $e');
      throw 'Cannot load questions';
    }
  }
  
  // Get formatted time
  String get formattedTime {
    final minutes = (timeRemaining.value / 60).floor();
    final seconds = timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Start timer for quiz
  void startTimer() {
    try {
      // Stop any existing timer
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
          // Time's up, submit the quiz
          if (timerRunning.value) {
            await submitQuiz(); // Tự động nộp bài khi hết giờ
          }
          stopTimer();
          return false;
        }
      }).catchError((e) {
        print('Error in timer: $e');
        stopTimer();
      });
    } catch (e) {
      print('Error starting timer: $e');
      stopTimer();
    }
  }
  
  // Stop timer
  void stopTimer() {
    timerRunning.value = false;
    _currentTimerId = null;
    update();
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
    }
  }
  
  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      // Giảm index câu hỏi
      currentQuestionIndex.value--;
      
      // Không gọi update() để tránh rebuild toàn bộ UI
    }
  }
  
  // Reset quiz state
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
      print('Error resetting quiz: $e');
      
      // Đảm bảo isLoading được đặt về false trong mọi trường hợp
      isLoading.value = false;
      
      // Hiển thị thông báo nếu có lỗi
      Get.snackbar(
        'Error',
        'Cannot return to list: $e',
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
  
  // Get number of answered questions
  int get answeredQuestions {
    return userAnswers.where((answer) => answer >= 0).length;
  }
  
  // Submit quiz
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
          'Error',
          'Cannot submit quiz: Quiz information not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      if (questions.isEmpty) {
        Get.snackbar(
          'Error',
          'Cannot submit quiz: No questions available',
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

      // Calculate score
      score.value = 0;
      for (int i = 0; i < questions.length; i++) {
        if (i < userAnswers.length && userAnswers[i] == questions[i].correctOption) {
          score.value++;
        }
      }

      try {
        // Submit score to backend if user is logged in
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
        print('Error saving quiz results: $e');
        // Vẫn tiếp tục hiển thị kết quả ngay cả khi không lưu được
      }
      
      // Show results
      showResults.value = true;
      update();
    } catch (e) {
      errorMessage.value = 'Error submitting quiz: $e';
      print('Error submitting quiz: $e');
      
      Get.snackbar(
        'Error',
        'Failed to submit quiz: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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