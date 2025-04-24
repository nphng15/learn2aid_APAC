import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/quiz_entity.dart';

class QuizModel extends QuizEntity {
  QuizModel({
    required String id,
    required String title,
    required String description,
    int timeLimit = 10,
    int totalQuestions = 0,
  }) : super(
          id: id,
          title: title,
          description: description,
          timeLimit: timeLimit,
          totalQuestions: totalQuestions,
        );

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      title: data['title'] ?? 'Untitled Quiz',
      description: data['description'] ?? 'No description',
      timeLimit: data['timeLimit'] ?? 10,
      totalQuestions: data['totalQuestions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'timeLimit': timeLimit,
      'totalQuestions': totalQuestions,
    };
  }
} 