import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetUpdateService {
  static const String appGroupId = 'com.wajhat.aldeen';
  static const String iOSWidgetName = 'IslamicWidget';
  static const String androidWidgetName = 'IslamicWidgetReceiver';

  static Future<void> updateWidget({
    required String dayName,
    required String currentTime,
    required String gregorianDate,
    required String hijriDate,
    required String nextPrayerName,
    required String nextPrayerTime,
    required String countdown,
    required String verseText,
    required String dhikrText,
    required int batteryLevel,
    required double yearProgress,
  }) async {
    try {
      await HomeWidget.saveWidgetData('day_name', dayName);
      await HomeWidget.saveWidgetData('current_time', currentTime);
      await HomeWidget.saveWidgetData('gregorian_date', gregorianDate);
      await HomeWidget.saveWidgetData('hijri_date', hijriDate);
      await HomeWidget.saveWidgetData('next_prayer_name', nextPrayerName);
      await HomeWidget.saveWidgetData('next_prayer_time', nextPrayerTime);
      await HomeWidget.saveWidgetData('prayer_countdown', countdown);
      await HomeWidget.saveWidgetData('current_verse', verseText);
      await HomeWidget.saveWidgetData('current_dhikr', dhikrText);
      await HomeWidget.saveWidgetData('battery_level', batteryLevel);
      await HomeWidget.saveWidgetData('year_progress', yearProgress);

      await HomeWidget.updateWidget(
        androidName: androidWidgetName,
      );
    } catch (_) {}
  }
}
