import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/datasources/remote/event_remote_data_source.dart';
import '../../../data/repositories/event_repository_impl.dart';
import '../../../domain/repositories/event_repository.dart';
import 'event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký EventRemoteDataSource
    Get.lazyPut<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(FirebaseFirestore.instance),
    );
    
    // Đăng ký EventRepository
    Get.lazyPut<EventRepository>(
      () => EventRepositoryImpl(Get.find<EventRemoteDataSource>()),
    );
    
    // Đăng ký EventController
    Get.lazyPut<EventController>(
      () => EventController(Get.find<EventRepository>()),
    );
  }
} 