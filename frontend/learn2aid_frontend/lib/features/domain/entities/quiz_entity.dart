class QuizEntity {
  final String id;
  final String title;
  final String description;
  final int timeLimit;
  final int totalQuestions;

  QuizEntity({
    required this.id,
    required this.title,
    required this.description,
    this.timeLimit = 10,
    this.totalQuestions = 0,
  });
} 