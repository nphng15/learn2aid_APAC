import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/event_entity.dart';

abstract class EventRemoteDataSource {
  /// Lấy danh sách tất cả sự kiện từ Firestore
  Future<List<Event>> getEvents();

  Future<bool> joinEvent(String eventId, String userId);

  Future<bool> hasUserJoinedEvent(String eventId, String userId);

  Future<bool> cancelEvent(String eventId, String userId);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final FirebaseFirestore _firestore;
  
  EventRemoteDataSourceImpl(this._firestore);
  
  @override
  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      
      final eventsList = snapshot.docs
          .map((doc) => Event.fromFirestore(doc))
          .toList();
      
      // Sắp xếp theo thời gian sự kiện, gần nhất trước
      eventsList.sort((a, b) => a.date.compareTo(b.date));
      
      return eventsList;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      // Lấy document hiện tại
      final docRef = _firestore.collection('events').doc(eventId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        return false;
      }
      
      // Lấy danh sách joinedUsers hiện tại
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> currentJoinedUsers = data['joinedUsers'] ?? [];
      
      // Kiểm tra xem user đã tham gia chưa
      if (currentJoinedUsers.contains(userId)) {
        return false;
      }
      
      // Thêm user vào danh sách
      final updatedJoinedUsers = [...currentJoinedUsers, userId];
      
      // Cập nhật Firestore
      await docRef.update({
        'joinedUsers': updatedJoinedUsers,
      });
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> hasUserJoinedEvent(String eventId, String userId) async {
    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      
      if (!doc.exists) {
        return false;
      }
      
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> joinedUsers = data['joinedUsers'] ?? [];
      
      return joinedUsers.contains(userId);
    } catch (e) {
      print('Lỗi khi kiểm tra trạng thái tham gia: $e');
      return false;
    }
  }

  @override
  Future<bool> cancelEvent(String eventId, String userId) async {
    try {
      // Lấy document hiện tại
      final docRef = _firestore.collection('events').doc(eventId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        return false;
      }
      
      // Lấy danh sách joinedUsers hiện tại
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> currentJoinedUsers = data['joinedUsers'] ?? [];
      
      // Kiểm tra xem user đã tham gia chưa
      if (!currentJoinedUsers.contains(userId)) {
        return false;
      }
      
      // Xóa user khỏi danh sách
      final updatedJoinedUsers = currentJoinedUsers.where((id) => id != userId).toList();
      
      // Cập nhật Firestore
      await docRef.update({
        'joinedUsers': updatedJoinedUsers,
      });
      
      return true;
    } catch (e) {
      return false;
    }
  }
} 