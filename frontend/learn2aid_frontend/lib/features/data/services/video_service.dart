import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';

class VideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả video
  Future<List<VideoModel>> getAllVideos() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('aid_videos')
          .orderBy('created', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return VideoModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error getting videos: $e');
      return [];
    }
  }

  // Lấy video theo danh mục
  Future<List<VideoModel>> getVideosByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('aid_videos')
          .where('category', isEqualTo: category)
          .get();
      
      return snapshot.docs.map((doc) {
        return VideoModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error getting videos by category: $e');
      return [];
    }
  }
} 