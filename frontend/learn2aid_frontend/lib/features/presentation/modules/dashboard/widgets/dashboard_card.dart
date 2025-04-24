import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../features/data/models/video_model.dart';
import '../controllers/video_controller.dart';
import '../../lesson/screens/lesson_page.dart';

class DashboardCard extends StatelessWidget {
  final double cardWidth;
  final VideoModel? video;
  final VideoController? videoController;
  
  const DashboardCard({
    super.key, 
    required this.cardWidth,
    this.video,
    this.videoController,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu không có video, trả về card rỗng
    if (video == null) {
      return Container(
        width: cardWidth,
        height: cardWidth * 1.2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xff215273), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }
    
    // Nếu có video, hiển thị thông tin video
    return GestureDetector(
      onTap: () {
        if (videoController != null) {
          // Lưu video đang được chọn vào controller
          videoController!.setSelectedVideo(video!);
          
          Get.toNamed('/lesson', arguments: {
            'video': video,
          });
          
          videoController!.addToInProgress(video!.id);
        }
      },
      child: Container(
        width: cardWidth,
        height: cardWidth * 1.2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xff215273), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Stack(
                children: [
                  // Hình nền video
                  Image.network(
                    video!.thumbnailUrl,
                    width: cardWidth,
                    height: cardWidth * 0.6,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: cardWidth,
                      height: cardWidth * 0.6,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.error),
                    ),
                  ),
                  // Thời lượng video
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video!.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video information
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    video!.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Description
                  Text(
                    video!.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontFamily: 'Lexend',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Danh mục
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff215273),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      video!.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Lexend',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
