import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaResultWidget extends StatefulWidget {
  final String filePath;
  final String fileType;

  const MediaResultWidget({
    super.key, 
    required this.filePath, 
    required this.fileType
  });

  @override
  State<MediaResultWidget> createState() => _MediaResultWidgetState();
}

class _MediaResultWidgetState extends State<MediaResultWidget> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.fileType == 'video') {
      _initializeVideoPlayer();
    }
  }
  
  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
      
    _controller.addListener(() {
      if (!_controller.value.isPlaying &&
          _controller.value.isInitialized &&
          (_controller.value.duration == _controller.value.position)) {
        if (kDebugMode) {
          print("Video playback completed");
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.fileType == 'video') {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.fileType.capitalize()} Result'),
      ),
      floatingActionButton: widget.fileType == "video" && _isVideoInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
      body: widget.filePath.isEmpty
          ? const Center(child: Text("No media to display"))
          : _buildMediaContent(),
    );
  }
  
  Widget _buildMediaContent() {
    if (widget.fileType == 'video') {
      if (!_isVideoInitialized) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else if (widget.fileType == 'image') {
      return Center(
        child: Image.file(
          File(widget.filePath),
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Center(
        child: Text("Unsupported media type: ${widget.fileType}"),
      );
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
