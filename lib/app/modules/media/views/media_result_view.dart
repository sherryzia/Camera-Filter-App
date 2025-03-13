import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';
import 'package:snapchat_flutter/widgets/custom-button.dart';
import 'package:video_player/video_player.dart';

class MediaResultView extends GetView<CameraKitController> {
  const MediaResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(() => Text(
          StringExtension(controller.fileType.value).capitalize(),
          style: AppTheme.titleStyle.copyWith(color: Colors.white),
        )),
        actions: [
          // Save to Gallery Button
          IconButton(
            icon: const Icon(Icons.save_alt, color: Colors.white),
            onPressed: () => _saveToGallery(controller.filePath.value, controller.fileType.value),
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Get.snackbar(
                'Share',
                'Sharing functionality would be implemented here',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.filePath.isEmpty) {
          return const Center(
            child: Text(
              'No media to display',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        
        return _MediaContent(
          filePath: controller.filePath.value,
          fileType: controller.fileType.value,
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        color: Colors.black,
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Take Another',
                icon: Icons.camera_alt,
                onPressed: () {
                  Get.back();
                  controller.openCameraKit();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SecondaryButton(
                text: 'Back to Home',
                icon: Icons.home,
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveToGallery(String filePath, String fileType) async {
    final RxBool isSaving = false.obs;
    
    try {
      // Show saving indicator
      isSaving.value = true;
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          content: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSaving.value
                  ? const CircularProgressIndicator(color: AppTheme.primaryColor)
                  : const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 16),
              Text(
                isSaving.value ? 'Saving to gallery...' : 'Saved to gallery!',
                style: AppTheme.subtitleStyle,
              ),
            ],
          )),
        ),
        barrierDismissible: false,
      );
      
      // Save file to gallery
      bool success;
      if (fileType.toLowerCase() == 'image') {
        success = (await GallerySaver.saveImage(filePath, albumName: 'CameraKit'))!;
      } else if (fileType.toLowerCase() == 'video') {
        success = (await GallerySaver.saveVideo(filePath, albumName: 'CameraKit'))!;
      } else {
        throw Exception('Unsupported media type: $fileType');
      }
      
      // Update dialog
      isSaving.value = false;
      
      // Close dialog after a delay
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
        
        // Show success/failure message
        if (success) {
          Get.snackbar(
            'Success',
            '${StringExtension(fileType).capitalize()} saved to gallery',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save ${fileType.toLowerCase()} to gallery',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
    } catch (e) {
      // Close dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to save: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class _MediaContent extends StatefulWidget {
  final String filePath;
  final String fileType;

  const _MediaContent({
    required this.filePath,
    required this.fileType,
  });

  @override
  State<_MediaContent> createState() => _MediaContentState();
}

class _MediaContentState extends State<_MediaContent> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.fileType.toLowerCase() == 'video') {
      _initializeVideoPlayer();
    }
  }
  
  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
      
    _videoController!.addListener(() {
      if (!_videoController!.value.isPlaying &&
          _videoController!.value.isInitialized &&
          (_videoController!.value.duration == _videoController!.value.position)) {
        if (kDebugMode) {
          print("Video playback completed");
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.fileType.toLowerCase() == 'video') {
      _videoController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileType.toLowerCase() == 'video') {
      if (!_isVideoInitialized) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        );
      }
      
      return Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
          if (!_videoController!.value.isPlaying)
            GestureDetector(
              onTap: () {
                setState(() {
                  _videoController!.play();
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          if (_videoController!.value.isPlaying)
            Positioned(
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController!.pause();
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      );
    } else if (widget.fileType.toLowerCase() == 'image') {
      return Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Image.file(
            File(widget.filePath),
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          "Unsupported media type: ${widget.fileType}",
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}