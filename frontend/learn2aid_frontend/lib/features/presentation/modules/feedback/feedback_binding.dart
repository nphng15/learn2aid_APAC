import 'package:get/get.dart';
import 'package:learn2aid/features/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:learn2aid/features/data/repositories/feedback_repository_impl.dart';
import 'package:learn2aid/features/domain/usecases/submit_feedback_usecase.dart';
import 'package:learn2aid/features/presentation/modules/feedback/feedback_controller.dart';

class FeedbackBinding extends Bindings {
  @override
  void dependencies() {
    // DataSource
    Get.lazyPut<FeedbackRemoteDataSource>(
      () => FeedbackRemoteDataSourceImpl(),
    );

    // Repository
    Get.lazyPut(
      () => FeedbackRepositoryImpl(
        remoteDataSource: Get.find<FeedbackRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut(
      () => SubmitFeedbackUseCase(
        Get.find<FeedbackRepositoryImpl>(),
      ),
    );

    // Controller
    Get.lazyPut(
      () => FeedbackController(
        submitFeedbackUseCase: Get.find<SubmitFeedbackUseCase>(),
      ),
    );
  }
} 