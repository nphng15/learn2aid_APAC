import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn2aid/config/routes/app_routes.dart';
import 'package:learn2aid/features/presentation/modules/auth/auth_controller.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Loading effect
    
    if (authController.authToken.isNotEmpty) {
      Get.offAllNamed(AppRoutes.dashboard); // Already logged in → go to Dashboard
    } else {
      Get.offAllNamed(AppRoutes.login); // Not logged in → go to Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('lib/assets/learn2aid.png'),
              ),
              const SizedBox(height: 20),

              // Loading animation
              const CircularProgressIndicator(),
              const SizedBox(height: 20),

              // "Learn2Aid" title
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Learn',
                      style: TextStyle(
                        color: Color(0xFF215273),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        color: Color(0xFF55C595), 
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Aid',
                      style: TextStyle(
                        color: Color(0xFF215273),
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
