import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/theme/app_color.dart';
import '../login_controller.dart';

class LoginForm extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  // Sử dụng Get.find để lấy LoginController
  final loginCtrl = Get.find<LoginController>();

  LoginForm({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.905 * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email field
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: AppColors.grey2,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
                controller: loginCtrl.emailController,
                style: GoogleFonts.lexend(
                  fontSize: 16 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 0.035 * screenHeight),

          // Password field
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: AppColors.grey2,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
                controller: loginCtrl.passwordController,
                obscureText: true,
                style: GoogleFonts.lexend(
                  fontSize: 16 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 0.035 * screenHeight),

          // Forgot password text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot password',
              style: GoogleFonts.lexend(
                fontSize: 15 / 932 * screenHeight,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: 0.05 * screenHeight),

          // Login button
          Center(
            child: Obx(() {
              if (loginCtrl.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return GestureDetector(
                onTap: () {
                  loginCtrl.loginUser();
                },
                child: Container(
                  width: 0.51 * screenWidth,
                  height: 0.0536 * screenHeight,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.lexend(
                        fontSize: 24 / 932 * screenHeight,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 0.02 * screenHeight),

          // Hiển thị lỗi nếu có
          Obx(() {
            if (loginCtrl.errorMessage.value.isNotEmpty) {
              return Text(
                loginCtrl.errorMessage.value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15 / 932 * screenHeight,
                  color: AppColors.error,
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
