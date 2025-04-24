import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../features/domain/entities/event_entity.dart';
import '../event_controller.dart';
import '../../../../../config/theme/app_color.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final EventController controller;

  const EventItem({
    Key? key,
    required this.event,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasUserJoined = controller.hasUserJoinedEvent(event);
    final formattedDate = controller.formatDateTime(event.date);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                event.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.grey3),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: GoogleFonts.lexend(color: AppColors.grey3, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.grey3),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: GoogleFonts.lexend(color: AppColors.grey3, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Mô tả ngắn
                Text(
                  event.description,
                  style: GoogleFonts.lexend(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Số người tham gia và nút tham gia
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Số người tham gia
                    Text(
                      '${event.joinedUsers.length} người đăng ký',
                      style: GoogleFonts.lexend(
                        color: AppColors.grey3,
                        fontSize: 14,
                      ),
                    ),

                    // Nút tham gia
                    Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.joinEvent(event),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasUserJoined ? Colors.red : AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              hasUserJoined ? 'Hủy đăng ký' : 'Đăng ký',
                              style: GoogleFonts.lexend(),
                            ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 