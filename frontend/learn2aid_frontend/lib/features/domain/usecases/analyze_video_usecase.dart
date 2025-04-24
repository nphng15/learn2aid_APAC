import 'dart:io';
import '../entities/video_analysis.dart';
import '../repositories/video_analysis_repository.dart';

class AnalyzeVideoUseCase {
  final VideoAnalysisRepository repository;

  AnalyzeVideoUseCase(this.repository);

  Future<VideoAnalysis> execute(File videoFile, {String movementType = 'cpr'}) {
    return repository.analyzeVideo(videoFile, movementType: movementType);
  }
} 