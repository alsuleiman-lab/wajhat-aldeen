import 'package:adhan/adhan.dart';

class PrayerModel {
  final String name;
  final DateTime time;
  final bool isNext;
  final bool isPassed;

  const PrayerModel({
    required this.name,
    required this.time,
    this.isNext = false,
    this.isPassed = false,
  });

  PrayerModel copyWith({bool? isNext, bool? isPassed}) {
    return PrayerModel(
      name: name,
      time: time,
      isNext: isNext ?? this.isNext,
      isPassed: isPassed ?? this.isPassed,
    );
  }
}

class PrayerTimesModel {
  final PrayerModel fajr;
  final PrayerModel sunrise;
  final PrayerModel dhuhr;
  final PrayerModel asr;
  final PrayerModel maghrib;
  final PrayerModel isha;
  final Prayer nextPrayer;

  const PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextPrayer,
  });

  List<PrayerModel> get allPrayers => [fajr, dhuhr, asr, maghrib, isha];

  PrayerModel get nextPrayerModel {
    switch (nextPrayer) {
      case Prayer.fajr:
        return fajr;
      case Prayer.dhuhr:
        return dhuhr;
      case Prayer.asr:
        return asr;
      case Prayer.maghrib:
        return maghrib;
      case Prayer.isha:
        return isha;
      default:
        return fajr;
    }
  }
}

class AppSettings {
  final CalculationMethod calculationMethod;
  final Madhab madhab;
  final double? customFajrAngle;
  final double? customIshaAngle;
  final int fajrOffset;
  final int sunriseOffset;
  final int dhuhrOffset;
  final int asrOffset;
  final int maghribOffset;
  final int ishaOffset;
  final int? fixedIshaAfterMaghrib; // minutes after maghrib
  final double? manualLatitude;
  final double? manualLongitude;
  final String? manualCityName;
  final bool useGps;
  final bool timeFormat24h;
  final int hijriOffset; // -1, 0, or +1

  const AppSettings({
    this.calculationMethod = CalculationMethod.muslimWorldLeague,
    this.madhab = Madhab.shafi,
    this.customFajrAngle,
    this.customIshaAngle,
    this.fajrOffset = 0,
    this.sunriseOffset = 0,
    this.dhuhrOffset = 0,
    this.asrOffset = 0,
    this.maghribOffset = 0,
    this.ishaOffset = 0,
    this.fixedIshaAfterMaghrib,
    this.manualLatitude,
    this.manualLongitude,
    this.manualCityName,
    this.useGps = true,
    this.timeFormat24h = true,
    this.hijriOffset = 0,
  });

  AppSettings copyWith({
    CalculationMethod? calculationMethod,
    Madhab? madhab,
    double? customFajrAngle,
    double? customIshaAngle,
    int? fajrOffset,
    int? sunriseOffset,
    int? dhuhrOffset,
    int? asrOffset,
    int? maghribOffset,
    int? ishaOffset,
    int? fixedIshaAfterMaghrib,
    double? manualLatitude,
    double? manualLongitude,
    String? manualCityName,
    bool? useGps,
    bool? timeFormat24h,
    int? hijriOffset,
  }) {
    return AppSettings(
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      customFajrAngle: customFajrAngle ?? this.customFajrAngle,
      customIshaAngle: customIshaAngle ?? this.customIshaAngle,
      fajrOffset: fajrOffset ?? this.fajrOffset,
      sunriseOffset: sunriseOffset ?? this.sunriseOffset,
      dhuhrOffset: dhuhrOffset ?? this.dhuhrOffset,
      asrOffset: asrOffset ?? this.asrOffset,
      maghribOffset: maghribOffset ?? this.maghribOffset,
      ishaOffset: ishaOffset ?? this.ishaOffset,
      fixedIshaAfterMaghrib: fixedIshaAfterMaghrib ?? this.fixedIshaAfterMaghrib,
      manualLatitude: manualLatitude ?? this.manualLatitude,
      manualLongitude: manualLongitude ?? this.manualLongitude,
      manualCityName: manualCityName ?? this.manualCityName,
      useGps: useGps ?? this.useGps,
      timeFormat24h: timeFormat24h ?? this.timeFormat24h,
      hijriOffset: hijriOffset ?? this.hijriOffset,
    );
  }
}
