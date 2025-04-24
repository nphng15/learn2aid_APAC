import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/routes/app_routes.dart';

class DashboardNavBar extends StatelessWidget {
  const DashboardNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isOnLessonPage = Get.currentRoute == AppRoutes.lesson;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Disclaimer text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'This app is for reference and practice purposes only '
            'and does not replace official first aid training or professional medical advice.'
            'Learn and practice first aid correctly as soon as possible.',           
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Navigation bar
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xff215273), width: 1),
          ),
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navButton(
                icon: Icons.home_outlined,
                color: const Color(0xff215273),
                onTap: () => Get.offNamed(AppRoutes.dashboard),
                isActive: Get.currentRoute == AppRoutes.dashboard,
              ),
              navButton(
                icon: Icons.edit_outlined,
                color: const Color(0xff215273),
                onTap: () => Get.offNamed(AppRoutes.quiz),
                isActive: Get.currentRoute == AppRoutes.quiz,
              ),
              navButton(
                icon: Icons.event_outlined,
                color: const Color(0xff215273),
                onTap: () => Get.offNamed(AppRoutes.event),
                isActive: Get.currentRoute == AppRoutes.event,
              ),
              navButton(
                icon: Icons.person_outline,
                color: const Color(0xff215273),
                onTap: () => Get.toNamed(AppRoutes.profile),
                isActive: Get.currentRoute == AppRoutes.profile,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget navButton({
    required IconData icon, 
    required Color color, 
    required VoidCallback? onTap, 
    bool isActive = false
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff55c595) : Colors.transparent,
            borderRadius: isActive 
                ? const BorderRadius.all(Radius.circular(30)) 
                : null,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Icon(
            icon,
            color: isActive ? Colors.white : color,
            size: 26,
          ),
        ),
      ),
    );
  }
}
