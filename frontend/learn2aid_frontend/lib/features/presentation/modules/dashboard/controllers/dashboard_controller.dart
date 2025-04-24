// import 'package:get/get.dart';
// import '../../../../../config/routes/app_routes.dart';

// class DashboardController extends GetxController {
//   final currentIndex = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _setCurrentIndexByRoute(Get.currentRoute);
//   }

//   void updateIndexByRoute(String currentRoute) {
//     switch (currentRoute) {
//       case AppRoutes.dashboard:
//         currentIndex.value = 0;
//         break;
//       case AppRoutes.lesson:
//         currentIndex.value = 1;
//         break;
//       case AppRoutes.quiz:
//         currentIndex.value = 2;
//         break;
//       default:
//         currentIndex.value = 0;
//     }
//   }

//   void _setCurrentIndexByRoute(String currentRoute) {
//     switch (currentRoute) {
//       case AppRoutes.dashboard:
//         currentIndex.value = 0;
//         break;
//       case AppRoutes.lesson:
//         currentIndex.value = 1;
//         break;
//       case AppRoutes.quiz:
//         currentIndex.value = 2;
//         break;
//       default:
//         currentIndex.value = 0;
//     }
//   }
// }
