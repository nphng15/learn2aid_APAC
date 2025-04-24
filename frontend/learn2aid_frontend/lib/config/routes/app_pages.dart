import 'package:get/get.dart';
import 'package:learn2aid/features/presentation/modules/auth/login/login_binding.dart';
// import 'package:learn2aid/features/presentation/modules/auth/screens/loading_screen.dart';
import 'package:learn2aid/features/presentation/modules/auth/login/screens/login_screen.dart';
import 'package:learn2aid/features/presentation/modules/auth/register/screens/register_screen.dart';
import 'package:learn2aid/features/presentation/modules/auth/loading/loading_binding.dart';
import 'package:learn2aid/features/presentation/modules/auth/loading/screens/loading_screen.dart';
import '../../features/presentation/modules/dashboard/screens/dashboard_page.dart';
import '../../features/presentation/modules/dashboard/bindings/dashboard_binding.dart';
import '../../features/presentation/modules/quiz/screens/quiz_page.dart';
import '../../features/presentation/modules/quiz/quiz_binding.dart';
import '../../features/presentation/modules/lesson/screens/lesson_page.dart';
import '../../features/presentation/modules/lesson/screens/videocard_interactive.dart';
import '../../features/presentation/modules/lesson/bindings/lesson_binding.dart';
import '../../features/presentation/modules/profile/screens/profile_screen.dart';
import '../../features/presentation/modules/profile/profile_binding.dart';
import '../../features/presentation/modules/dashboard/bindings/video_binding.dart';
import '../../features/presentation/modules/app_state_binding.dart';
import '../../features/presentation/modules/event/screens/event_page.dart';
import '../../features/presentation/modules/event/event_binding.dart';
import '../../features/presentation/modules/feedback/screens/feedback_page.dart';
import '../../features/presentation/modules/feedback/feedback_binding.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.loading,
      page: () => const LoadingScreen(),
      binding: LoadingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      ),
    GetPage(
      name: AppRoutes.register, 
      page: () => const RegisterScreen()
      ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      bindings: [
        AppStateBinding(),
        DashboardBinding(), 
        VideoBinding()
      ]
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizPage(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: AppRoutes.lesson,
      page: () => const LessonPage(),
      bindings: [
        AppStateBinding(),
        LessonBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.lessonInteractive,
      page: () => const LessonInteractive(),
      binding: LessonBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      bindings: [
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.event,
      page: () => const EventPage(),
      bindings: [
        EventBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => FeedbackPage(),
      binding: FeedbackBinding(),
    ),
  ];
}
