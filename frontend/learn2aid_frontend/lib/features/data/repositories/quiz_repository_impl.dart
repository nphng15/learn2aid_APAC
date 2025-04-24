import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../../../core/error/exceptions.dart';
import '../datasources/remote/quiz_remote_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<QuizEntity>> getQuizzes() async {
    try {
      return await remoteDataSource.getQuizzes();
    } catch (e) {
      throw QuizException('Lỗi khi tải danh sách quiz: $e');
    }
  }

  @override
  Future<QuizEntity?> getQuizById(String id) async {
    try {
      return await remoteDataSource.getQuizById(id);
    } catch (e) {
      if (e is NotFoundException) {
        return null;
      }
      throw QuizException('Lỗi khi tải quiz: $e');
    }
  }

  @override
  Future<List<QuestionEntity>> getQuestionsForQuiz(String quizId) async {
    try {
      return await remoteDataSource.getQuestionsForQuiz(quizId);
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
      await remoteDataSource.submitQuizResult(
        userId: userId,
        userName: userName,
        quizId: quizId,
        quizTitle: quizTitle,
        score: score,
        totalQuestions: totalQuestions,
        answers: answers,
        timeSpent: timeSpent,
      );
    } catch (e) {
      if (e is InvalidDataException) {
        throw e;
      }
      throw QuizException('Lỗi khi nộp kết quả: $e');
    }
  }
} 