import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/hijri_utils.dart';
import '../../../core/widgets/gold_divider.dart';

class CardHijri extends StatelessWidget {
  final int hijriOffset;

  const CardHijri({super.key, required this.hijriOffset});

  @override
  Widget build(BuildContext context) {
    final baseDate = DateTime.now().add(Duration(days: hijriOffset));
    final hijri = HijriCalendar.fromDate(baseDate);
    final day = HijriUtils.toArabicNumerals(hijri.hDay);
    final month = HijriUtils.hijriMonths[hijri.hMonth - 1];

    return GoldBorderCard(
      backgroundColor: AppColors.cardHijri,
      child: Row(
        children: [
          // Day number large
          Expanded(
            flex: 2,
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: AppColors.goldGradient,
              ).createShader(b),
              child: Text(
                day,
                style: AppTextStyles.hijriDateLarge.copyWith(
                  fontSize: 52,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Thin gold separator
          Container(
            width: 0.8,
            height: 60,
            color: AppColors.textGoldDim,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Month & label
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  month,
                  style: AppTextStyles.hijriMonth,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                const GoldDivider(width: 60),
                const SizedBox(height: 4),
                Text(
                  'التاريخ الهجري',
                  style: AppTextStyles.gregorianDate,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
