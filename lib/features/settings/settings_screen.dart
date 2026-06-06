import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/prayer_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/overlay_service.dart';
import '../../core/models/prayer_model.dart';
import '../../core/widgets/gold_divider.dart';
import '../home/widgets/main_board.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  bool _overlayRunning = false;
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _settings = context.read<PrayerService>().settings;
    _checkOverlay();
  }

  Future<void> _checkOverlay() async {
    final running = await OverlayService.isServiceRunning();
    if (mounted) setState(() => _overlayRunning = running);
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<PrayerService>().updateSettings(_settings);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الإعدادات', style: TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: AppColors.cardHijri,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            color: AppColors.textGold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textGold),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'حفظ',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textGold,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview
              _buildPreviewSection(),
              const SizedBox(height: 20),

              // AOD / Lockscreen
              _buildSection(
                title: 'شاشة القفل (AOD)',
                icon: Icons.screen_lock_portrait_outlined,
                child: _buildOverlaySection(),
              ),
              const SizedBox(height: 16),

              // Location
              _buildSection(
                title: 'الموقع الجغرافي',
                icon: Icons.location_on_outlined,
                child: _buildLocationSection(),
              ),
              const SizedBox(height: 16),

              // Calculation method
              _buildSection(
                title: 'هيئة حساب مواقيت الصلاة',
                icon: Icons.calculate_outlined,
                child: _buildCalculationSection(),
              ),
              const SizedBox(height: 16),

              // Madhab
              _buildSection(
                title: 'مذهب صلاة العصر',
                icon: Icons.menu_book_outlined,
                child: _buildMadhabSection(),
              ),
              const SizedBox(height: 16),

              // Custom angles
              _buildSection(
                title: 'زوايا الفجر والعشاء',
                icon: Icons.tune_outlined,
                child: _buildAnglesSection(),
              ),
              const SizedBox(height: 16),

              // Prayer offsets
              _buildSection(
                title: 'تعديل أوقات الصلاة (دقائق)',
                icon: Icons.more_time_outlined,
                child: _buildOffsetsSection(),
              ),
              const SizedBox(height: 16),

              // Fixed isha
              _buildSection(
                title: 'ضبط العشاء بعد المغرب',
                icon: Icons.alarm_outlined,
                child: _buildFixedIshaSection(),
              ),
              const SizedBox(height: 16),

              // Hijri offset
              _buildSection(
                title: 'تعديل التاريخ الهجري',
                icon: Icons.calendar_month_outlined,
                child: _buildHijriSection(),
              ),
              const SizedBox(height: 16),

              // Time format
              _buildSection(
                title: 'تنسيق الوقت',
                icon: Icons.access_time_outlined,
                child: _buildTimeFormatSection(),
              ),

              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textGold,
                  foregroundColor: AppColors.appBackground,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'حفظ جميع الإعدادات',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return GoldBorderCard(
      backgroundColor: AppColors.cardDay,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            'معاينة الواجهة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              color: AppColors.textGoldDim,
            ),
          ),
          const SizedBox(height: 8),
          const GoldDivider(),
          const SizedBox(height: 12),
          Transform.scale(
            scale: 0.75,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 280,
              child: IgnorePointer(
                child: MainBoard(
                  now: DateTime.now(),
                  batteryLevel: 80,
                  overlayRunning: _overlayRunning,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return GoldBorderCard(
      backgroundColor: AppColors.cardDay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textGold, size: 18),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.settingsTitle),
            ],
          ),
          const SizedBox(height: 12),
          const GoldDivider(width: double.infinity, thickness: 0.5),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildOverlaySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'تفعيل شاشة القفل الإسلامية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Switch(
              value: _overlayRunning,
              activeColor: AppColors.textGold,
              onChanged: (val) async {
                final hasPermission = await OverlayService.checkPermission();
                if (!hasPermission) {
                  await OverlayService.requestPermission();
                  return;
                }
                if (val) {
                  await OverlayService.startService();
                } else {
                  await OverlayService.stopService();
                }
                setState(() => _overlayRunning = val);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'تعرض واجهة الدين الحق على شاشة القفل بشكل دائم (AOD). يتطلب إذن "العرض فوق التطبيقات".',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 11,
            color: AppColors.passedPrayer,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    final locationService = context.watch<LocationService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // GPS toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('استخدام GPS التلقائي', style: AppTextStyles.settingsSubtitle),
            Switch(
              value: _settings.useGps,
              activeColor: AppColors.textGold,
              onChanged: (val) {
                setState(() {
                  _settings = _settings.copyWith(useGps: val);
                });
                if (val) {
                  locationService.requestGpsLocation().then((granted) {
                    if (granted && locationService.latitude != null) {
                      context.read<PrayerService>().setLocation(
                        locationService.latitude!,
                        locationService.longitude!,
                      );
                    }
                  });
                }
              },
            ),
          ],
        ),

        if (locationService.hasLocation) ...[
          const SizedBox(height: 8),
          Text(
            'الموقع الحالي: ${locationService.latitude?.toStringAsFixed(4)}, ${locationService.longitude?.toStringAsFixed(4)}',
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: AppColors.textGoldDim,
            ),
            textAlign: TextAlign.right,
          ),
        ],

        const SizedBox(height: 12),

        // Manual location
        const Text(
          'أو أدخل الموقع يدوياً:',
          style: AppTextStyles.settingsSubtitle,
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _latController,
                label: 'خط العرض',
                hint: '48.8566',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                controller: _lngController,
                label: 'خط الطول',
                hint: '2.3522',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _cityController,
          label: 'اسم المدينة',
          hint: 'باريس',
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final lat = double.tryParse(_latController.text);
            final lng = double.tryParse(_lngController.text);
            final city = _cityController.text.trim();
            if (lat != null && lng != null) {
              locationService.setManualLocation(lat, lng, city.isNotEmpty ? city : 'موقع مخصص');
              context.read<PrayerService>().setLocation(lat, lng);
              setState(() {
                _settings = _settings.copyWith(
                  manualLatitude: lat,
                  manualLongitude: lng,
                  manualCityName: city,
                  useGps: false,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعيين الموقع', style: TextStyle(fontFamily: 'Tajawal')),
                  backgroundColor: AppColors.cardHijri,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cardPrayer,
            foregroundColor: AppColors.textGold,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('تعيين الموقع', style: TextStyle(fontFamily: 'Tajawal')),
        ),
      ],
    );
  }

  Widget _buildCalculationSection() {
    final methods = PrayerService.calculationMethodNames;
    return Column(
      children: methods.entries.map((entry) {
        return RadioListTile<CalculationMethod>(
          value: entry.key,
          groupValue: _settings.calculationMethod,
          activeColor: AppColors.textGold,
          title: Text(
            entry.value,
            style: AppTextStyles.settingsSubtitle,
            textAlign: TextAlign.right,
          ),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _settings = _settings.copyWith(calculationMethod: val);
              });
            }
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildMadhabSection() {
    return Column(
      children: [
        RadioListTile<Madhab>(
          value: Madhab.shafi,
          groupValue: _settings.madhab,
          activeColor: AppColors.textGold,
          title: const Text('سني (شافعي، مالكي، حنبلي)', style: AppTextStyles.settingsSubtitle),
          onChanged: (val) {
            if (val != null) setState(() => _settings = _settings.copyWith(madhab: val));
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<Madhab>(
          value: Madhab.hanafi,
          groupValue: _settings.madhab,
          activeColor: AppColors.textGold,
          title: const Text('حنفي', style: AppTextStyles.settingsSubtitle),
          onChanged: (val) {
            if (val != null) setState(() => _settings = _settings.copyWith(madhab: val));
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAnglesSection() {
    return Column(
      children: [
        _buildAngleSlider(
          label: 'زاوية الفجر',
          value: _settings.customFajrAngle ?? 12.0,
          onChanged: (val) => setState(() => _settings = _settings.copyWith(customFajrAngle: val)),
        ),
        const SizedBox(height: 16),
        _buildAngleSlider(
          label: 'زاوية العشاء',
          value: _settings.customIshaAngle ?? 12.0,
          onChanged: (val) => setState(() => _settings = _settings.copyWith(customIshaAngle: val)),
        ),
      ],
    );
  }

  Widget _buildAngleSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${value.toStringAsFixed(1)}°',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: AppColors.textGold,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(label, style: AppTextStyles.settingsSubtitle),
          ],
        ),
        Slider(
          value: value,
          min: 10.0,
          max: 20.0,
          divisions: 20,
          activeColor: AppColors.textGold,
          inactiveColor: AppColors.cardBorderGoldBright,
          thumbColor: AppColors.textGold,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildOffsetsSection() {
    return Column(
      children: [
        _buildOffsetRow('الفجر', _settings.fajrOffset,
            (v) => setState(() => _settings = _settings.copyWith(fajrOffset: v))),
        _buildOffsetRow('الظهر', _settings.dhuhrOffset,
            (v) => setState(() => _settings = _settings.copyWith(dhuhrOffset: v))),
        _buildOffsetRow('العصر', _settings.asrOffset,
            (v) => setState(() => _settings = _settings.copyWith(asrOffset: v))),
        _buildOffsetRow('المغرب', _settings.maghribOffset,
            (v) => setState(() => _settings = _settings.copyWith(maghribOffset: v))),
        _buildOffsetRow('العشاء', _settings.ishaOffset,
            (v) => setState(() => _settings = _settings.copyWith(ishaOffset: v))),
      ],
    );
  }

  Widget _buildOffsetRow(String name, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => onChanged(value - 1),
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGold, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Container(
                width: 48,
                alignment: Alignment.center,
                child: Text(
                  value >= 0 ? '+$value' : '$value',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: value == 0 ? AppColors.textSecondary : AppColors.textGold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onChanged(value + 1),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.textGold, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Text(name, style: AppTextStyles.settingsSubtitle),
        ],
      ),
    );
  }

  Widget _buildFixedIshaSection() {
    final hasFixed = _settings.fixedIshaAfterMaghrib != null;
    final fixedValue = _settings.fixedIshaAfterMaghrib ?? 90;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تفعيل ضبط ثابت للعشاء', style: AppTextStyles.settingsSubtitle),
            Switch(
              value: hasFixed,
              activeColor: AppColors.textGold,
              onChanged: (val) {
                setState(() {
                  _settings = _settings.copyWith(
                    fixedIshaAfterMaghrib: val ? fixedValue : null,
                  );
                });
              },
            ),
          ],
        ),
        if (hasFixed) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (fixedValue > 30) {
                        setState(() => _settings = _settings.copyWith(
                              fixedIshaAfterMaghrib: fixedValue - 5,
                            ));
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGold),
                  ),
                  Text(
                    '$fixedValue دقيقة',
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: AppColors.textGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _settings = _settings.copyWith(
                            fixedIshaAfterMaghrib: fixedValue + 5,
                          ));
                    },
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.textGold),
                  ),
                ],
              ),
              const Text('بعد المغرب بـ:', style: AppTextStyles.settingsSubtitle),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHijriSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'تعديل التاريخ الهجري للمطابقة مع إعلانات رؤية الهلال المحلية',
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: AppColors.passedPrayer),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (_settings.hijriOffset > -1) {
                  setState(() => _settings = _settings.copyWith(
                        hijriOffset: _settings.hijriOffset - 1,
                      ));
                }
              },
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGold, size: 28),
            ),
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                _settings.hijriOffset == 0
                    ? 'تلقائي'
                    : _settings.hijriOffset > 0
                        ? '+${_settings.hijriOffset}'
                        : '${_settings.hijriOffset}',
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  color: AppColors.textGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_settings.hijriOffset < 1) {
                  setState(() => _settings = _settings.copyWith(
                        hijriOffset: _settings.hijriOffset + 1,
                      ));
                }
              },
              icon: const Icon(Icons.add_circle_outline, color: AppColors.textGold, size: 28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeFormatSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('توقيت 24 ساعة', style: AppTextStyles.settingsSubtitle),
        Switch(
          value: _settings.timeFormat24h,
          activeColor: AppColors.textGold,
          onChanged: (val) {
            setState(() => _settings = _settings.copyWith(timeFormat24h: val));
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.settingsSubtitle,
        hintStyle: const TextStyle(color: AppColors.passedPrayer, fontSize: 12),
        filled: true,
        fillColor: AppColors.appBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorderGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorderGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textGold),
        ),
      ),
    );
  }
}
