import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

import 'core/services/database_service.dart';
import 'core/services/prayer_service.dart';
import 'core/services/location_service.dart';
import 'core/services/content_service.dart';
import 'core/services/widget_update_service.dart';
import 'core/services/overlay_service.dart';
import 'features/settings/settings_provider.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force RTL
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize timezone
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  // Initialize database
  await DatabaseService.instance.initialize();

  // Initialize content service (loads verses, dhikr)
  await ContentService.instance.initialize();

  runApp(const WajhatAlDeenApp());
}

class WajhatAlDeenApp extends StatelessWidget {
  const WajhatAlDeenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => PrayerService()..initialize()),
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => ContentService.instance),
      ],
      child: MaterialApp(
        title: 'واجهة الدين الحق',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [Locale('ar', 'SA')],
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0B0C10),
          fontFamily: 'Tajawal',
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC9A84C),
            secondary: Color(0xFF1F2833),
            surface: Color(0xFF0B0C10),
          ),
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}
