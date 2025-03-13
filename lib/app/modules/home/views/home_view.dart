import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';
import 'package:snapchat_flutter/widgets/custom-button.dart';

class HomeView extends GetView<CameraKitController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Row(
                children: [
                  const Icon(
                    Icons.camera_alt_rounded,
                    size: 32,
                    color: AppTheme.primaryColor,
                  ),
                  const Spacer(),
                  Text(
                    'Snapchat Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Show info dialog
                      showInfoDialog(context);
                    },
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Camera Icon
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 64,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Description
                    Text(
                      'Explore Snapchat Filters',
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Take photos and videos with Snapchat\'s lenses using CameraKit',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Buttons
                    PrimaryButton(
                      text: 'Open Camera',
                      icon: Icons.camera_alt_rounded,
                      onPressed: controller.openCameraKit,
                    ),

                    const SizedBox(height: 16),

                    SecondaryButton(
                      text: 'Browse Lenses',
                      icon: Icons.grid_view_rounded,
                      onPressed: controller.getGroupLenses,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'About CameraKit',
 style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CameraKit allows you to use Snapchat\'s lenses in your own app.',
 style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),            ),
            const SizedBox(height: 12),
            Text(
              'This example showcases how to integrate CameraKit with Flutter.',
 style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: AppTheme.buttonTextStyle.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
