class QuestionEntity {
  final String id;
  final String text;
  final List<String> options;
  final int correctOption;
  final String? imageUrl;

  QuestionEntity({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOption,
    this.imageUrl,
  });
} 