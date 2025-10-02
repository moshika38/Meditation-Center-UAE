import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  const VideoPlayerWidget(
      {super.key, required this.videoPath, this.autoPlay = false});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool initialized = false;
  bool _hasError = false; // Added this flag
  final Key _videoPlayerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoPlayer(); // Extracted initialization into a separate method
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (widget.videoPath.startsWith("http")) {
        _controller = VideoPlayerController.network(widget.videoPath);
      } else {
        _controller = VideoPlayerController.file(File(widget.videoPath));
      }
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        initialized = true;
        _hasError = false; // Reset error flag on successful initialization
      });
      if (widget.autoPlay) {
        _controller.play();
      }
    } on Exception catch (e) {
      if (!mounted) return;
      debugPrint("Video player initialization error: $e");
      setState(() {
        _hasError = true;
        initialized =
            true; // Still mark as initialized to display error message
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!initialized || _hasError) return; // Skip if error or not initialized
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "Failed to load video",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (!initialized) {
      return const SizedBox(
          height: 200, child: Center(child: CircularProgressIndicator()));
    }

    return VisibilityDetector(
      key: _videoPlayerKey,
      onVisibilityChanged: (visibilityInfo) {
        if (!initialized || _hasError)
          return; // Skip if error or not initialized
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 50 && widget.autoPlay) {
          if (!_controller.value.isPlaying) {
            _controller.play();
          }
        } else {
          if (_controller.value.isPlaying) {
            _controller.pause();
          }
        }
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            Align(
              alignment: Alignment.bottomCenter,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black26,
                ),
              ),
            ),
            Center(
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
