import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/content_model.dart';
import 'database_service.dart';

class ContentService extends ChangeNotifier {
  static final ContentService instance = ContentService._internal();
  ContentService._internal();

  VerseModel? _currentVerse;
  DhikrModel? _currentDhikr;
  Timer? _updateTimer;

  VerseModel? get currentVerse => _currentVerse;
  DhikrModel? get currentDhikr => _currentDhikr;

  Future<void> initialize() async {
    await _refreshContent();
    _startHourlyTimer();
  }

  String _getDhikrCategory() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'morning';
    if (hour >= 15 && hour < 19) return 'evening';
    if (hour >= 22 || hour < 4) return 'istighfar';
    return 'general';
  }

  Future<void> _refreshContent() async {
    final verseMap = await DatabaseService.instance.getSmartVerse();
    if (verseMap != null) {
      _currentVerse = VerseModel.fromJson(verseMap);
    }

    final category = _getDhikrCategory();
    final dhikrMap = await DatabaseService.instance.getSmartDhikr(category);
    if (dhikrMap != null) {
      _currentDhikr = DhikrModel.fromJson(dhikrMap);
    }

    notifyListeners();
  }

  void _startHourlyTimer() {
    _updateTimer?.cancel();
    // Calculate time until next hour
    final now = DateTime.now();
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final initialDelay = nextHour.difference(now);

    Timer(initialDelay, () async {
      await _refreshContent();
      _updateTimer = Timer.periodic(const Duration(hours: 1), (_) async {
        await _refreshContent();
      });
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
