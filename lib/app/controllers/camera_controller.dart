import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapchat_flutter/app/configs/constants.dart';
import 'package:snapchat_flutter/app/routes/app-pages.dart';

class CameraKitController extends GetxController implements CameraKitFlutterEvents {
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;
  
  // Observables
  final RxList<Lens> lenses = <Lens>[].obs;
  final RxString filePath = ''.obs;
  final RxString fileType = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasPermissions = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with this controller as the events listener
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
    checkPermissions();
  }
  
  Future<void> checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    
    hasPermissions.value = cameraStatus.isGranted && microphoneStatus.isGranted;
    
    if (!hasPermissions.value) {
      await requestPermissions();
    }
  }
  
  Future<void> requestPermissions() async {
    isLoading.value = true;
    
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    
    hasPermissions.value = cameraStatus.isGranted && microphoneStatus.isGranted;
    
    isLoading.value = false;
  }
  
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
    if (!hasPermissions.value) {
      requestPermissions().then((_) {
        if (hasPermissions.value) {
          _openCameraKitWithSingleLens(lensId, groupId);
        }
      });
    } else {
      _openCameraKitWithSingleLens(lensId, groupId);
    }
  }
  
  void _openCameraKitWithSingleLens(String lensId, String groupId) {
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