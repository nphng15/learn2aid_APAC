class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String category;
  final int duration;
  final String uploadedBy;
  final String uploaderName;
  final bool completed;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.duration,
    required this.uploadedBy,
    required this.uploaderName,
    this.completed = false,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map, String id) {
    return VideoModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      category: map['category'] ?? '',
      duration: map['duration'] ?? 0,
      uploadedBy: map['uploadedBy'] ?? '',
      uploaderName: map['uploaderName'] ?? '',
      completed: map['completed'] ?? false,
    );
  }

  String get formattedDuration {
    final minutes = (duration / 60).floor();
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  int get durationInSeconds {
    return duration;
  }

  VideoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? category,
    int? duration,
    String? uploadedBy,
    String? uploaderName,
    bool? completed,
  }) {
    try {
      return VideoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        videoUrl: videoUrl ?? this.videoUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        category: category ?? this.category,
        duration: duration ?? this.duration,
        uploadedBy: uploadedBy ?? this.uploadedBy,
        uploaderName: uploaderName ?? this.uploaderName,
        completed: completed ?? this.completed,
      );
    } catch (e) {
      print('DEBUG - Lỗi trong copyWith: $e');
      // Nếu có lỗi, vẫn cần trả về một đối tượng hợp lệ
      return VideoModel(
        id: this.id,
        title: this.title,
        description: this.description,
        videoUrl: this.videoUrl,
        thumbnailUrl: this.thumbnailUrl,
        category: this.category,
        duration: this.duration,
        uploadedBy: this.uploadedBy,
        uploaderName: this.uploaderName,
        completed: completed ?? this.completed,
      );
    }
  }
} 