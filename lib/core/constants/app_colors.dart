import 'package:flutter/material.dart';

class AppColors {
  // Primary backgrounds
  static const Color appBackground = Color(0xFF0B0C10);
  static const Color cardDay = Color(0xFF1F2833);
  static const Color cardHijri = Color(0xFF1A331E);
  static const Color cardPrayer = Color(0xFF0B1D33);
  static const Color cardVerse = Color(0xFF142416);
  static const Color cardDhikr = Color(0xFF2C3539);
  static const Color cardStats = Color(0xFF1F2833);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFEAEAEA);
  static const Color textGold = Color(0xFFC9A84C);
  static const Color textGoldLight = Color(0xFFD4B966);
  static const Color textGoldDim = Color(0xFF9B7E3A);

  // Gold gradient stops
  static const List<Color> goldGradient = [
    Color(0xFFD4B966),
    Color(0xFFC9A84C),
    Color(0xFF9B7E3A),
  ];

  // Card border gold
  static const Color cardBorderGold = Color(0xFF2A2215);
  static const Color cardBorderGoldBright = Color(0xFF3D3118);

  // Overlay
  static const Color overlayBackground = Color(0xCC0B0C10);

  // Prayer indicator
  static const Color nextPrayerHighlight = Color(0xFFC9A84C);
  static const Color passedPrayer = Color(0xFF4A5568);
  static const Color futurePrayer = Color(0xFF718096);
}

class AppTextStyles {
  static const String fontArabicCalligraphy = 'Amiri';
  static const String fontQuran = 'KFGQPCUthmanTahaNaskh';
  static const String fontUI = 'Tajawal';

  static TextStyle get dayName => const TextStyle(
        fontFamily: fontArabicCalligraphy,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textGold,
        height: 1.4,
      );

  static TextStyle get clockTime => const TextStyle(
        fontFamily: fontUI,
        fontSize: 38,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      );

  static TextStyle get gregorianDate => const TextStyle(
        fontFamily: fontUI,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get hijriDateLarge => const TextStyle(
        fontFamily: fontArabicCalligraphy,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get hijriMonth => const TextStyle(
        fontFamily: fontArabicCalligraphy,
        fontSize: 18,
        color: AppColors.textGold,
        height: 1.4,
      );

  static TextStyle get prayerName => const TextStyle(
        fontFamily: fontArabicCalligraphy,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textGold,
        height: 1.5,
      );

  static TextStyle get prayerTime => const TextStyle(
        fontFamily: fontUI,
        fontSize: 30,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
        letterSpacing: 1,
      );

  static TextStyle get countdown => const TextStyle(
        fontFamily: fontUI,
        fontSize: 13,
        color: AppColors.textSecondary,
      );

  static TextStyle get verseText => const TextStyle(
        fontFamily: fontQuran,
        fontSize: 19,
        color: AppColors.textPrimary,
        height: 2.0,
        wordSpacing: 3,
      );

  static TextStyle get tafseeerText => const TextStyle(
        fontFamily: fontUI,
        fontSize: 12,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle get dhikrText => const TextStyle(
        fontFamily: fontArabicCalligraphy,
        fontSize: 15,
        color: AppColors.textPrimary,
        height: 1.8,
      );

  static TextStyle get dhikrSource => const TextStyle(
        fontFamily: fontUI,
        fontSize: 11,
        color: AppColors.textGoldDim,
        fontStyle: FontStyle.italic,
      );

  static TextStyle get statsLabel => const TextStyle(
        fontFamily: fontUI,
        fontSize: 12,
        color: AppColors.textSecondary,
      );

  static TextStyle get statsValue => const TextStyle(
        fontFamily: fontUI,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textGold,
      );

  static TextStyle get settingsTitle => const TextStyle(
        fontFamily: fontUI,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get settingsSubtitle => const TextStyle(
        fontFamily: fontUI,
        fontSize: 13,
        color: AppColors.textSecondary,
      );
}
