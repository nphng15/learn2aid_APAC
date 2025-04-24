import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/video_analysis.dart';

class AnalysisDetailsPage extends StatelessWidget {
  final VideoAnalysis analysis;
  
  const AnalysisDetailsPage({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Kết quả phân tích',
          style: TextStyle(
            color: Color(0xff215273),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff215273)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Điểm tổng hợp
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${analysis.score.round()}/100',
                      style: const TextStyle(
                        color: Color(0xff55c595),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Điểm tổng quan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Chi tiết điểm
            const Text(
              'Đánh giá chi tiết',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff215273),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Bảng chi tiết điểm
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Danh mục',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Điểm',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Hiển thị các hàng dựa vào scoreBreakdown
                  if (analysis.scoreBreakdown.isEmpty)
                    _buildScoreRow('Overall', '${analysis.score.round()}/100')
                  else
                    ...analysis.scoreBreakdown.entries.map((entry) => 
                      _buildScoreRow(
                        _formatCategoryName(entry.key), 
                        '${entry.value is num ? entry.value.toString() : entry.value}'
                      )
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Điểm mạnh
            const Text(
              'Điểm mạnh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff215273),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Danh sách điểm mạnh
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: analysis.strengths.isEmpty
                ? _buildBulletPoint(analysis.analysis)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: analysis.strengths.map((strength) => _buildBulletPoint(strength)).toList(),
                  ),
            ),
            
            const SizedBox(height: 30),
            
            // Cần cải thiện
            if (analysis.improvements.isNotEmpty) ...[
              const Text(
                'Điểm cần cải thiện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff215273),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Danh sách điểm cần cải thiện trong container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: analysis.improvements.map((improvement) => _buildBulletPoint(improvement)).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildScoreRow(String category, String score) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              score,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff55c595),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ', 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
              color: Color(0xff55c595)
            )
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14, 
                height: 1.5,
                color: Color(0xff333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatCategoryName(String category) {
    Map<String, String> categoryTranslations = {
      'hand_position': 'Vị trí tay',
      'compression_depth': 'Độ sâu ép tim',
      'compression_rate': 'Tốc độ ép tim',
      'body_posture': 'Tư thế cơ thể',
      'arm_position': 'Vị trí cánh tay',
      'elbow_angle': 'Góc khuỷu tay',
      'hand_placement': 'Vị trí đặt tay',
      'chest_recoil': 'Hồi phục lồng ngực',
      'rhythm': 'Nhịp điệu',
      'overall': 'Tổng thể',
      'technique': 'Kỹ thuật',
      'form': 'Hình thức',
      'consistency': 'Tính nhất quán',
      'effectiveness': 'Hiệu quả',
      'speed': 'Tốc độ',
      'posture': 'Tư thế',
      'stability': 'Độ ổn định',
      'breathing': 'Hơi thở',
      'offline_mode': 'Chế độ ngoại tuyến'
    };
    
    // Trả về bản dịch nếu có, nếu không thì định dạng chuỗi gốc
    if (categoryTranslations.containsKey(category.toLowerCase())) {
      return categoryTranslations[category.toLowerCase()]!;
    }
    
    // Nếu không có bản dịch, định dạng theo cách thông thường
    return category
      .split('_')
      .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
  }
} 