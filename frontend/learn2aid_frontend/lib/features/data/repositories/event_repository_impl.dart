import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/remote/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource _remoteDataSource;
  
  EventRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<Event>> getEvents() async {
    try {
      return await _remoteDataSource.getEvents();
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      return await _remoteDataSource.joinEvent(eventId, userId);
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> hasUserJoinedEvent(String eventId, String userId) async {
    try {
      return await _remoteDataSource.hasUserJoinedEvent(eventId, userId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelEvent(String eventId, String userId) async {
    try {
      return await _remoteDataSource.cancelEvent(eventId, userId);
    } catch (e) {
      return false;
    }
  }
} 