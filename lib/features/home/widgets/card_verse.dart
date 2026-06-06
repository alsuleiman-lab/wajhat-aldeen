import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/content_model.dart';
import '../../../core/widgets/gold_divider.dart';

class CardVerse extends StatelessWidget {
  final VerseModel? verse;

  const CardVerse({super.key, this.verse});

  @override
  Widget build(BuildContext context) {
    return GoldBorderCard(
      backgroundColor: AppColors.cardVerse,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✦', style: TextStyle(color: AppColors.textGoldDim, fontSize: 10)),
              const SizedBox(width: 8),
              const Text(
                'آية كريمة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: AppColors.textGoldDim,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text('✦', style: TextStyle(color: AppColors.textGoldDim, fontSize: 10)),
            ],
          ),

          const SizedBox(height: 12),
          const GoldDivider(width: 120),
          const SizedBox(height: 16),

          // Verse in Quranic font
          if (verse != null) ...[
            Text(
              '﴿ ${verse!.verseText} ﴾',
              style: AppTextStyles.verseText,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 12),

            // Reference
            Text(
              verse!.reference,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                color: AppColors.textGold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Thin separator
            Container(
              height: 0.5,
              color: AppColors.cardBorderGoldBright,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),

            const SizedBox(height: 12),

            // Tafseer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'التفسير المختصر',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 11,
                      color: AppColors.textGoldDim,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    verse!.tafseer,
                    style: AppTextStyles.tafseeerText,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ] else ...[
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.textGold,
                strokeWidth: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
