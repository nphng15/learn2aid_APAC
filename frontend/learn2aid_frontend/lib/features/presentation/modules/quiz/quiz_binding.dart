import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_controller.dart';
import '../../../data/repositories/quiz_repository_impl.dart';
import '../../../domain/usecases/get_quizzes_usecase.dart';
import '../../../domain/usecases/get_quiz_questions_usecase.dart';
import '../../../domain/usecases/submit_quiz_result_usecase.dart';
import '../../../data/datasources/remote/quiz_remote_datasource.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    // DataSource
    Get.lazyPut<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      ),
      fenix: true,
    );
    
    // Repository
    Get.lazyPut<QuizRepositoryImpl>(
      () => QuizRepositoryImpl(
        remoteDataSource: Get.find<QuizRemoteDataSource>(),
      ),
      fenix: true,
    );
    
    // Use cases
    final repository = Get.find<QuizRepositoryImpl>();
    final getQuizzesUseCase = GetQuizzesUseCase(repository);
    final getQuizQuestionsUseCase = GetQuizQuestionsUseCase(repository);
    final submitQuizResultUseCase = SubmitQuizResultUseCase(repository);
    
    // Controller
    Get.put<QuizController>(
      QuizController(
        getQuizzesUseCase: getQuizzesUseCase,
        getQuizQuestionsUseCase: getQuizQuestionsUseCase,
        submitQuizResultUseCase: submitQuizResultUseCase,
      )
    );
  }
} 