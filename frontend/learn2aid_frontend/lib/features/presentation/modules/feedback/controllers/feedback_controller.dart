import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:learn2aid/features/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:learn2aid/features/data/repositories/feedback_repository_impl.dart';
import 'package:learn2aid/features/domain/entities/feedback_entity.dart';
import 'package:learn2aid/features/domain/usecases/submit_feedback_usecase.dart';

class FeedbackController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SubmitFeedbackUseCase _submitFeedbackUseCase = SubmitFeedbackUseCase(
    FeedbackRepositoryImpl(
      remoteDataSource: FeedbackRemoteDataSourceImpl(),
    ),
  );

  var isLoading = false.obs;
  var error = ''.obs;
  var rating = 0.0.obs;
  
  Future<void> submitFeedback({
    required String message,
    required double rating,
    String? name,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Kiểm tra người dùng đã đăng nhập
      final user = _auth.currentUser;
      if (user == null) {
        error.value = 'Bạn cần đăng nhập để gửi phản hồi';
        return;
      }

      final feedback = FeedbackEntity(
        id: '', // ID sẽ được tạo bởi Firestore
        userId: user.uid,
        message: message,
        createdAt: DateTime.now(),
        rating: rating,
        email: user.email ?? '',
        name: name ?? user.displayName,
      );

      await _submitFeedbackUseCase(feedback);
      Get.snackbar('Thành công', 'Cảm ơn bạn đã gửi phản hồi!');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Lỗi', 'Không thể gửi phản hồi: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void updateRating(double value) {
    rating.value = value;
  }
} 