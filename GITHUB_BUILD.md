# كيف تحصل على APK جاهز (بدون تثبيت Flutter)

## الطريقة الأسهل: GitHub Actions (مجاني 100%)

### الخطوة 1: أنشئ حساب GitHub مجاني
- اذهب لـ https://github.com
- اضغط "Sign up" واتبع الخطوات

### الخطوة 2: أنشئ Repository جديد
- بعد الدخول، اضغط "+" في الزاوية اليمنى العلوية
- اختر "New repository"
- الاسم: `wajhat-aldeen`
- اضغط "Create repository"

### الخطوة 3: ارفع الملفات
- في صفحة الـ Repository، اضغط "uploading an existing file"
- استخرج ملف `.tar.gz` الذي نزّلته
- ارفع كل محتويات مجلد `wajhat_aldeen/` (كل الملفات والمجلدات)
- اضغط "Commit changes"

### الخطوة 4: انتظر بناء الـ APK (5-10 دقائق)
- اذهب لتبويب "Actions" في الـ Repository
- ستجد workflow باسم "Build APK" يعمل تلقائياً
- انتظر حتى يتحول إلى ✅ أخضر

### الخطوة 5: نزّل الـ APK
- اضغط على "Build APK" 
- في الأسفل ستجد "Artifacts"
- اضغط "wajhat-aldeen-apk" لتنزيل الـ APK مباشرة

### الخطوة 6: ثبّت على هاتفك
- انقل الـ APK لهاتفك Android
- فعّل "تثبيت من مصادر غير معروفة" في الإعدادات
- ثبّت الملف
