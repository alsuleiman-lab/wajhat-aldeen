import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_model.dart';

class PrayerService extends ChangeNotifier {
  PrayerTimesModel? _prayerTimes;
  Timer? _countdownTimer;
  Duration _countdown = Duration.zero;
  String _nextPrayerName = '';
  String _nextPrayerTime = '';
  double? _latitude;
  double? _longitude;
  AppSettings _settings = const AppSettings();

  PrayerTimesModel? get prayerTimes => _prayerTimes;
  Duration get countdown => _countdown;
  String get nextPrayerName => _nextPrayerName;
  String get nextPrayerTime => _nextPrayerTime;
  AppSettings get settings => _settings;

  static const Map<CalculationMethod, String> calculationMethodNames = {
    CalculationMethod.muslimWorldLeague: 'رابطة العالم الإسلامي',
    CalculationMethod.egyptian: 'الهيئة المصرية',
    CalculationMethod.karachi: 'جامعة العلوم الإسلامية كراتشي',
    CalculationMethod.ummAlQura: 'أم القرى - السعودية',
    CalculationMethod.dubai: 'دبي',
    CalculationMethod.moonsightingCommittee: 'لجنة رؤية الهلال',
    CalculationMethod.northAmerica: 'أمريكا الشمالية - ISNA',
    CalculationMethod.kuwait: 'الكويت',
    CalculationMethod.qatar: 'قطر',
    CalculationMethod.singapore: 'سنغافورة',
    CalculationMethod.turkey: 'تركيا',
    CalculationMethod.tehran: 'طهران',
    CalculationMethod.other: 'اتحاد المنظمات الإسلامية في فرنسا UOIF',
  };

  static const Map<Madhab, String> madhabNames = {
    Madhab.shafi: 'سني (شافعي، مالكي، حنبلي)',
    Madhab.hanafi: 'حنفي',
  };

  Future<void> initialize() async {
    await _loadSettings();
    _startCountdownTimer();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Default: UOIF (other method with custom angles 12/12)
    _settings = AppSettings(
      calculationMethod: CalculationMethod.other,
      madhab: Madhab.shafi,
      customFajrAngle: prefs.getDouble('fajr_angle') ?? 12.0,
      customIshaAngle: prefs.getDouble('isha_angle') ?? 12.0,
      fajrOffset: prefs.getInt('offset_fajr') ?? 0,
      sunriseOffset: prefs.getInt('offset_sunrise') ?? 0,
      dhuhrOffset: prefs.getInt('offset_dhuhr') ?? 0,
      asrOffset: prefs.getInt('offset_asr') ?? 0,
      maghribOffset: prefs.getInt('offset_maghrib') ?? 0,
      ishaOffset: prefs.getInt('offset_isha') ?? 0,
      fixedIshaAfterMaghrib: prefs.getInt('fixed_isha_after_maghrib'),
      useGps: prefs.getBool('use_gps') ?? true,
      timeFormat24h: prefs.getBool('time_format_24h') ?? true,
      hijriOffset: prefs.getInt('hijri_offset') ?? 0,
      manualLatitude: prefs.getDouble('manual_lat'),
      manualLongitude: prefs.getDouble('manual_lng'),
      manualCityName: prefs.getString('manual_city'),
    );
  }

  void setLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    _calculatePrayerTimes();
    notifyListeners();
  }

  void updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fajr_angle', newSettings.customFajrAngle ?? 12.0);
    await prefs.setDouble('isha_angle', newSettings.customIshaAngle ?? 12.0);
    await prefs.setInt('offset_fajr', newSettings.fajrOffset);
    await prefs.setInt('offset_sunrise', newSettings.sunriseOffset);
    await prefs.setInt('offset_dhuhr', newSettings.dhuhrOffset);
    await prefs.setInt('offset_asr', newSettings.asrOffset);
    await prefs.setInt('offset_maghrib', newSettings.maghribOffset);
    await prefs.setInt('offset_isha', newSettings.ishaOffset);
    await prefs.setBool('time_format_24h', newSettings.timeFormat24h);
    await prefs.setInt('hijri_offset', newSettings.hijriOffset);
    await prefs.setBool('use_gps', newSettings.useGps);
    if (newSettings.fixedIshaAfterMaghrib != null) {
      await prefs.setInt('fixed_isha_after_maghrib', newSettings.fixedIshaAfterMaghrib!);
    } else {
      await prefs.remove('fixed_isha_after_maghrib');
    }
    if (newSettings.manualLatitude != null) {
      await prefs.setDouble('manual_lat', newSettings.manualLatitude!);
      await prefs.setDouble('manual_lng', newSettings.manualLongitude!);
    }
    if (newSettings.manualCityName != null) {
      await prefs.setString('manual_city', newSettings.manualCityName!);
    }
    _calculatePrayerTimes();
    notifyListeners();
  }

  void _calculatePrayerTimes() {
    final lat = _latitude ?? _settings.manualLatitude;
    final lng = _longitude ?? _settings.manualLongitude;
    if (lat == null || lng == null) return;

    final coordinates = Coordinates(lat, lng);
    final date = DateComponents.from(DateTime.now());

    CalculationParameters params;
    if (_settings.calculationMethod == CalculationMethod.other) {
      params = CalculationMethod.other.getParameters();
      params.fajrAngle = _settings.customFajrAngle ?? 12.0;
      params.ishaAngle = _settings.customIshaAngle ?? 12.0;
    } else {
      params = _settings.calculationMethod.getParameters();
      if (_settings.customFajrAngle != null) {
        params.fajrAngle = _settings.customFajrAngle!;
      }
      if (_settings.customIshaAngle != null) {
        params.ishaAngle = _settings.customIshaAngle!;
      }
    }
    params.madhab = _settings.madhab;

    final prayerTimes = PrayerTimes(coordinates, date, params);

    DateTime ishaTime = prayerTimes.isha;
    if (_settings.fixedIshaAfterMaghrib != null) {
      ishaTime = prayerTimes.maghrib.add(Duration(minutes: _settings.fixedIshaAfterMaghrib!));
    }

    final now = DateTime.now();
    Prayer nextPrayer = prayerTimes.nextPrayer();

    _prayerTimes = PrayerTimesModel(
      fajr: _buildPrayer('الفجر', prayerTimes.fajr.add(Duration(minutes: _settings.fajrOffset)), nextPrayer, Prayer.fajr),
      sunrise: _buildPrayer('الشروق', prayerTimes.sunrise.add(Duration(minutes: _settings.sunriseOffset)), nextPrayer, Prayer.sunrise),
      dhuhr: _buildPrayer('الظهر', prayerTimes.dhuhr.add(Duration(minutes: _settings.dhuhrOffset)), nextPrayer, Prayer.dhuhr),
      asr: _buildPrayer('العصر', prayerTimes.asr.add(Duration(minutes: _settings.asrOffset)), nextPrayer, Prayer.asr),
      maghrib: _buildPrayer('المغرب', prayerTimes.maghrib.add(Duration(minutes: _settings.maghribOffset)), nextPrayer, Prayer.maghrib),
      isha: _buildPrayer('العشاء', ishaTime.add(Duration(minutes: _settings.ishaOffset)), nextPrayer, Prayer.isha),
      nextPrayer: nextPrayer,
    );

    _updateNextPrayerInfo(now);
  }

  PrayerModel _buildPrayer(String name, DateTime time, Prayer nextPrayer, Prayer prayer) {
    final now = DateTime.now();
    return PrayerModel(
      name: name,
      time: time,
      isNext: nextPrayer == prayer,
      isPassed: time.isBefore(now),
    );
  }

  void _updateNextPrayerInfo(DateTime now) {
    if (_prayerTimes == null) return;
    final next = _prayerTimes!.nextPrayerModel;
    _nextPrayerName = next.name;
    final diff = next.time.difference(now);
    _countdown = diff.isNegative ? Duration.zero : diff;
    _nextPrayerTime = _formatTime(next.time);
  }

  String _formatTime(DateTime time) {
    if (_settings.timeFormat24h) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final ampm = time.hour < 12 ? 'ص' : 'م';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $ampm';
    }
  }

  String formatTimeForDisplay(DateTime time) => _formatTime(time);

  String get countdownString {
    if (_countdown == Duration.zero) return '0د';
    final hours = _countdown.inHours;
    final minutes = _countdown.inMinutes.remainder(60);
    final seconds = _countdown.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}س ${minutes.toString().padLeft(2, '0')}د';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_prayerTimes != null) {
        _updateNextPrayerInfo(DateTime.now());
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
