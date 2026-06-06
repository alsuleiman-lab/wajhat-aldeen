import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/content_model.dart';

class CardDhikr extends StatelessWidget {
  final DhikrModel? dhikr;

  const CardDhikr({super.key, this.dhikr});

  String _getCategoryLabel(DhikrCategory? cat) {
    switch (cat) {
      case DhikrCategory.morning:
        return '— أذكار الصباح';
      case DhikrCategory.evening:
        return '— أذكار المساء';
      case DhikrCategory.istighfar:
        return '— الاستغفار';
      case DhikrCategory.general:
        return '— أذكار';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoldBorderCard(
      backgroundColor: AppColors.cardDhikr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✦', style: TextStyle(color: AppColors.textGoldDim, fontSize: 10)),
              const SizedBox(width: 8),
              Text(
                dhikr != null ? _getCategoryLabel(dhikr!.category) : 'الأذكار اليومية',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: AppColors.textGoldDim,
                ),
              ),
              const SizedBox(width: 8),
              const Text('✦', style: TextStyle(color: AppColors.textGoldDim, fontSize: 10)),
            ],
          ),

          const SizedBox(height: 14),

          // Dhikr text
          if (dhikr != null) ...[
            // Opening quote mark
            const Text(
              '❝',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: AppColors.textGoldDim,
              ),
              textAlign: TextAlign.right,
            ),

            const SizedBox(height: 6),

            Text(
              dhikr!.text,
              style: AppTextStyles.dhikrText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),

            const SizedBox(height: 10),

            // Source and count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (dhikr!.count > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.textGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.textGoldDim, width: 0.5),
                    ),
                    child: Text(
                      '× ${dhikr!.count}',
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: AppColors.textGold,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                Text(
                  dhikr!.source,
                  style: AppTextStyles.dhikrSource,
                  textAlign: TextAlign.left,
                ),
              ],
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
