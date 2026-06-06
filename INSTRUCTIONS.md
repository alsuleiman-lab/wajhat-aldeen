# واجهة الدين الحق — تعليمات التشغيل

## متطلبات البناء
- Flutter SDK 3.19+ (https://flutter.dev/docs/get-started/install)
- Android Studio أو VS Code مع Flutter plugin
- جهاز Android 8+ أو محاكي

---

## خطوة 1: تنزيل الخطوط المطلوبة

يجب تنزيل الخطوط التالية ووضعها في مجلد `assets/fonts/`:

### 1. خط Amiri (تراثي فخم - مجاني)
- رابط: https://fonts.google.com/specimen/Amiri
- الملفات المطلوبة:
  - `assets/fonts/Amiri-Regular.ttf`
  - `assets/fonts/Amiri-Bold.ttf`

### 2. خط Tajawal (حديث للواجهة - مجاني)
- رابط: https://fonts.google.com/specimen/Tajawal
- الملفات المطلوبة:
  - `assets/fonts/Tajawal-Regular.ttf`
  - `assets/fonts/Tajawal-Medium.ttf`
  - `assets/fonts/Tajawal-Bold.ttf`

### 3. خط KFGQPC Uthman Taha Naskh (للقرآن الكريم - مجاني)
- رابط التنزيل: https://qurancomplex.gov.sa/en/technic/
- اسم الملف: `UthmanTN1B-Regular.ttf`
- ضعه في: `assets/fonts/UthmanTN1B-Regular.ttf`
- **بديل مؤقت**: يمكن تنزيله من: https://github.com/mustafa0x/qpc-fonts

---

## خطوة 2: تثبيت الحزم

```bash
cd wajhat_aldeen
flutter pub get
```

---

## خطوة 3: تشغيل التطبيق

```bash
# على جهاز متصل أو محاكي
flutter run

# أو لبناء APK للتوزيع
flutter build apk --release
```

---

## خطوة 4: إعداد التطبيق بعد التثبيت

1. **إذن شاشة القفل**: اذهب للإعدادات ← واجهة الدين الحق ← منح إذن "العرض فوق التطبيقات"
2. **إذن الموقع**: اسمح بالوصول للموقع لحساب مواقيت الصلاة
3. **إعدادات البطارية**: اسمح للتطبيق بالعمل في الخلفية (Battery Optimization ← All apps ← واجهة الدين الحق ← Don't optimize)
4. **تفعيل AOD**: في الشاشة الرئيسية، اضغط زر "تفعيل AOD"
5. **الـ Widget**: اضغط مطولاً على الشاشة الرئيسية ← Widgets ← ابحث عن "واجهة الدين الحق" ← ضع الـ Widget بحجم 4x4

---

## الميزات المنجزة

| الميزة | الحالة |
|--------|--------|
| ٦ بطاقات (يوم، هجري، صلاة، آية، ذكر، إحصائيات) | ✅ |
| أوقات الصلاة بـ ١١ هيئة حساب | ✅ |
| UOIF كهيئة افتراضية | ✅ |
| تعديل زوايا الفجر والعشاء | ✅ |
| تعديل دقائق كل صلاة بشكل منفصل | ✅ |
| ضبط العشاء بعد المغرب بدقائق ثابتة | ✅ |
| مذهب حساب العصر (حنفي / سني) | ✅ |
| GPS تلقائي + إدخال يدوي | ✅ |
| تاريخ هجري بحساب فلكي + تعديل ±١ يوم | ✅ |
| آيات قرآنية من قاعدة بيانات محلية | ✅ |
| تفسير مختصر لكل آية | ✅ |
| تجديد الآية والذكر كل ساعة ذكياً | ✅ |
| أذكار صباح/مساء/استغفار/عامة حسب الوقت | ✅ |
| عداد تنازلي للصلاة القادمة | ✅ |
| شاشة القفل (Foreground Service + SYSTEM_ALERT_WINDOW) | ✅ |
| Widget كاملة للشاشة الرئيسية (Android 12+) | ✅ |
| حماية AMOLED من الـ Burn-in (Pixel Shifting) | ✅ |
| واجهة إعدادات كاملة مع معاينة | ✅ |
| ألوان ذهبية فاخرة + خطوط تراثية | ✅ |
| دعم RTL كامل | ✅ |
| تنسيق الوقت ١٢/٢٤ ساعة قابل للتبديل | ✅ |
| نسبة السنة ونسبة البطارية | ✅ |
| يعمل بدون إنترنت (عدا تحديد الموقع) | ✅ |

---

## هيكل المشروع

```
wajhat_aldeen/
├── lib/
│   ├── main.dart                          # نقطة الدخول
│   ├── core/
│   │   ├── constants/app_colors.dart      # الألوان والأنماط النصية
│   │   ├── models/                        # نماذج البيانات
│   │   ├── services/                      # الخدمات (صلاة، موقع، محتوى...)
│   │   ├── utils/hijri_utils.dart         # التاريخ الهجري والأدوات
│   │   └── widgets/                       # بطاقات قابلة لإعادة الاستخدام
│   └── features/
│       ├── home/                          # الشاشة الرئيسية + البطاقات الست
│       └── settings/                      # شاشة الإعدادات الكاملة
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml            # الأذونات والخدمات
│       └── kotlin/com/wajhat/aldeen/
│           ├── MainActivity.kt            # نقطة الدخول
│           ├── LockscreenOverlayService.kt # خدمة شاشة القفل
│           ├── IslamicWidgetReceiver.kt   # مستقبل الـ Widget
│           └── BootReceiver.kt            # إعادة التشغيل التلقائي
└── assets/
    ├── fonts/                             # الخطوط (تنزيل يدوياً)
    └── data/
        ├── quran.json                     # آيات قرآنية مع تفاسير
        └── hisnul_muslim.json             # أذكار حصن المسلم
```
