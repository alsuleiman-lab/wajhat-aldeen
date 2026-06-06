import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/hijri_utils.dart';
import '../../../core/widgets/gold_divider.dart';

class CardDayTime extends StatelessWidget {
  final DateTime now;
  final bool timeFormat24h;

  const CardDayTime({
    super.key,
    required this.now,
    required this.timeFormat24h,
  });

  String _formatTime() {
    if (timeFormat24h) {
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final ampm = now.hour < 12 ? 'ص' : 'م';
      return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $ampm';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoldBorderCard(
      backgroundColor: AppColors.cardDay,
      child: Column(
        children: [
          // Day name in calligraphic Arabic
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: AppColors.goldGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              HijriUtils.getArabicDayName(now),
              style: AppTextStyles.dayName.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          // Gold thin divider
          const GoldDivider(width: 80),

          const SizedBox(height: 12),

          // Clock
          Text(
            _formatTime(),
            style: AppTextStyles.clockTime,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          // Gregorian date
          Text(
            HijriUtils.getGregorianDate(now),
            style: AppTextStyles.gregorianDate,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
