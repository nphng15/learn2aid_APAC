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
  
  // Khởi tạo Hive storage
  await HiveStorageAdapter().init();
  
  // Đăng ký AppStateRepository
  Get.put<AppStateRepository>(
    AppStateRepositoryImpl(),
    permanent: true
  );
  
  // Đảm bảo các use case được đăng ký
  AppStateBinding().dependencies();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp();
  // Khởi tạo Firestore
  FirebaseFirestore.instance;

  Get.put<AuthController>(AuthController(), permanent: true); // Sử dụng AuthController

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
    // khong cho man hinh xoay ngang
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
      initialRoute: AppRoutes.loading, // Chạy vào trang Loading trước
      getPages: AppPages.pages,
    );
  }
}


