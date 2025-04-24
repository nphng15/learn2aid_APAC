import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn2aid/features/domain/entities/feedback_entity.dart';

class FeedbackModel extends FeedbackEntity {
  FeedbackModel({
    required String id,
    required String userId,
    required String message,
    required DateTime createdAt,
    required double rating,
    required String email,
    String? name,
  }) : super(
          id: id,
          userId: userId,
          message: message,
          createdAt: createdAt,
          rating: rating,
          email: email,
          name: name,
        );

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      rating: (json['rating'] as num).toDouble(),
      email: json['email'] ?? '',
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'rating': rating,
      'email': email,
      'name': name,
    };
  }

  factory FeedbackModel.fromEntity(FeedbackEntity entity) {
    return FeedbackModel(
      id: entity.id,
      userId: entity.userId,
      message: entity.message,
      createdAt: entity.createdAt,
      rating: entity.rating,
      email: entity.email,
      name: entity.name,
    );
  }
} 