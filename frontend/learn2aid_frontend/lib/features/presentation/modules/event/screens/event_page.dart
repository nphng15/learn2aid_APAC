import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../global_widgets/dashboard_navbar.dart';
import '../event_controller.dart';
import '../widgets/event_item.dart';
import '../../../../../config/theme/app_color.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Center(
                    child: Text(
                      'Sự kiện',
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.events.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => controller.fetchEvents(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          color: Colors.grey,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không có sự kiện nào',
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hiện chưa có sự kiện nào được tổ chức',
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => controller.fetchEvents(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Làm mới'),
                        ),
                      ],
                    ),
                  );
                }

                // Danh sách sự kiện
                return RefreshIndicator(
                  onRefresh: controller.fetchEvents,
                  color: AppColors.secondary,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final event = controller.events[index];
                      return EventItem(
                        event: event,
                        controller: controller,
                      );
                    },
                  ),
                );
              }),
            ),

            // Bottom navigation bar
            const DashboardNavBar(),
          ],
        ),
      ),
    );
  }
} 