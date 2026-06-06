import 'package:hijri/hijri_calendar.dart';

class HijriUtils {
  static const List<String> hijriMonths = [
    'محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر',
    'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
    'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
  ];

  static const List<String> arabicDays = [
    'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء',
    'الخميس', 'الجمعة', 'السبت',
  ];

  static const List<String> arabicNumerals = [
    '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'
  ];

  static String toArabicNumerals(int number) {
    return number.toString().split('').map((c) {
      final d = int.tryParse(c);
      return d != null ? arabicNumerals[d] : c;
    }).join();
  }

  static String getHijriDate(int offset) {
    final hijri = HijriCalendar.now();
    // Apply offset by manipulating the date
    final baseDate = DateTime.now().add(Duration(days: offset));
    final adjustedHijri = HijriCalendar.fromDate(baseDate);

    final day = toArabicNumerals(adjustedHijri.hDay);
    final month = hijriMonths[adjustedHijri.hMonth - 1];
    final year = toArabicNumerals(adjustedHijri.hYear);

    return '$day $month $year';
  }

  static String getHijriDayMonth(int offset) {
    final baseDate = DateTime.now().add(Duration(days: offset));
    final adjustedHijri = HijriCalendar.fromDate(baseDate);

    final day = toArabicNumerals(adjustedHijri.hDay);
    final month = hijriMonths[adjustedHijri.hMonth - 1];

    return '$day\n$month';
  }

  static String getArabicDayName(DateTime date) {
    return arabicDays[date.weekday % 7];
  }

  static String getGregorianDate(DateTime date) {
    const List<String> months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    final day = toArabicNumerals(date.day);
    final month = months[date.month - 1];
    final year = toArabicNumerals(date.year);
    return '$day $month $year';
  }

  static double getYearProgress() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);
    final totalDays = endOfYear.difference(startOfYear).inDays;
    final passedDays = now.difference(startOfYear).inDays;
    return passedDays / totalDays;
  }
}
