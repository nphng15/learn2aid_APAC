import 'package:learn2aid/features/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:learn2aid/features/data/models/feedback_model.dart';
import 'package:learn2aid/features/domain/entities/feedback_entity.dart';
import 'package:learn2aid/features/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FeedbackEntity>> getFeedbacks() async {
    try {
      final feedbacks = await remoteDataSource.getFeedbacks();
      return feedbacks;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> submitFeedback(FeedbackEntity feedback) async {
    try {
      await remoteDataSource.submitFeedback(FeedbackModel.fromEntity(feedback));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
} 