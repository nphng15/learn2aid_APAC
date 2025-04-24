import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required String id,
    required String text,
    required List<String> options,
    required int correctOption,
    String? imageUrl,
  }) : super(
          id: id,
          text: text,
          options: options,
          correctOption: correctOption,
          imageUrl: imageUrl,
        );

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      text: data['text'] ?? 'No question text',
      options: List<String>.from(data['options'] ?? []),
      correctOption: int.tryParse(data['answer']?.toString() ?? '0') ?? 0,
      imageUrl: data['imageUrl'] ?? data['imageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options,
      'answer': correctOption,
      'imageURL': imageUrl,
    };
  }
} 