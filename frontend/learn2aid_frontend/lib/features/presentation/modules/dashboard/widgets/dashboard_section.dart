import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../features/data/models/video_model.dart';
import '../controllers/video_controller.dart';
import 'dashboard_card.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final String sectionType; // "for_you", "in_progress", "completed", "custom"
  final List<VideoModel>? customVideos;

  const DashboardSection({
    super.key, 
    required this.title,
    this.sectionType = "for_you",
    this.customVideos,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; 
    final VideoController videoController = Get.find<VideoController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề section
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontFamily: 'Lexend'),
          ),
          const SizedBox(height: 8),
          
          // Nội dung video
          Obx(() {
            // Chọn danh sách video dựa vào loại section
            List<VideoModel> videos;
            bool isLoading = videoController.isLoading.value;
            
            if (sectionType == "for_you") {
              videos = videoController.forYouVideos;
            } else if (sectionType == "in_progress") {
              videos = videoController.inProgressVideos;
            } else if (sectionType == "completed") {
              videos = videoController.completedVideos;
            } else {
              videos = customVideos ?? [];
              isLoading = false;
            }
            
            // Hiển thị loading nếu đang tải
            if (isLoading) {
              return SizedBox(
                height: cardWidth * 1.2,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            // Hiển thị thông báo nếu không có video
            if (videos.isEmpty) {
              return SizedBox(
                height: cardWidth * 1.2,
                child: Center(
                  child: Text(
                    sectionType == "for_you"
                        ? 'Không có video nào phù hợp'
                        : sectionType == "in_progress"
                            ? 'Bạn chưa xem video nào'
                            : sectionType == "completed"
                                ? 'Bạn chưa hoàn thành video nào'
                                : 'Không có video',
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
            
            // Hiển thị danh sách video
            return SizedBox(
              height: cardWidth * 1.2,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: videos.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return DashboardCard(
                    cardWidth: cardWidth,
                    video: videos[index],
                    videoController: videoController,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
