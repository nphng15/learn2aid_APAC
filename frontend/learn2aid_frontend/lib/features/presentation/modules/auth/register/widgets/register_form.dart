import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/theme/app_color.dart';

class RegisterForm extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const RegisterForm({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We use Column to hold the 4 fields and "Register" button
    return SizedBox(
      width: 0.905 * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First input (Email)
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
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

          SizedBox(height: 0.03 * screenHeight),

          // Second input (Password)
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
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

          SizedBox(height: 0.03 * screenHeight),

          // Third input (Confirm Password)
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
                obscureText: true,
                style: GoogleFonts.lexend(
                  fontSize: 16 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 0.03 * screenHeight),
          Container(
            height: 0.064 * screenHeight,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(237, 237, 237, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 / 423 * screenWidth),
              child: TextField(
                style: GoogleFonts.lexend(
                  fontSize: 16 / 932 * screenHeight,
                  color: AppColors.grey3,
                ),
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 0.04 * screenHeight),

          // Register button
          Center(
            child: Container(
              width: 0.51 * screenWidth, 
              height: 0.0536 * screenHeight,
              decoration: BoxDecoration(
                color: AppColors.secondary, 
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  'Register',
                  style: GoogleFonts.lexend(
                    fontSize: 24 / 932 * screenHeight,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 0.03 * screenHeight),

          // Error message placeholder

          // Text(
          //   'Error will show here',
          //   style: GoogleFonts.nunitoSans(
          //     fontSize: 15 / 932 * screenHeight,
          //     color: AppColors.error,
          //   ),
          // ),
        ],
      ),
    );
  }
}
