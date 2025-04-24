import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:learn2aid/config/routes/app_pages.dart';
import 'package:learn2aid/config/routes/app_routes.dart';
import 'package:learn2aid/features/presentation/modules/auth/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn2aid/features/data/datasources/local/hive_storage_adapter.dart';
import 'package:learn2aid/features/data/repositories/app_state_repository_impl.dart';
import 'package:learn2aid/features/domain/repositories/app_state_repository.dart';
import 'package:learn2aid/features/presentation/modules/app_state_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive storage
  await HiveStorageAdapter().init();
  
  // Register AppStateRepository
  Get.put<AppStateRepository>(
    AppStateRepositoryImpl(),
    permanent: true
  );
  
  // Ensure use cases are registered
  AppStateBinding().dependencies();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  // Initialize Firestore
  FirebaseFirestore.instance;

  Get.put<AuthController>(AuthController(), permanent: true); // Use AuthController

  runApp(
    MyApp()  
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Prevent screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loading, // Navigate to Loading page first
      getPages: AppPages.pages,
    );
  }
}


