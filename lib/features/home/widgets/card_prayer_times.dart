import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/prayer_service.dart';
import '../../../core/models/prayer_model.dart';
import '../../../core/widgets/gold_divider.dart';

class CardPrayerTimes extends StatelessWidget {
  final PrayerService prayerService;

  const CardPrayerTimes({super.key, required this.prayerService});

  @override
  Widget build(BuildContext context) {
    final pt = prayerService.prayerTimes;
    final settings = prayerService.settings;

    if (pt == null) {
      return GoldBorderCard(
        backgroundColor: AppColors.cardPrayer,
        child: Column(
          children: [
            const Text(
              'أوقات الصلاة',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: AppColors.textGold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'جارٍ تحديد الموقع...',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GoldBorderCard(
      backgroundColor: AppColors.cardPrayer,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'أوقات الصلاة',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  color: AppColors.textGold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const GoldDivider(width: 100),
          const SizedBox(height: 12),

          // Next prayer highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.textGold.withOpacity(0.15),
                  AppColors.textGold.withOpacity(0.05),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textGoldDim, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'متبقي',
                      style: AppTextStyles.countdown,
                    ),
                    Text(
                      prayerService.countdownString,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      prayerService.nextPrayerName,
                      style: AppTextStyles.prayerName,
                    ),
                    Text(
                      prayerService.nextPrayerTime,
                      style: AppTextStyles.prayerTime.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // All prayers list
          ...pt.allPrayers.map((p) => _buildPrayerRow(p, settings.timeFormat24h)),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(PrayerModel prayer, bool format24h) {
    final isNext = prayer.isNext;
    final isPassed = prayer.isPassed && !isNext;

    String timeStr;
    if (format24h) {
      timeStr =
          '${prayer.time.hour.toString().padLeft(2, '0')}:${prayer.time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = prayer.time.hour % 12 == 0 ? 12 : prayer.time.hour % 12;
      final ampm = prayer.time.hour < 12 ? 'ص' : 'م';
      timeStr =
          '${hour.toString().padLeft(2, '0')}:${prayer.time.minute.toString().padLeft(2, '0')} $ampm';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isNext
            ? AppColors.textGold.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isNext
            ? Border.all(color: AppColors.textGoldDim, width: 0.5)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeStr,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
              color: isNext
                  ? AppColors.textGold
                  : isPassed
                      ? AppColors.passedPrayer
                      : AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          Row(
            children: [
              if (isNext)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.textGold,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                prayer.name,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 17,
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  color: isNext
                      ? AppColors.textGold
                      : isPassed
                          ? AppColors.passedPrayer
                          : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
