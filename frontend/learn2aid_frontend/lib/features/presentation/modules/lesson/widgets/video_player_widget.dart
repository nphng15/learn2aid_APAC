import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;
  
  const VideoPlayerWidget({
    super.key,
    required this.videoFile,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  
  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Kiểm tra nếu file video đã thay đổi
    if (widget.videoFile.path != oldWidget.videoFile.path) {
      // Dừng controller cũ và giải phóng tài nguyên
      _controller.dispose();
      
      // Khởi tạo lại với video mới
      _initVideoPlayer();
    }
  }
  
  Future<void> _initVideoPlayer() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Lỗi khởi tạo video player: $e');
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Sử dụng container với kích thước cố định
    return Container(
      height: 180, // Chiều cao cố định
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: !_isInitialized
          ? _buildLoadingPreview()
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: AspectRatio(
                  // Luôn sử dụng tỷ lệ 16:9 cho tất cả video
                  aspectRatio: 16 / 9, 
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
    );
  }
  
  Widget _buildLoadingPreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(widget.videoFile),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const CircularProgressIndicator(color: Colors.white),
      ],
    );
  }
} 