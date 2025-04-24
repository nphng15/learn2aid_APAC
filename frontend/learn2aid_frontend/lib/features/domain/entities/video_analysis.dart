class VideoAnalysis {
  final String id;
  final String analysis;
  final double score;
  final List<String> strengths;
  final List<String> improvements;
  final Map<String, dynamic> scoreBreakdown;
  final DateTime createdAt;

  VideoAnalysis({
    required this.id,
    required this.analysis,
    required this.score,
    required this.strengths,
    required this.improvements,
    required this.scoreBreakdown,
    required this.createdAt,
  });
} 