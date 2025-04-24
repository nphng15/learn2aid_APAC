class FeedbackEntity {
  final String id;
  final String userId;
  final String message;
  final DateTime createdAt;
  final double rating;
  final String email;
  final String? name;

  FeedbackEntity({
    required this.id,
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.rating,
    required this.email,
    this.name,
  });
} 