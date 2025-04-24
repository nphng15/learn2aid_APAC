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
      
      // Add listener to video player to handle play/pause events and update progress
      _videoPlayerController.addListener(_videoListener);
      
      setState(() {
        _isInitialized = true;
        _duration = _videoPlayerController.value.duration;
      });
      
      // Auto play video
      _videoPlayerController.play();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }
  
  // Function to handle video events
  void _videoListener() {
    // Update video watching progress
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
  
  // Show/hide controls
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    // Automatically hide controls after 3 seconds
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
  
  // Toggle play/pause
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
  
  // Seek to specific position
  void _seekTo(Duration position) {
    _videoPlayerController.seekTo(position);
  }
  
  // Format duration
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

  // Toggle fullscreen mode
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    
    if (_isFullScreen) {
      // Rotate screen to landscape
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Hide status bar and navigation bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Return to portrait mode
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      // Show status bar and navigation bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    // Ensure return to portrait mode when exiting
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
            // Header with title and close button
            if (!_isFullScreen) // Only show header when not in fullscreen mode
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
                        // Fullscreen button
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
                          
                          // Controls
                          if (_showControls)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Play/pause button
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
                          
                          // Progress bar
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
                                  // Progress slider
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
                                  
                                  // Current time / total time
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
                          
                          // Fullscreen button when in fullscreen mode
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