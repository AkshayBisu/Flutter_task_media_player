import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/widgets/image_slider.dart';
import 'package:flutter_task/widgets/video_slider.dart';
import '../data/playlist.dart';
import '../models/media_item._model.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  static const Duration slotDuration = Duration(seconds: 10);

  late final List<MediaItem> _playlist;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _playlist = loadPlaylist();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(slotDuration, (_) => _advance());
  }

  void _advance() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Widget slideWidget(MediaItem item) {
    switch (item.type) {
      case MediaType.image:
        return ImageSlide(key: ValueKey('img_$_currentIndex'), url: item.url);
      case MediaType.video:
        return VideoSlide(key: ValueKey('vid_$_currentIndex'), url: item.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _playlist[_currentIndex];

    return Scaffold(backgroundColor: Colors.black, body: slideWidget(current));
  }
}
