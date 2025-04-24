class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => "ServerException: $message";
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => "UnauthorizedException: $message";
}

///lỗi kết nối mạng
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => "NetworkException: $message";
}

///lỗi phân tích video
class VideoAnalysisException implements Exception {
  final String message;
  VideoAnalysisException(this.message);

  @override
  String toString() => "VideoAnalysisException: $message";
}

///lỗi upload file
class FileUploadException implements Exception {
  final String message;
  FileUploadException(this.message);

  @override
  String toString() => "FileUploadException: $message";
}

/// kết nối timeout
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => "TimeoutException: $message";
}

///  lỗi xử lý quiz
class QuizException implements Exception {
  final String message;
  QuizException(this.message);

  @override
  String toString() => "QuizException: $message";
}

///không tìm thấy dữ liệu
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => "NotFoundException: $message";
}

/// dữ liệu không hợp lệ
class InvalidDataException implements Exception {
  final String message;
  InvalidDataException(this.message);

  @override
  String toString() => "InvalidDataException: $message";
}
