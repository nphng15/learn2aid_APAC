import 'package:learn2aid/features/domain/entities/feedback_entity.dart';
import 'package:learn2aid/features/domain/repositories/feedback_repository.dart';

class SubmitFeedbackUseCase {
  final FeedbackRepository repository;

  SubmitFeedbackUseCase(this.repository);

  Future<void> call(FeedbackEntity feedback) async {
    return await repository.submitFeedback(feedback);
  }
} 