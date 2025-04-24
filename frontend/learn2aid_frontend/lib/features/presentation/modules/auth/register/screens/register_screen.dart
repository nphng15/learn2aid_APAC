import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn2aid/config/routes/app_routes.dart';
import '../../../../../../config/theme/app_color.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get device size to scale
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Blue background
            Container(
              width: screenWidth,
              height: screenHeight,
              color: const Color(0xFF71C5FF),
            ),

            // White box with round corners
            Positioned(
              top: 0.257 * screenHeight, 
              left: 0,
              child: Container(
                width: 1.017 * screenWidth,
                height: 0.742 * screenHeight,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.043 * screenHeight),
                    topRight: Radius.circular(0.043 * screenHeight),
                  ),
                ),
              ),
            ),

            // "Register" title
            Positioned(
              top: 0.35 * screenHeight, 
              left: 0.125 * screenWidth,
              child: Text(
                'Register',
                style: GoogleFonts.lexend(
                  fontSize: 0.043 * screenHeight,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),

            // "Back to login" link + icon
            // We put it near top-left
            Positioned(
              top: 0.308 * screenHeight,
              left: 0.125 * screenWidth,
              child: GestureDetector(
                onTap: () {
                  Get.offNamed(AppRoutes.login);
                },
                child: Row(
                  children: [
                    // Icon or image
                    Icon(Icons.redo),
                    const SizedBox(width: 4),
                    Text(
                      'Back to login',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        color: const Color(0xFF215273),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // The RegisterForm
            // Positioned a bit lower for the fields
            Positioned(
              top: 0.44 * screenHeight, 
              left: 0.047 * screenWidth,
              child: RegisterForm(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
