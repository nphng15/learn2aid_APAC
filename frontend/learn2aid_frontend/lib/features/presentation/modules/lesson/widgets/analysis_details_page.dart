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
          'Analysis Results',
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
            // Overall Score
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
                      'Overall Score',
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
            
            // Detailed Scores
            const Text(
              'Detailed Assessment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff215273),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Score details table
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
                            'Category',
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
                            'Score',
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
                  
                  // Display rows based on scoreBreakdown
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
            
            // Strengths
            const Text(
              'Strengths',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff215273),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Strengths list
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
            
            // Areas to improve
            if (analysis.improvements.isNotEmpty) ...[
              const Text(
                'Areas to Improve',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff215273),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // List of areas to improve in container
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
      'hand_position': 'Hand Position',
      'compression_depth': 'Compression Depth',
      'compression_rate': 'Compression Rate',
      'body_posture': 'Body Posture',
      'arm_position': 'Arm Position',
      'elbow_angle': 'Elbow Angle',
      'hand_placement': 'Hand Placement',
      'chest_recoil': 'Chest Recoil',
      'rhythm': 'Rhythm',
      'overall': 'Overall',
      'technique': 'Technique',
      'form': 'Form',
      'consistency': 'Consistency',
      'effectiveness': 'Effectiveness',
      'speed': 'Speed',
      'posture': 'Posture',
      'stability': 'Stability',
      'breathing': 'Breathing',
      'offline_mode': 'Offline Mode'
    };
    
    // Return translation if available, otherwise format the original string
    if (categoryTranslations.containsKey(category.toLowerCase())) {
      return categoryTranslations[category.toLowerCase()]!;
    }
    
    // If no translation available, format in the usual way
    return category.split('_').map((word) => 
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
  }
} 