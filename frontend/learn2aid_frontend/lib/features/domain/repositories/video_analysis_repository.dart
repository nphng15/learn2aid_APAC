import 'dart:io';
import '../entities/video_analysis.dart';

abstract class VideoAnalysisRepository {
  // Tải video lên và nhận phân tích từ backend
  // [videoFile] - File video cần phân tích
  // [movementType] - Loại động tác cần phân tích (ví dụ: cpr, recovery_position, ...)
  Future<VideoAnalysis> analyzeVideo(File videoFile, {String movementType = 'cpr'});
  
  // // Lưu kết quả phân tích vào local hoặc cloud storage
  // Future<bool> saveAnalysisResult(VideoAnalysis analysis);
  
  // // Lấy lịch sử phân tích video
  // Future<List<VideoAnalysis>> getAnalysisHistory();
} 