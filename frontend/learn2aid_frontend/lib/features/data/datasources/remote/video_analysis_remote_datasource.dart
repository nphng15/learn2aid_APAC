import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;

import '../../../domain/entities/video_analysis.dart';
import '../../models/video_analysis_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class VideoAnalysisRemoteDataSource {
  /// Gửi video lên API server để phân tích
  /// Trả về [VideoAnalysisModel] nếu thành công
  /// Throws [NetworkException] nếu có lỗi kết nối
  /// Throws [VideoAnalysisException] nếu có lỗi xử lý
  Future<VideoAnalysisModel> analyzeVideo(File videoFile, {String movementType = 'cpr'});
}

class VideoAnalysisRemoteDataSourceImpl implements VideoAnalysisRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  VideoAnalysisRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://learn2aid-ai-service.onrender.com'
  });

  @override
  Future<VideoAnalysisModel> analyzeVideo(File videoFile, {String movementType = 'cpr'}) async {
    try {
      // Kết nối với API endpoint predict của backend
      final uri = Uri.parse('$baseUrl/predict');
      
      var request = http.MultipartRequest('POST', uri);
      
      final fileName = path.basename(videoFile.path);
      
      // Thêm file video vào request
      request.files.add(
        await http.MultipartFile.fromPath('file', videoFile.path, filename: fileName),
      );
      
      // Thêm tham số movement_name từ movementType được chọn
      request.fields['movement_name'] = movementType;
      
      try {
        final streamedResponse = await request.send();
        
        final response = await http.Response.fromStream(streamedResponse);
        
        if (response.statusCode == 200) {
          final decodedBody = utf8.decode(response.bodyBytes);  
          final jsonData = json.decode(decodedBody);
          
          print('API Response: $jsonData');
          // Chuyển đổi dữ liệu JSON sang VideoAnalysis thông qua VideoAnalysisModel
          return VideoAnalysisModel.fromJson(jsonData);
        } else {
          
          try {
            final errorData = json.decode(response.body);
            final errorMessage = errorData['error'] ?? 'Lỗi máy chủ không xác định';

            return _getFallbackAnalysis('Lỗi máy chủ: $errorMessage');
          } catch (e) {
            // Nếu không phải JSON, trả về lỗi HTTP
            return _getFallbackAnalysis('Lỗi HTTP: ${response.statusCode}');
          }
        }
      } catch (connError) {
        if (connError is TimeoutException) {
          throw connError;
        } else {
          throw NetworkException('Không thể kết nối đến máy chủ: $connError');
        }
      }
    } catch (e) {  
      if (e is TimeoutException || e is NetworkException) {
        throw e;
      } else {
        throw VideoAnalysisException('Lỗi xử lý video: $e');
      }
    }
  }
  
  // Tạo phân tích mẫu khi có lỗi
  VideoAnalysisModel _getFallbackAnalysis(String errorMessage) {
    return VideoAnalysisModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      analysis: 'Phân tích offline',
      score: 0.0,
      strengths: ['Chế độ ngoại tuyến vẫn hoạt động'],
      improvements: [
        'Kiểm tra kết nối mạng của bạn',
        'Thử lại sau vài phút'
      ],
      scoreBreakdown: {
        'offline_mode': 0.0,
      },
      createdAt: DateTime.now(),
    );
  }
} 