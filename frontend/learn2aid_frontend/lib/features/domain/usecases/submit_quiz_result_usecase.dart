import '../repositories/quiz_repository.dart';

class SubmitQuizResultUseCase {
  final QuizRepository repository;

  SubmitQuizResultUseCase(this.repository);

  Future<void> execute({
    required String userId,
    required String userName,
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required List<int> answers,
    required int timeSpent,
  }) {
    return repository.submitQuizResult(
      userId: userId,
      userName: userName,
      quizId: quizId,
      quizTitle: quizTitle,
      score: score,
      totalQuestions: totalQuestions,
      answers: answers,
      timeSpent: timeSpent,
    );
  }
} 