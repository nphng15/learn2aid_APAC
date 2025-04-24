import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/theme/app_color.dart';
import '../../../../../../config/routes/app_routes.dart';
import '../profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20 / 932 * screenHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Obx(() => CircleAvatar(
                radius: 50,
                backgroundImage: profileController.userPhotoUrl.value.isNotEmpty
                    ? NetworkImage(profileController.userPhotoUrl.value)
                    : null,
                child: profileController.userPhotoUrl.value.isEmpty
                    ? const Icon(Icons.person, size: 50, color: AppColors.secondary)
                    : null,
              )),
              
              SizedBox(height: 20 / 932 * screenHeight),
              
              // User name
              Obx(() => Text(
                profileController.userName.value,
                style: GoogleFonts.lexend(
                  fontSize: 24 / 932 * screenHeight,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              )),
              
              SizedBox(height: 10 / 932 * screenHeight),
              
              // Email
              Obx(() => Text(
                profileController.userEmail.value,
                style: GoogleFonts.lexend(
                  fontSize: 16 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
              )),
              
              SizedBox(height: 40 / 932 * screenHeight),
              
              // Other information can be added here
              
              // Send feedback button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.feedback),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 15 / 932 * screenHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send Feedback',
                    style: GoogleFonts.lexend(
                      fontSize: 16 / 932 * screenHeight,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16 / 932 * screenHeight),
              
              // Clear local data button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showClearDataConfirmation(context, profileController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15 / 932 * screenHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Clear Local Data',
                    style: GoogleFonts.lexend(
                      fontSize: 16 / 932 * screenHeight,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16 / 932 * screenHeight),
              
              // Log out button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => profileController.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: EdgeInsets.symmetric(vertical: 15 / 932 * screenHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.lexend(
                      fontSize: 16 / 932 * screenHeight,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Show data deletion confirmation dialog
  void _showClearDataConfirmation(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Data Deletion'),
        content: const Text(
          'Are you sure you want to delete all locally saved data? '
          'Your video watching progress, completed and in-progress video lists will be deleted. '
          'This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.clearLocalData();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 