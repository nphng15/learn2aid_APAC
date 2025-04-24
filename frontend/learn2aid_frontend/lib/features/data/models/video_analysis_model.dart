import '../../domain/entities/video_analysis.dart';

class VideoAnalysisModel extends VideoAnalysis {
  VideoAnalysisModel({
    required String id,
    required String analysis, 
    required double score,
    required List<String> strengths,
    required List<String> improvements,
    required Map<String, dynamic> scoreBreakdown,
    required DateTime createdAt,
  }) : super(
    id: id,
    analysis: analysis,
    score: score,
    strengths: strengths,
    improvements: improvements,
    scoreBreakdown: scoreBreakdown,
    createdAt: createdAt,
  );

  factory VideoAnalysisModel.fromJson(Map<String, dynamic> json) {
    // Lấy điểm tổng
    double scoreValue = 0.0;
    if (json['total_point'] != null) {
      try {
        if (json['total_point'] is String) {
          // Nếu là chuỗi có định dạng "X/100", tách lấy phần số trước dấu "/"
          if (json['total_point'].toString().contains('/')) {
            scoreValue = double.tryParse(json['total_point'].toString().split('/').first) ?? 0.0;
          } else {
            scoreValue = double.tryParse(json['total_point']) ?? 0.0;
          }
        } else {
          scoreValue = (json['total_point'] as num).toDouble();
        }
      } catch (e) {
        print('Lỗi khi chuyển đổi điểm thành số: $e');
      }
    }

    // Lấy phân tích chi tiết
    final detailedSummary = json['detailed_summary'] ?? {};
    
    // Comment (phân tích chung) - sử dụng nếu có, nếu không thì dùng text mặc định
    String analysisText = 'Hiện hệ thống tạm ngưng do không hoạt động trong thời gian dài. Vui lòng chờ khoảng 5 phút rồi thử tải video lên lại. Cảm ơn bạn!';
    if (detailedSummary['comment'] != null) {
      analysisText = detailedSummary['comment'];
    }
    
    // Lấy điểm mạnh
    List<String> strengths = [];
    if (detailedSummary['strengths'] != null) {
      strengths = List<String>.from(detailedSummary['strengths']);
    }
    
    // Lấy điểm cần cải thiện
    List<String> improvements = [];
    if (detailedSummary['areas_for_improvement'] != null) {
      improvements = List<String>.from(detailedSummary['areas_for_improvement']);
    }
    
    // Lấy phân tích điểm theo từng danh mục
    Map<String, dynamic> scoreBreakdown = {};
    if (detailedSummary['score_breakdown'] != null) {
      scoreBreakdown = Map<String, dynamic>.from(detailedSummary['score_breakdown']);
    }

    return VideoAnalysisModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      analysis: analysisText,
      score: scoreValue,
      strengths: strengths,
      improvements: improvements,
      scoreBreakdown: scoreBreakdown,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'analysis': analysis,
      'score': score,
      'strengths': strengths,
      'improvements': improvements,
      'scoreBreakdown': scoreBreakdown,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 