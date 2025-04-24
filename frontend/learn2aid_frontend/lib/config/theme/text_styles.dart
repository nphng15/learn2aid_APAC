import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  // Title Text
  static TextStyle title40 = GoogleFonts.lexend(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary, // Green color
  );

  // Button Text
  static TextStyle button24 = GoogleFonts.lexend(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.white, // White
  );

  // Input Placeholder Text
  static TextStyle inputText16 = GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey3, // Dark grey
  );

  // Small Text (Forgot Password, Or Login With)
  static TextStyle smallText14 = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey3, // Dark grey
  );

  // Register Link
  static TextStyle link14 = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary, // Green
  );

  // Error Message Text
  static TextStyle error15 = GoogleFonts.nunitoSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.error, // Warning red
  );

  static TextStyle bold36 = GoogleFonts.lexend(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static TextStyle regular14 = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey3,
  );

  static TextStyle medium15 = GoogleFonts.lexend(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}


// class AppTextStyles {
//   static TextStyle bold36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin36 = GoogleFonts.lexend(
//     fontSize: 36,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin30 = GoogleFonts.lexend(
//     fontSize: 30,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin24 = GoogleFonts.lexend(
//     fontSize: 24,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin20 = GoogleFonts.lexend(
//     fontSize: 20,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin18 = GoogleFonts.lexend(
//     fontSize: 18,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin16 = GoogleFonts.lexend(
//     fontSize: 16,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin14 = GoogleFonts.lexend(
//     fontSize: 14,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin12 = GoogleFonts.lexend(
//     fontSize: 12,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin10 = GoogleFonts.lexend(
//     fontSize: 10,
//     fontWeight: FontWeight.w100,
//   );

//   static TextStyle bold8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w700,
//   );

//   static TextStyle semiBold8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w600,
//   );

//   static TextStyle medium8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w500,
//   );

//   static TextStyle regular8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w400,
//   );

//   static TextStyle light8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w300,
//   );

//   static TextStyle thin8 = GoogleFonts.lexend(
//     fontSize: 8,
//     fontWeight: FontWeight.w100,
//   );
// }