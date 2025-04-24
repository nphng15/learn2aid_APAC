import '../entities/video_analysis.dart';
import '../repositories/video_analysis_repository.dart';

class SaveAnalysisResultUseCase {
  final VideoAnalysisRepository repository;

  SaveAnalysisResultUseCase(this.repository);

  // Future<bool> execute(VideoAnalysis analysis) {
  //   return repository.saveAnalysisResult(analysis);
  // }
} 