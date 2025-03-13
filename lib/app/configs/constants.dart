class Constants {
  // App info
  static const String appName = 'Snapchat CameraKit';
  static const String appVersion = '1.0.0';
  
  // CameraKit
  static const List<String> groupIdList = ['ec2711e5-1c4f-49c8-aec9-77c0042affff']; // TODO: Replace with your actual group IDs
  
  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  
  // Asset paths
  static const String logoPath = 'assets/images/snapchat_logo.png';
  
  // Error messages
  static const String errorFetchingLenses = 'Could not fetch lenses. Please try again.';
  static const String errorCameraPermission = 'Camera permission is required to use CameraKit.';
  static const String errorMicrophonePermission = 'Microphone permission is required to record videos.';
  static const String noLensesAvailable = 'No lenses available. Try again later.';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
  static const double buttonHeight = 56.0;
  static const double cardElevation = 2.0;
}
