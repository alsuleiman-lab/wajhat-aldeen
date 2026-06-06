import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocationStatus { initial, loading, granted, denied, manual }

class LocationService extends ChangeNotifier {
  LocationStatus _status = LocationStatus.initial;
  double? _latitude;
  double? _longitude;
  String? _cityName;

  LocationStatus get status => _status;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get cityName => _cityName;

  bool get hasLocation => _latitude != null && _longitude != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLat = prefs.getDouble('location_lat');
    final savedLng = prefs.getDouble('location_lng');
    if (savedLat != null && savedLng != null) {
      _latitude = savedLat;
      _longitude = savedLng;
      _cityName = prefs.getString('location_city');
      _status = LocationStatus.manual;
      notifyListeners();
    }
  }

  Future<bool> requestGpsLocation() async {
    _status = LocationStatus.loading;
    notifyListeners();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _status = LocationStatus.denied;
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _status = LocationStatus.denied;
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _status = LocationStatus.denied;
      notifyListeners();
      return false;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
      _status = LocationStatus.granted;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('location_lat', position.latitude);
      await prefs.setDouble('location_lng', position.longitude);

      notifyListeners();
      return true;
    } catch (e) {
      _status = LocationStatus.denied;
      notifyListeners();
      return false;
    }
  }

  Future<void> setManualLocation(double lat, double lng, String city) async {
    _latitude = lat;
    _longitude = lng;
    _cityName = city;
    _status = LocationStatus.manual;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('location_lat', lat);
    await prefs.setDouble('location_lng', lng);
    await prefs.setString('location_city', city);

    notifyListeners();
  }
}
