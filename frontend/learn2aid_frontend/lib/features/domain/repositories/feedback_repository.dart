import '../entities/feedback_entity.dart';

abstract class FeedbackRepository {
  Future<void> submitFeedback(FeedbackEntity feedback);
  Future<List<FeedbackEntity>> getFeedbacks();
} 