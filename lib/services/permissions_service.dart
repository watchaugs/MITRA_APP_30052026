// lib/services/permissions_service.dart
// ════════════════════════════════════════════════════════════
// Hard Anchoring & Permissions Handler
//
// Permissions are ONLY requested when the feature that needs
// them is triggered — never on cold launch.
// This keeps the app compliant with children's app policies.
// ════════════════════════════════════════════════════════════

import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionsService {

  // ── Camera (AR Feature) ───────────────────────────────────
  /// Call this ONLY when the user taps "Open AR".
  /// Never ask for camera on app launch.
  static Future<PermissionStatus> requestCamera() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return status;
    return Permission.camera.request();
  }

  static Future<bool> hasCameraPermission() async =>
      (await Permission.camera.status).isGranted;

  // ── Location (State Detection) ────────────────────────────
  /// Called ONLY when user taps "Auto-detect my state".
  /// Manual state selection requires no permission.
  static Future<Position?> getLocationForStateDetection() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) return null;
    }
    if (perm == LocationPermission.deniedForever) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 8),
    );
  }

  // ── Notifications (Optional) ──────────────────────────────
  /// Ask for notification permission only from Settings screen
  /// when user explicitly enables "Daily Reminders".
  static Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> hasNotificationPermission() async =>
      (await Permission.notification.status).isGranted;

  // ── Storage (Offline Download) ────────────────────────────
  static Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // ── Microphone (future: voice quiz) ──────────────────────
  static Future<bool> requestMicrophone() async =>
      (await Permission.microphone.request()).isGranted;

  // ── Open Settings if permanently denied ───────────────────
  static Future<void> openSettings() => openAppSettings();
}

// ── State detection from lat/lng ──────────────────────────────
abstract final class GeoStateDetector {
  /// Very simplified lat/lng → state code mapping.
  /// In production, call your backend's /geo/detect-state endpoint.
  static String? detectStateFromLatLng(double lat, double lng) {
    if (lat > 20 && lat < 28 && lng > 68 && lng < 78) return 'RJ'; // Rajasthan
    if (lat > 22 && lat < 25 && lng > 68 && lng < 74) return 'GJ'; // Gujarat
    if (lat > 18 && lat < 23 && lng > 73 && lng < 80) return 'MH'; // Maharashtra
    if (lat > 12 && lat < 20 && lng > 76 && lng < 85) return 'AP'; // AP/Telangana
    if (lat > 8  && lat < 14 && lng > 76 && lng < 80) return 'KL'; // Kerala
    if (lat > 11 && lat < 14 && lng > 76 && lng < 80) return 'KA'; // Karnataka
    if (lat > 8  && lat < 13 && lng > 77 && lng < 80) return 'TN'; // Tamil Nadu
    if (lat > 25 && lat < 30 && lng > 78 && lng < 85) return 'UP'; // UP
    if (lat > 28 && lat < 30 && lng > 76 && lng < 77) return 'DL'; // Delhi
    if (lat > 22 && lat < 27 && lng > 80 && lng < 84) return 'MP'; // MP
    return null; // Unknown — user must select manually
  }
}
