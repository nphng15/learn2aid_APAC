import '../entities/question_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  final QuizRepository repository;

  GetQuizQuestionsUseCase(this.repository);

  Future<List<QuestionEntity>> execute(String quizId) {
    return repository.getQuestionsForQuiz(quizId);
  }
} 