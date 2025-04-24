import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../../dashboard/controllers/video_controller.dart';
import './video_popup_player.dart';

class LessonContent extends StatelessWidget {
  final String imageUrl;
  final String description;
  final int durationInSeconds;
  final String title;
  final String category;
  final String videoId;
  final String videoUrl;
  final VideoController? videoController;
  
  const LessonContent({
    super.key,
    this.imageUrl = '',
    this.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                       'Nullam tristique eros nec diam consectetur gravida. Nulla facilisi. '
                       'Vestibulum malesuada nisl tortor, tincidunt pulvinar massa lacinia ut.',
    this.durationInSeconds = 120,
    this.title = 'Video Title',
    this.category = 'Category',
    this.videoId = '',
    this.videoUrl = '',
    this.videoController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center, 
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.55, // Reduced height from 0.58 to 0.55
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xff215273), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Image section - reduced flex to make it about 1/3 of the card
              Expanded(
                flex: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: imageUrl.isNotEmpty 
                              ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: const Color.fromRGBO(217, 217, 217, 1),
                        ),
                      ),
                    ),
                    // Display category in the bottom left corner over the video
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff215273),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Description section - increased flex to show more content
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lexend',
                          ),
                        ),
                        Text(
                          '${(durationInSeconds / 60).floor()} minutes',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Lexend',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Nunito Sans',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Watch video button
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (videoUrl.isNotEmpty && videoController != null) {
                            // Show popup video player instead of opening browser
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => VideoPopupPlayer(
                                videoUrl: videoUrl,
                                title: title,
                                videoId: videoId,
                                onProgressUpdate: (id, progress) {
                                  videoController!.updateVideoProgress(id, progress);
                                },
                              ),
                            );
                            
                            // Update video being watched
                            videoController!.addToInProgress(videoId);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff55c595),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Watch Video',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
