import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../features/data/models/video_model.dart';
import '../../../global_widgets/dashboard_navbar.dart';
import '../controllers/lesson_controller.dart';
import '../../dashboard/controllers/video_controller.dart';
import '../widgets/lesson_header.dart';
import '../widgets/lesson_content.dart';
import '../widgets/lesson_interactive.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final LessonController _lessonController;
  
  @override
  void initState() {
    super.initState();
    _lessonController = Get.find<LessonController>();
    
    // Initialize TabController with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
    
    // Listen for tab change events
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Only update when tab actually changes
        final tabNames = ['content', 'session'];
        final tabName = tabNames[_tabController.index];
        _lessonController.onTabChanged(tabName);
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VideoController videoController = Get.find<VideoController>();
    final VideoModel? video = Get.arguments?['video'] ?? videoController.selectedVideo.value;

    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: LessonHeader(),
                ),
              ],
            ),
            
            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xff215273),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xff215273),
              tabs: const [
                Tab(text: 'Content'),
                Tab(text: 'Practice'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Tab 1: Information and video viewing
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        video != null 
                            ? LessonContent(
                                imageUrl: video.thumbnailUrl,
                                description: video.description,
                                durationInSeconds: video.durationInSeconds,
                                title: video.title,
                                category: video.category,
                                videoId: video.id,
                                videoUrl: video.videoUrl,
                                videoController: videoController,
                              )
                            : const LessonContent(),
                      ],
                    ),
                  ),
                  
                  // Tab 2: Interactive video
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LessonInteractive(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const DashboardNavBar(),
          ],
        ),
      ),
    );
  }
}
