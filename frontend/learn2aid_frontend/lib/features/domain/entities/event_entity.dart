import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final List<String> joinedUsers;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.joinedUsers,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
      joinedUsers: List<String>.from(data['joinedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'joinedUsers': joinedUsers,
    };
  }

  bool hasUserJoined(String userId) {
    return joinedUsers.contains(userId);
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    String? imageUrl,
    List<String>? joinedUsers,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      joinedUsers: joinedUsers ?? this.joinedUsers,
    );
  }
} 