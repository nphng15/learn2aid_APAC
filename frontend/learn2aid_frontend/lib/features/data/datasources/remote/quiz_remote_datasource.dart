import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/quiz_entity.dart';
import '../../../domain/entities/question_entity.dart';
import '../../models/quiz_model.dart';
import '../../models/question_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> getQuizzes();
  Future<QuizModel?> getQuizById(String id);
  Future<List<QuestionModel>> getQuestionsForQuiz(String quizId);
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

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final FirebaseFirestore firestore;

  QuizRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<List<QuizModel>> getQuizzes() async {
    try {
      final QuerySnapshot quizSnapshot = await firestore.collection('quizzes').get();
      
      return quizSnapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw QuizException('Lỗi khi tải danh sách quiz: $e');
    }
  }

  @override
  Future<QuizModel?> getQuizById(String id) async {
    try {
      final DocumentSnapshot quizDoc = await firestore.collection('quizzes').doc(id).get();
      
      if (!quizDoc.exists) {
        throw NotFoundException('Không tìm thấy quiz với ID: $id');
      }
      
      return QuizModel.fromFirestore(quizDoc);
    } catch (e) {
      if (e is NotFoundException) {
        return null;
      }
      throw QuizException('Lỗi khi tải quiz: $e');
    }
  }

  @override
  Future<List<QuestionModel>> getQuestionsForQuiz(String quizId) async {
    try {
      final QuerySnapshot questionSnapshot = await firestore
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .get();
      
      if (questionSnapshot.docs.isEmpty) {
        throw NotFoundException('Không tìm thấy câu hỏi cho quiz: $quizId');
      }

      return questionSnapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (e is NotFoundException) {
        throw e;
      }
      throw QuizException('Lỗi khi tải câu hỏi: $e');
    }
  }

  @override
  Future<void> submitQuizResult({
    required String userId,
    required String userName,
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required List<int> answers,
    required int timeSpent,
  }) async {
    try {
      if (userId.isEmpty || quizId.isEmpty) {
        throw InvalidDataException('Thiếu thông tin người dùng hoặc quiz');
      }
      
      await firestore.collection('quiz_results').add({
        'userId': userId,
        'userName': userName,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentageScore': (score / totalQuestions * 100).toInt(),
        'answers': answers,
        'timeSpent': timeSpent,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (e is InvalidDataException) {
        throw e;
      }
      throw QuizException('Lỗi khi nộp kết quả: $e');
    }
  }
} 