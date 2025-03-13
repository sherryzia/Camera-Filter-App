# Building a Snapchat-like Camera App with Flutter and CameraKit

In this tutorial, we'll explore how to create a Flutter application that integrates Snapchat's CameraKit SDK to bring engaging AR lenses into your app. We'll build a sleek, dark-themed app that allows users to browse lens collections, take photos and videos with AR effects, and save them to their device gallery.

## What is CameraKit?

CameraKit is Snap Inc.'s developer toolkit that allows you to integrate Snapchat's AR technology directly into your applications. With CameraKit, you can access Snapchat's lens creator ecosystem and provide users with engaging AR experiences without them needing to leave your app.

## Project Overview

Our application will have the following features:
- Browse available Snapchat lenses by category
- Open CameraKit to take photos and videos with selected lenses
- View captured media
- Save media to the device gallery
- Dark-themed UI for a modern look and feel

## Prerequisites

Before starting, ensure you have:
- Flutter SDK installed (version 3.0.0 or higher)
- Android Studio or Visual Studio Code
- A Snapchat developer account
- CameraKit credentials (App ID and API Token)
- Basic knowledge of Flutter and Dart

## Step 1: Setting Up Your Project

Let's start by creating a new Flutter project and configuring the necessary dependencies:

```bash
flutter create snapchat_flutter
cd snapchat_flutter
```

### Project Structure

We'll organize our code using the GetX pattern for state management, making it cleaner and more maintainable:

```
lib/
├── app/
│   ├── configs/
│   │   ├── constants.dart
│   │   └── theme.dart
│   ├── controllers/
│   │   └── camera_controller.dart
│   ├── modules/
│   │   ├── home/
│   │   │   └── views/
│   │   │       └── home_view.dart
│   │   ├── lenses/
│   │   │   └── views/
│   │   │       └── lens_list_view.dart
│   │   └── media/
│   │       └── views/
│   │           └── media_result_view.dart
│   └── routes/
│       └── app_pages.dart
├── widgets/
│   ├── custom_button.dart
│   └── loading_indicator.dart
└── main.dart
```

### Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  
  # CameraKit
  camerakit_flutter: ^1.0.4
  
  # State Management
  get: ^4.6.6
  
  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Utils
  permission_handler: ^10.4.3
  video_player: ^2.7.2
  logger: ^2.0.2
  
  # Media Handling
  gallery_saver: ^2.3.2
```

Run `flutter pub get` to install these dependencies.

## Step 2: Configuring CameraKit Credentials

To use CameraKit, you need to obtain credentials from the Snap Kit Portal. After creating an account and an app on the portal, you'll get an App ID and API Token.

### Android Configuration

Edit your `android/app/src/main/AndroidManifest.xml`:

```xml
<application ...>
    <!-- CameraKit API Credentials -->
    <meta-data 
        android:name="com.snap.camerakit.app.id" 
        android:value="your-app-id" />
    <meta-data 
        android:name="com.snap.camerakit.api.token" 
        android:value="your-api-token" />
    
    <!-- Ensure your application uses an AppCompat theme -->
    android:theme="@style/AppTheme"
    android:requestLegacyExternalStorage="true"
    
    <!-- Rest of your application configuration -->
</application>

<!-- Permissions -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

Create or update `android/app/src/main/res/values/styles.xml`:

```xml
<style name="AppTheme" parent="Theme.AppCompat.NoActionBar">
    <item name="android:windowBackground">@android:color/black</item>
</style>
```

### iOS Configuration

Update your `ios/Runner/Info.plist`:

```xml
<!-- CameraKit credentials -->
<key>SCCameraKitClientID</key>
<string>your-app-id</string>
<key>SCCameraKitAPIToken</key>
<string>your-api-token</string>

<!-- Required permissions -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera permission to use CameraKit lenses</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone permission for recording videos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to save photos and videos to your gallery</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs permission to save photos and videos to your gallery</string>
```

Edit your `ios/Podfile`:

```ruby
platform :ios, '13.0'  # CameraKit requires iOS 13.0 minimum
```

## Step 3: Setting Up Constants and Theme

Let's create our constants file to store CameraKit group IDs and other app constants:

```dart
// lib/app/configs/constants.dart
class Constants {
  // App info
  static const String appName = 'Snapchat CameraKit';
  
  // CameraKit
  static const List<String> groupIdList = ['your-group-ids']; // Replace with your actual group IDs
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
  
  // Error messages
  static const String noLensesAvailable = 'No lenses available. Try again later.';
}
```

Next, let's set up our dark theme:

```dart
// lib/app/configs/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // App colors - Dark Theme
  static const Color primaryColor = Color(0xFFFFFC00); // Snapchat Yellow
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkSubtitleColor = Color(0xFFAAAAAA);
  static const Color darkSurfaceColor = Color(0xFF252525);
  
  // Text styles
  static final TextStyle darkHeadingStyle = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: darkTextColor,
  );
  
  static final TextStyle darkTitleStyle = GoogleFonts.poppins(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: darkTextColor,
  );
  
  static final TextStyle darkSubtitleStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: darkSubtitleColor,
  );
  
  static final TextStyle darkBodyStyle = GoogleFonts.poppins(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: darkTextColor,
  );
  
  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    // Additional theme configurations
  );
}
```

## Step 4: Implementing the CameraKit Controller

Now let's create our CameraKit controller using GetX:

```dart
// lib/app/controllers/camera_controller.dart
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/routes/app_pages.dart';

class CameraKitController extends GetxController implements CameraKitFlutterEvents {
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;
  
  // Observables
  final RxList<Lens> lenses = <Lens>[].obs;
  final RxString filePath = ''.obs;
  final RxString fileType = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasPermissions = false.obs;
  final RxBool hasStoragePermission = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
    checkPermissions();
  }
  
  Future<void> checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    
    hasPermissions.value = cameraStatus.isGranted && microphoneStatus.isGranted;
    
    // Check storage permissions
    await checkStoragePermissions();
    
    if (!hasPermissions.value) {
      await requestPermissions();
    }
  }
  
  // Additional permission methods and CameraKit functionality
  
  void openCameraKit() {
    if (!hasPermissions.value) {
      requestPermissions().then((_) {
        if (hasPermissions.value) {
          _openCameraKit();
        }
      });
    } else {
      _openCameraKit();
    }
  }
  
  void _openCameraKit() {
    _cameraKitFlutterImpl.openCameraKit(
      groupIds: Constants.groupIdList,
      isHideCloseButton: false,
    );
  }
  
  void getGroupLenses() {
    isLoading.value = true;
    _cameraKitFlutterImpl.getGroupLenses(
      groupIds: Constants.groupIdList,
    );
  }
  
  void openCameraKitWithSingleLens(String lensId, String groupId) {
    _cameraKitFlutterImpl.openCameraKitWithSingleLens(
      lensId: lensId,
      groupId: groupId,
      isHideCloseButton: false,
    );
  }
  
  @override
  void receivedLenses(List<Lens> lensList) {
    isLoading.value = false;
    lenses.assignAll(lensList);
    
    if (lenses.isNotEmpty) {
      Get.toNamed(Routes.LENSES);
    } else {
      Get.snackbar(
        'No Lenses Found',
        Constants.noLensesAvailable,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    filePath.value = result["path"] as String;
    fileType.value = result["type"] as String;
    
    if (filePath.isNotEmpty) {
      Get.toNamed(Routes.MEDIA_RESULT);
    }
  }
}
```

## Step 5: Setting Up Navigation

Create the app routes:

```dart
// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/modules/home/views/home_view.dart';
import 'package:snapchat_flutter/app/modules/lenses/views/lens_list_view.dart';
import 'package:snapchat_flutter/app/modules/media/views/media_result_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: Routes.LENSES,
      page: () => const LensListView(),
    ),
    GetPage(
      name: Routes.MEDIA_RESULT,
      page: () => const MediaResultView(),
    ),
  ];
}

abstract class Routes {
  static const HOME = '/home';
  static const LENSES = '/lenses';
  static const MEDIA_RESULT = '/media-result';
}
```

## Step 6: Creating Custom Buttons

Let's create custom buttons for our app:

```dart
// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  // Similar implementation
}
```

## Step 7: Creating the Home Screen

Let's build our home screen:

```dart
// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';
import 'package:snapchat_flutter/widgets/custom_button.dart';

class HomeView extends GetView<CameraKitController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
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
                  const SizedBox(width: 12),
                  Text(
                    Constants.appName,
                    style: AppTheme.darkHeadingStyle,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Show info dialog
                      showInfoDialog(context);
                    },
                    icon: const Icon(Icons.info_outline, color: AppTheme.darkTextColor),
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
    // Dialog implementation
  }
}
```

## Step 8: Implementing the Lens List View

Now let's implement the lens gallery with categorized tabs:

```dart
// lib/app/modules/lenses/views/lens_list_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';

class LensListView extends GetView<CameraKitController> {
  const LensListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Snapchat Lenses',
          style: AppTheme.darkTitleStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkTextColor),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppTheme.darkSurfaceColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }
        
        if (controller.lenses.isEmpty) {
          return _buildEmptyState();
        }
        
        return _LensListContent(lenses: controller.lenses);
      }),
    );
  }
  
  // Loading and empty state methods
}

class _LensListContent extends StatefulWidget {
  final List<Lens> lenses;

  const _LensListContent({required this.lenses});

  @override
  State<_LensListContent> createState() => _LensListContentState();
}

class _LensListContentState extends State<_LensListContent> {
  final List<String> _categories = [
    'All Lenses',
    'Popular',
    'Funny',
    'Seasonal',
    'Artistic'
  ];
  
  String _selectedCategory = 'All Lenses';
  List<Lens> _filteredLenses = [];
  
  @override
  void initState() {
    super.initState();
    _filterLenses();
  }
  
  // Filtering logic and UI building methods
}
```

## Step 9: Creating the Media Result View

Let's create the view to display captured photos and videos:

```dart
// lib/app/modules/media/views/media_result_view.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';
import 'package:snapchat_flutter/widgets/custom_button.dart';
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
          _capitalizeString(controller.fileType.value),
          style: AppTheme.darkTitleStyle.copyWith(color: Colors.white),
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
  
  String _capitalizeString(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  void _saveToGallery(String filePath, String fileType) async {
    // Gallery saving implementation
  }
}

class _MediaContent extends StatefulWidget {
  // Media content widget implementation
}
```

## Step 10: Setting Up the Main Application

Finally, let's set up our main.dart file:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';
import 'package:snapchat_flutter/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  
  runApp(const SnapchatCameraApp());
}

class SnapchatCameraApp extends StatelessWidget {
  const SnapchatCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.put<CameraKitController>(CameraKitController(), permanent: true);
    
    return GetMaterialApp(
      title: 'CameraKit Demo',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      theme: AppTheme.darkTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
```

## Getting CameraKit Group IDs

To get group IDs, you need to:

1. Log in to the [Snap Kit Developer Portal](https://kit.snapchat.com/portal)
2. Navigate to your app's CameraKit section
3. Create a lens group or find an existing one
4. The lens group ID is displayed in the group details

You can create multiple lens groups to organize lenses by category or theme.

## Conclusion

In this tutorial, we've built a complete Flutter application that integrates Snapchat's CameraKit SDK. Our app features a slick dark-themed UI, categorized lens browsing, camera functionality for capturing photos and videos with AR lenses, and the ability to save media to the device gallery.

The project demonstrates how to:
- Set up and configure CameraKit in a Flutter app
- Implement proper permission handling
- Create a modern, categorized UI for browsing lenses
- Use GetX for state management
- Handle media capture and display
- Save media to the device gallery

This implementation provides a solid foundation that you can extend with additional features like sharing to social media, adding favorites, or implementing user accounts.

Remember to replace placeholder values with your actual CameraKit credentials before deploying the app.

---

Feel free to fork this project and customize it for your own applications!

## Screenshots

![Home Screen](screenshots/home.png)
![Lens Browser](screenshots/lenses.png)
![Media Viewer](screenshots/media.png)


## License

This project is licensed under the MIT License - see the LICENSE file for details.