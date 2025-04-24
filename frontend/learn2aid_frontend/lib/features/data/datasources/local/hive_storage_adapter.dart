import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Enum cho các loại box trong Hive
enum HiveBoxes {
  appState,
  videoState,
  completedVideos,
  inProgressVideos,
  videoProgress
}

// Các khóa được sử dụng trong các box của Hive
class HiveKeys {
  // Keys cho AppState box
  static const String selectedCategory = 'selectedCategory';
  static const String searchQuery = 'searchQuery';
  
  // Keys cho VideoState box
  static const String selectedVideoId = 'selectedVideoId';
  static const String tempVideoPath = 'tempVideoPath';
}

/// Adapter cho Hive storage - Implementation detail thuộc về data layer
class HiveStorageAdapter {
  static final HiveStorageAdapter _instance = HiveStorageAdapter._internal();
  
  // Singleton pattern
  factory HiveStorageAdapter() {
    return _instance;
  }
  
  HiveStorageAdapter._internal();
  
  // Khởi tạo Hive
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Mở các box
    await Hive.openBox<dynamic>(HiveBoxes.appState.toString());
    await Hive.openBox<dynamic>(HiveBoxes.videoState.toString());
    await Hive.openBox<String>(HiveBoxes.completedVideos.toString());
    await Hive.openBox<String>(HiveBoxes.inProgressVideos.toString());
    await Hive.openBox<double>(HiveBoxes.videoProgress.toString());
  }
  
  // Getter cho các box
  Box<dynamic> get appStateBox => Hive.box<dynamic>(HiveBoxes.appState.toString());
  Box<dynamic> get videoStateBox => Hive.box<dynamic>(HiveBoxes.videoState.toString());
  Box<String> get completedVideosBox => Hive.box<String>(HiveBoxes.completedVideos.toString());
  Box<String> get inProgressVideosBox => Hive.box<String>(HiveBoxes.inProgressVideos.toString());
  Box<double> get videoProgressBox => Hive.box<double>(HiveBoxes.videoProgress.toString());
  
  // App state methods
  Future<void> saveValue(String key, dynamic value, Box box) async {
    await box.put(key, value);
  }
  
  dynamic getValue(String key, Box box, {dynamic defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }
  
  // List methods
  Future<void> saveList<T>(List<T> items, Box<T> box) async {
    await box.clear();
    for (var item in items) {
      await box.add(item);
    }
  }
  
  List<T> getList<T>(Box<T> box) {
    return box.values.toList();
  }
  
  Future<void> addToList<T>(T item, Box<T> box) async {
    if (!box.values.contains(item)) {
      await box.add(item);
    }
  }
  
  // File methods
  Future<void> deleteFile(String? path) async {
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
} 