import '../entities/quiz_entity.dart';
import '../entities/question_entity.dart';

abstract class QuizRepository {
  Future<List<QuizEntity>> getQuizzes();
  Future<QuizEntity?> getQuizById(String id);
  Future<List<QuestionEntity>> getQuestionsForQuiz(String quizId);
  Future<void> submitQuizResult({
    required String userId,
    required String userName,
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required List<int> answers,
    required int timeSpent,
  });
} 