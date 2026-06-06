import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/prayer_service.dart';
import '../../../core/services/content_service.dart';
import '../../../core/utils/hijri_utils.dart';
import 'card_day_time.dart';
import 'card_hijri.dart';
import 'card_prayer_times.dart';
import 'card_verse.dart';
import 'card_dhikr.dart';
import 'card_stats.dart';

class MainBoard extends StatelessWidget {
  final DateTime now;
  final int batteryLevel;
  final bool overlayRunning;

  const MainBoard({
    super.key,
    required this.now,
    required this.batteryLevel,
    required this.overlayRunning,
  });

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerService>();
    final contentService = context.watch<ContentService>();
    final settings = prayerService.settings;

    final yearProgress = HijriUtils.getYearProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // App title
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 8),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: AppColors.goldGradient,
                ).createShader(bounds),
                child: const Text(
                  'واجهة الدين الحق',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 60),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.textGoldDim,
                      AppColors.textGold,
                      AppColors.textGoldDim,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Card 1: Day & Time
        CardDayTime(
          now: now,
          timeFormat24h: settings.timeFormat24h,
        ),

        const SizedBox(height: 12),

        // Card 2: Hijri Date
        CardHijri(hijriOffset: settings.hijriOffset),

        const SizedBox(height: 12),

        // Card 3: Prayer Times
        CardPrayerTimes(prayerService: prayerService),

        const SizedBox(height: 12),

        // Card 4: Verse + Tafseer
        CardVerse(verse: contentService.currentVerse),

        const SizedBox(height: 12),

        // Card 5: Dhikr
        CardDhikr(dhikr: contentService.currentDhikr),

        const SizedBox(height: 12),

        // Card 6: Stats
        CardStats(
          batteryLevel: batteryLevel,
          yearProgress: yearProgress,
          year: now.year,
        ),

        // AOD status indicator
        if (overlayRunning) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardHijri.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textGoldDim, width: 0.5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                SizedBox(width: 8),
                Text(
                  'شاشة القفل الإسلامية تعمل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
