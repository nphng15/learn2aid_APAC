import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class VideoPopupPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String videoId;
  final Function(String, double) onProgressUpdate;
  
  const VideoPopupPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.videoId,
    required this.onProgressUpdate,
  });

  @override
  State<VideoPopupPlayer> createState() => _VideoPopupPlayerState();
}

class _VideoPopupPlayerState extends State<VideoPopupPlayer> {
  late VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isFullScreen = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    
    try {
      await _videoPlayerController.initialize();
      
      // Thêm listener cho video player để xử lý sự kiện phát/dừng và cập nhật tiến trình
      _videoPlayerController.addListener(_videoListener);
      
      setState(() {
        _isInitialized = true;
        _duration = _videoPlayerController.value.duration;
      });
      
      // Tự động phát video
      _videoPlayerController.play();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Lỗi khởi tạo video player: $e');
    }
  }
  
  // Hàm xử lý sự kiện video
  void _videoListener() {
    // Cập nhật tiến trình xem video
    final position = _videoPlayerController.value.position;
    final duration = _videoPlayerController.value.duration;
    
    setState(() {
      _position = position;
      _duration = duration;
    });
    
    if (duration.inSeconds > 0) {
      final progress = position.inSeconds / duration.inSeconds;
      widget.onProgressUpdate(widget.videoId, progress);
    }
  }
  
  // Hiển thị/ẩn điều khiển
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    // Tự động ẩn điều khiển sau 3 giây
    _hideTimer?.cancel();
    if (_showControls) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }
  
  // Chuyển đổi phát/dừng
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _videoPlayerController.play();
      } else {
        _videoPlayerController.pause();
      }
    });
  }
  
  // Chuyển đến vị trí cụ thể
  void _seekTo(Duration position) {
    _videoPlayerController.seekTo(position);
  }
  
  // Định dạng thời gian
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  // Chuyển đổi chế độ toàn màn hình
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    
    if (_isFullScreen) {
      // Xoay màn hình sang ngang
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Ẩn thanh trạng thái và thanh điều hướng
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Trở về chế độ dọc
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      // Hiện lại thanh trạng thái và thanh điều hướng
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    // Đảm bảo trở về chế độ dọc khi thoát
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _hideTimer?.cancel();
    _videoPlayerController.removeListener(_videoListener);
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: _isFullScreen ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.9,
        height: _isFullScreen ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: _isFullScreen ? BorderRadius.zero : BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với tiêu đề và nút đóng
            if (!_isFullScreen) // Chỉ hiện header khi không ở chế độ toàn màn hình
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        // Nút toàn màn hình
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: _toggleFullScreen,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            // Video player
            Expanded(
              child: _isInitialized
                  ? GestureDetector(
                      onTap: _toggleControls,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Video
                          AspectRatio(
                            aspectRatio: _isFullScreen 
                                ? MediaQuery.of(context).size.aspectRatio 
                                : _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                          
                          // Điều khiển
                          if (_showControls)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Nút phát/dừng
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ],
                              ),
                            ),
                          
                          // Thanh tiến trình
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Thanh trượt tiến trình
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: const Color(0xff215273),
                                      inactiveTrackColor: Colors.grey,
                                      thumbColor: const Color(0xff215273),
                                      overlayColor: const Color(0xff215273).withOpacity(0.3),
                                    ),
                                    child: Slider(
                                      value: _position.inMilliseconds.toDouble(),
                                      min: 0,
                                      max: _duration.inMilliseconds.toDouble(),
                                      onChanged: (value) {
                                        _seekTo(Duration(milliseconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                  
                                  // Thời gian hiện tại / tổng thời gian
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(_position),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        _formatDuration(_duration),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Nút toàn màn hình khi ở chế độ toàn màn hình
                          if (_isFullScreen && _showControls)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen_exit,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: _toggleFullScreen,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}