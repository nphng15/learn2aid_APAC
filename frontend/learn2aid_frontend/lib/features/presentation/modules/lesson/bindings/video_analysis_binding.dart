import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/video_analysis_controller.dart';
import '../../../../data/repositories/video_analysis_repository_impl.dart';
import '../../../../domain/usecases/analyze_video_usecase.dart';
import '../../../../domain/usecases/save_analysis_result_usecase.dart';
import '../../../../data/datasources/remote/video_analysis_remote_datasource.dart';

class VideoAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    // Đăng ký http client
    Get.lazyPut<http.Client>(
      () => http.Client(),
    );
    
    // Đăng ký remote data source
    Get.lazyPut<VideoAnalysisRemoteDataSource>(
      () => VideoAnalysisRemoteDataSourceImpl(
        client: Get.find<http.Client>(),
      ),
    );
    
    // Đăng ký repository
    Get.lazyPut<VideoAnalysisRepositoryImpl>(
      () => VideoAnalysisRepositoryImpl(
        remoteDataSource: Get.find<VideoAnalysisRemoteDataSource>(),
      ),
    );
    
    // Đăng ký các use cases
    Get.lazyPut<AnalyzeVideoUseCase>(
      () => AnalyzeVideoUseCase(Get.find<VideoAnalysisRepositoryImpl>()),
    );
    
    Get.lazyPut<SaveAnalysisResultUseCase>(
      () => SaveAnalysisResultUseCase(Get.find<VideoAnalysisRepositoryImpl>()),
    );
    
    // Đăng ký controller
    Get.lazyPut<VideoAnalysisController>(
      () => VideoAnalysisController(),
    );
  }
} 