import 'dart:io';
import 'dart:async';

import '../../domain/repositories/video_analysis_repository.dart';
import '../../domain/entities/video_analysis.dart';
import '../datasources/remote/video_analysis_remote_datasource.dart';
import '../../../core/error/exceptions.dart';

class VideoAnalysisRepositoryImpl implements VideoAnalysisRepository {
  final VideoAnalysisRemoteDataSource remoteDataSource;
  
  VideoAnalysisRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<VideoAnalysis> analyzeVideo(File videoFile, {String movementType = 'cpr'}) async {
    try {
      // Chuyển xử lý video cho remote data source
      final result = await remoteDataSource.analyzeVideo(
        videoFile, 
        movementType: movementType
      );
      
      return result;
    } catch (e) {
      if (e is TimeoutException) {
        throw TimeoutException('Phân tích video tốn quá nhiều thời gian');
      } else if (e is NetworkException) {
        throw NetworkException('Lỗi kết nối: ${e.message}');
      } else {
        throw VideoAnalysisException('Lỗi khi phân tích video: $e');
      }
    }
  }
} 