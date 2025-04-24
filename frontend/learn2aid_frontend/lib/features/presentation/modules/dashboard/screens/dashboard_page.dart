import 'package:flutter/material.dart';
import '../../../global_widgets/dashboard_navbar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Recommended videos for you section
                    const DashboardSection(
                      title: "For You",
                      sectionType: "for_you",
                    ),
                    
                    // In progress videos section
                    const DashboardSection(
                      title: "In Progress",
                      sectionType: "in_progress",
                    ),
                    
                    // Completed videos section
                    const DashboardSection(
                      title: "Completed", 
                      sectionType: "completed",
                    ),
                  ],
                ),
              ),
            ),
            const DashboardNavBar(),
          ],
        ),
      ),
    );
  }
}
