import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizzesUseCase {
  final QuizRepository repository;

  GetQuizzesUseCase(this.repository);

  Future<List<QuizEntity>> execute() {
    return repository.getQuizzes();
  }
} 