import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverlayService {
  static const _channel = MethodChannel('com.wajhat.aldeen/overlay');

  static Future<bool> checkPermission() async {
    try {
      return await _channel.invokeMethod('checkOverlayPermission');
    } catch (_) {
      return false;
    }
  }

  static Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
    } catch (_) {}
  }

  static Future<void> startService() async {
    try {
      await _channel.invokeMethod('startOverlayService');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('overlay_enabled', true);
    } catch (_) {}
  }

  static Future<void> stopService() async {
    try {
      await _channel.invokeMethod('stopOverlayService');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('overlay_enabled', false);
    } catch (_) {}
  }

  static Future<bool> isServiceRunning() async {
    try {
      return await _channel.invokeMethod('isServiceRunning');
    } catch (_) {
      return false;
    }
  }
}
