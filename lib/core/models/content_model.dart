class VerseModel {
  final int id;
  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final String verseText;
  final String tafseer;

  const VerseModel({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    required this.verseText,
    required this.tafseer,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] as int,
      surahNumber: json['surah'] as int,
      verseNumber: json['verse'] as int,
      surahName: json['surah_name'] as String,
      verseText: json['text'] as String,
      tafseer: json['tafseer'] as String,
    );
  }

  String get reference => '${surahName} - الآية $verseNumber';
}

enum DhikrCategory {
  morning,
  evening,
  general,
  istighfar,
}

class DhikrModel {
  final int id;
  final String text;
  final String source;
  final DhikrCategory category;
  final int count;

  const DhikrModel({
    required this.id,
    required this.text,
    required this.source,
    required this.category,
    this.count = 1,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    DhikrCategory cat;
    switch (json['category'] as String) {
      case 'morning':
        cat = DhikrCategory.morning;
        break;
      case 'evening':
        cat = DhikrCategory.evening;
        break;
      case 'istighfar':
        cat = DhikrCategory.istighfar;
        break;
      default:
        cat = DhikrCategory.general;
    }
    return DhikrModel(
      id: json['id'] as int,
      text: json['text'] as String,
      source: json['source'] as String,
      category: cat,
      count: json['count'] as int? ?? 1,
    );
  }
}
