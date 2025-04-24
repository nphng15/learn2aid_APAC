import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn2aid/config/routes/app_routes.dart';
import 'package:learn2aid/config/theme/app_color.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginCtrl = Get.find<LoginController>(); // Gọi LoginController
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background
            Container(
              width: screenWidth,
              height: screenHeight,
              color: AppColors.backgroundBlue,
            ),

            // White box
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

            // Title
            Positioned(
              top: 0.315 * screenHeight,
              left: 0.125 * screenWidth,
              child: Text(
                'Login',
                style: GoogleFonts.lexend(
                  fontSize: 0.043 * screenHeight,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),

            // Login Form
            Positioned(
              top: 0.442 * screenHeight,
              left: 0.047 * screenWidth,
              child: LoginForm(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),

            // Social login note
            Positioned(
              top: 0.7768 * screenHeight,
              left: 0.3784 * screenWidth,
              child: Text(
                '- Or login with -',
                style: GoogleFonts.lexend(
                  fontSize: 14 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
              ),
            ),

            // Social buttons (Google, Facebook, Apple)
            Positioned(
              top: 0.8261 * screenHeight,
              left: 0.172 * screenWidth,
              child: Row(
                children: [
                  _socialButton(screenWidth, screenHeight, Image.asset('lib/assets/apple-logo.png'), () => print("Apple Login")),
                  SizedBox(width: 0.038 * screenWidth),
                  _socialButton(screenWidth, screenHeight, Image.asset('lib/assets/facebook-logo.png'), () => print("Facebook Login")),
                  SizedBox(width: 0.038 * screenWidth),
                  _socialButton(screenWidth, screenHeight, Image.asset('lib/assets/google-logo.png'), loginCtrl.loginWithGoogle),
                ],
              ),
            ),

            // Register link
            Positioned(
              top: 0.9214 * screenHeight,
              left: 0.2364 * screenWidth,
              child: Row(
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: GoogleFonts.lexend(
                      fontSize: 14 / 932 * screenHeight,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(AppRoutes.register);
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.lexend(
                        fontSize: 14 / 932 * screenHeight,
                        color: AppColors.secondary,
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

  // Social login button (dynamic)
  Widget _socialButton(double screenWidth, double screenHeight, Image icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.189 * screenWidth,
        height: 0.0429 * screenHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.grey4,
            width: 0.5,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 0.025 * screenHeight,
            height: 0.025 * screenHeight,
            child: icon,
          ),
        ),
      ),
    );
  }
}
