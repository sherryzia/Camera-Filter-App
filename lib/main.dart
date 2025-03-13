import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snapchat_flutter/app/bindings/initial_binding.dart';
import 'package:snapchat_flutter/app/configs/theme.dart';
import 'package:snapchat_flutter/app/routes/app-pages.dart';

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
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  runApp(const SnapchatCameraApp());
}

class SnapchatCameraApp extends StatelessWidget {
  const SnapchatCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CameraKit Demo',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}