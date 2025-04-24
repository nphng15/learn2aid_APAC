import '../entities/event_entity.dart';

abstract class EventRepository {

  Future<List<Event>> getEvents();

  Future<bool> joinEvent(String eventId, String userId);

  Future<bool> hasUserJoinedEvent(String eventId, String userId);

  Future<bool> cancelEvent(String eventId, String userId);
} 