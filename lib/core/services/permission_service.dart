import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final permissionServiceProvider = Provider((ref) => PermissionService());

class PermissionService {
  /// Request camera permission
  Future<bool> requestCamera() async {
    safePrint('[Permissions] Requesting camera...');
    final status = await Permission.camera.request();
    safePrint('[Permissions] Camera: $status');
    return status.isGranted;
  }

  /// Request microphone permission
  Future<bool> requestMicrophone() async {
    safePrint('[Permissions] Requesting microphone...');
    final status = await Permission.microphone.request();
    safePrint('[Permissions] Microphone: $status');
    return status.isGranted;
  }

  /// Request storage/photos permission
  Future<bool> requestStorage() async {
    safePrint('[Permissions] Requesting storage...');
    final status = await Permission.storage.request();
    safePrint('[Permissions] Storage: $status');
    return status.isGranted || status.isLimited;
  }

  /// Request photos permission (iOS 14+)
  Future<bool> requestPhotos() async {
    safePrint('[Permissions] Requesting photos...');
    final status = await Permission.photos.request();
    safePrint('[Permissions] Photos: $status');
    return status.isGranted || status.isLimited;
  }

  /// Request location permission
  Future<bool> requestLocation() async {
    safePrint('[Permissions] Requesting location...');
    final status = await Permission.locationWhenInUse.request();
    safePrint('[Permissions] Location: $status');
    return status.isGranted;
  }

  /// Request calendar permission
  Future<bool> requestCalendar() async {
    safePrint('[Permissions] Requesting calendar...');
    final status = await Permission.calendar.request();
    safePrint('[Permissions] Calendar: $status');
    return status.isGranted;
  }

  /// Request speech recognition permission
  Future<bool> requestSpeech() async {
    safePrint('[Permissions] Requesting speech...');
    final status = await Permission.speech.request();
    safePrint('[Permissions] Speech: $status');
    return status.isGranted;
  }

  /// Request all permissions needed for the app
  Future<Map<String, bool>> requestAllPermissions() async {
    safePrint('[Permissions] Requesting all permissions...');
    
    final results = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.locationWhenInUse,
      Permission.calendar,
      Permission.speech,
    ].request();

    final permissions = {
      'camera': results[Permission.camera]?.isGranted ?? false,
      'microphone': results[Permission.microphone]?.isGranted ?? false,
      'photos': results[Permission.photos]?.isGranted ?? false,
      'location': results[Permission.locationWhenInUse]?.isGranted ?? false,
      'calendar': results[Permission.calendar]?.isGranted ?? false,
      'speech': results[Permission.speech]?.isGranted ?? false,
    };

    safePrint('[Permissions] Results: $permissions');
    return permissions;
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// Check if microphone permission is granted
  Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  /// Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted || status.isLimited;
  }

  /// Check if photos permission is granted
  Future<bool> hasPhotosPermission() async {
    final status = await Permission.photos.status;
    return status.isGranted || status.isLimited;
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  /// Check if calendar permission is granted
  Future<bool> hasCalendarPermission() async {
    return await Permission.calendar.isGranted;
  }

  /// Check if speech permission is granted
  Future<bool> hasSpeechPermission() async {
    return await Permission.speech.isGranted;
  }

  /// Open app settings
  Future<void> openSettings() async {
    safePrint('[Permissions] Opening settings...');
    await openAppSettings();
  }
}
