import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/hijri_utils.dart';

class CardStats extends StatelessWidget {
  final int batteryLevel;
  final double yearProgress;
  final int year;

  const CardStats({
    super.key,
    required this.batteryLevel,
    required this.yearProgress,
    required this.year,
  });

  Color _batteryColor(int level) {
    if (level > 60) return const Color(0xFF4CAF50);
    if (level > 25) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context) {
    final yearPercent = (yearProgress * 100).toStringAsFixed(1);
    final batteryColor = _batteryColor(batteryLevel);

    return GoldBorderCard(
      backgroundColor: AppColors.cardStats,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Year progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$yearPercent%',
                      style: AppTextStyles.statsValue,
                    ),
                    Text(
                      'السنة ${HijriUtils.toArabicNumerals(year)}',
                      style: AppTextStyles.statsLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: yearProgress,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textGold),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تقدم العام',
                  style: AppTextStyles.statsLabel.copyWith(fontSize: 10),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // Gold divider
          Container(
            width: 0.5,
            height: 50,
            color: AppColors.textGoldDim,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Battery
          Column(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular progress background
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 2.5,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    // Circular progress fill
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CircularProgressIndicator(
                        value: batteryLevel / 100.0,
                        strokeWidth: 2.5,
                        color: batteryColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    // Battery percentage text
                    Text(
                      '$batteryLevel',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: batteryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'البطارية',
                style: AppTextStyles.statsLabel.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
