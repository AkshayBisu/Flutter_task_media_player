
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSlide extends StatefulWidget {
  final String url;

  const VideoSlide({super.key, required this.url});

  @override
  State<VideoSlide> createState() => _VideoSlideState();
}

class _VideoSlideState extends State<VideoSlide> {
  static const Duration _maxPlayDuration = Duration(seconds: 10);

  late final VideoPlayerController _controller;
  Timer? _stopTimer;
  bool _initialised = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _stopTimer = Timer(_maxPlayDuration, () {
      if (mounted) _controller.pause();
    });

    _initController();
  }

  Future<void> _initController() async {
    try {
      await _controller.initialize();
      if (!mounted) return;

      await _controller.setLooping(false);
      await _controller.play();
      setState(() => _initialised = true);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Failed to load video');
    }
  }

  @override
  void dispose() {
    _stopTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off, color: Colors.white54, size: 64),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    if (!_initialised) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
