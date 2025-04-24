import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn2aid/features/data/models/feedback_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedback(FeedbackModel feedback);
  Future<List<FeedbackModel>> getFeedbacks();
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final FirebaseFirestore _firestore;

  FeedbackRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<FeedbackModel>> getFeedbacks() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('feedbacks')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FeedbackModel.fromJson({'id': doc.id, ...data});
          })
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy phản hồi: $e');
    }
  }

  @override
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await _firestore.collection('feedbacks').add(feedback.toJson());
    } catch (e) {
      throw Exception('Lỗi khi gửi phản hồi: $e');
    }
  }
} 