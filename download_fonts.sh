#!/bin/bash
# سكريبت تنزيل الخطوط تلقائياً
# شغّله بعد clone المشروع: bash download_fonts.sh

FONTS_DIR="assets/fonts"
mkdir -p "$FONTS_DIR"

echo "⬇️  جارٍ تنزيل خطوط Google Fonts..."

# Amiri
curl -L "https://fonts.gstatic.com/s/amiri/v27/J7aRnpd8CGxBHqUpvrIw74NL.ttf" -o "$FONTS_DIR/Amiri-Regular.ttf" && echo "✅ Amiri-Regular"
curl -L "https://fonts.gstatic.com/s/amiri/v27/J7acnpd8CGxBHp2VkaY6zp5yHOc.ttf" -o "$FONTS_DIR/Amiri-Bold.ttf" && echo "✅ Amiri-Bold"

# Tajawal
curl -L "https://fonts.gstatic.com/s/tajawal/v9/Iura6YBj_oCad4k1l5qjHqBfVMI.ttf" -o "$FONTS_DIR/Tajawal-Regular.ttf" && echo "✅ Tajawal-Regular"
curl -L "https://fonts.gstatic.com/s/tajawal/v9/Iura6YBj_oCad4k1l8ajHqBfVMI.ttf" -o "$FONTS_DIR/Tajawal-Medium.ttf" && echo "✅ Tajawal-Medium"
curl -L "https://fonts.gstatic.com/s/tajawal/v9/Iura6YBj_oCad4k1nMejHqBfVMI.ttf" -o "$FONTS_DIR/Tajawal-Bold.ttf" && echo "✅ Tajawal-Bold"

echo ""
echo "⚠️  خط المصحف يحتاج تنزيلاً يدوياً:"
echo "   1. اذهب لـ: https://github.com/mustafa0x/qpc-fonts"
echo "   2. نزّل: UthmanTN1B-Regular.ttf"
echo "   3. ضعه في: $FONTS_DIR/UthmanTN1B-Regular.ttf"
echo ""
echo "✅ الانتهاء! الآن شغّل: flutter pub get && flutter run"
