import 'package:get/get.dart';
import 'package:snapchat_flutter/app/controllers/camera_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register controllers
    Get.put<CameraKitController>(CameraKitController(), permanent: true);
  }
}
