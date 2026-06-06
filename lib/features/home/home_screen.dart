import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

import '../../core/constants/app_colors.dart';
import '../../core/services/prayer_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/content_service.dart';
import '../../core/services/overlay_service.dart';
import '../../core/services/widget_update_service.dart';
import '../../core/utils/hijri_utils.dart';
import '../settings/settings_screen.dart';
import 'widgets/main_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();
  bool _overlayRunning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startClockTimer();
    _initBattery();
    _initLocation();
    _checkOverlayStatus();
    _requestPermissions();
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
      _updateWidget();
    });
  }

  Future<void> _initBattery() async {
    try {
      _batteryLevel = await _battery.batteryLevel;
      setState(() {});
      _battery.onBatteryStateChanged.listen((_) async {
        final level = await _battery.batteryLevel;
        if (mounted) setState(() => _batteryLevel = level);
      });
    } catch (_) {}
  }

  Future<void> _initLocation() async {
    final locationService = context.read<LocationService>();
    await locationService.initialize();
    if (locationService.hasLocation) {
      _applyLocation(locationService);
    } else {
      final granted = await locationService.requestGpsLocation();
      if (granted && mounted) {
        _applyLocation(locationService);
      }
    }
  }

  void _applyLocation(LocationService loc) {
    if (loc.latitude != null && loc.longitude != null) {
      context.read<PrayerService>().setLocation(loc.latitude!, loc.longitude!);
    }
  }

  Future<void> _checkOverlayStatus() async {
    final running = await OverlayService.isServiceRunning();
    if (mounted) setState(() => _overlayRunning = running);
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
    ].request();
  }

  void _updateWidget() {
    final prayer = context.read<PrayerService>();
    final content = ContentService.instance;
    final settings = prayer.settings;

    WidgetUpdateService.updateWidget(
      dayName: HijriUtils.getArabicDayName(_now),
      currentTime: _formatClock(settings.timeFormat24h),
      gregorianDate: HijriUtils.getGregorianDate(_now),
      hijriDate: HijriUtils.getHijriDate(settings.hijriOffset),
      nextPrayerName: prayer.nextPrayerName,
      nextPrayerTime: prayer.nextPrayerTime,
      countdown: prayer.countdownString,
      verseText: content.currentVerse?.verseText ?? '',
      dhikrText: content.currentDhikr?.text ?? '',
      batteryLevel: _batteryLevel,
      yearProgress: HijriUtils.getYearProgress(),
    );
  }

  String _formatClock(bool format24h) {
    if (format24h) {
      return '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
      final ampm = _now.hour < 12 ? 'ص' : 'م';
      return '${hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')} $ampm';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Main board (scrollable)
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: MainBoard(
                now: _now,
                batteryLevel: _batteryLevel,
                overlayRunning: _overlayRunning,
              ),
            ),

            // Settings FAB
            Positioned(
              bottom: 24,
              left: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                  _checkOverlayStatus();
                },
                backgroundColor: AppColors.cardDay,
                foregroundColor: AppColors.textGold,
                elevation: 8,
                child: const Icon(Icons.settings_outlined),
              ),
            ),

            // Overlay toggle FAB
            Positioned(
              bottom: 24,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: _toggleOverlay,
                backgroundColor: _overlayRunning
                    ? AppColors.cardHijri
                    : AppColors.cardDay,
                foregroundColor: AppColors.textGold,
                elevation: 8,
                icon: Icon(
                  _overlayRunning
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                label: Text(
                  _overlayRunning ? 'إيقاف AOD' : 'تفعيل AOD',
                  style: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleOverlay() async {
    final hasPermission = await OverlayService.checkPermission();
    if (!hasPermission) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardDay,
          title: const Text(
            'إذن مطلوب',
            style: TextStyle(color: AppColors.textGold, fontFamily: 'Tajawal'),
          ),
          content: const Text(
            'يحتاج التطبيق إذن "العرض فوق التطبيقات الأخرى" لتشغيل شاشة القفل الإسلامية.',
            style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Tajawal'),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                OverlayService.requestPermission();
              },
              child: const Text('منح الإذن', style: TextStyle(color: AppColors.textGold)),
            ),
          ],
        ),
      );
      return;
    }

    if (_overlayRunning) {
      await OverlayService.stopService();
    } else {
      await OverlayService.startService();
    }

    if (mounted) {
      setState(() => _overlayRunning = !_overlayRunning);
    }
  }
}
