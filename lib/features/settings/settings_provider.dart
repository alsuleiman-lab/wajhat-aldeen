import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _overlayEnabled = false;
  bool _loaded = false;

  bool get overlayEnabled => _overlayEnabled;
  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _overlayEnabled = prefs.getBool('overlay_enabled') ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setOverlayEnabled(bool value) async {
    _overlayEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('overlay_enabled', value);
    notifyListeners();
  }
}
