// import 'package:flutter/material.dart';
// import '../../../../../config/theme/app_color.dart';

// class SocialLoginButtons extends StatelessWidget {
//   const SocialLoginButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _socialButton('assets/icons/facebook.png'),
//         const SizedBox(width: 16),
//         _socialButton('assets/icons/google.png'),
//         const SizedBox(width: 16),
//         _socialButton('assets/icons/apple.png'),
//       ],
//     );
//   }

//   Widget _socialButton(String asset) {
//     return Container(
//       width: 80,
//       height: 40,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border.all(color: AppColors.grey4, width: 0.5),
//       ),
//       child: Center(
//         child: Image.asset(asset, width: 24, height: 24),
//       ),
//     );
//   }
// }
