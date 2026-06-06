import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Database? _db;

  Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wajhat_aldeen.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE verses (
            id INTEGER PRIMARY KEY,
            surah INTEGER NOT NULL,
            verse INTEGER NOT NULL,
            surah_name TEXT NOT NULL,
            text TEXT NOT NULL,
            tafseer TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE dhikr (
            id INTEGER PRIMARY KEY,
            text TEXT NOT NULL,
            source TEXT NOT NULL,
            category TEXT NOT NULL,
            count INTEGER DEFAULT 1
          )
        ''');

        await db.execute('''
          CREATE TABLE shown_verses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            verse_id INTEGER NOT NULL,
            shown_at INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE shown_dhikr (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dhikr_id INTEGER NOT NULL,
            shown_at INTEGER NOT NULL
          )
        ''');

        await _seedVerses(db);
        await _seedDhikr(db);
      },
    );
  }

  Future<void> _seedVerses(Database db) async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/data/quran.json');
      final List<dynamic> data = json.decode(jsonStr);
      final batch = db.batch();
      for (final item in data) {
        batch.insert('verses', {
          'id': item['id'],
          'surah': item['surah'],
          'verse': item['verse'],
          'surah_name': item['surah_name'],
          'text': item['text'],
          'tafseer': item['tafseer'],
        });
      }
      await batch.commit(noResult: true);
    } catch (e) {
      await _insertSampleVerses(db);
    }
  }

  Future<void> _seedDhikr(Database db) async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/data/hisnul_muslim.json');
      final List<dynamic> data = json.decode(jsonStr);
      final batch = db.batch();
      for (final item in data) {
        batch.insert('dhikr', {
          'id': item['id'],
          'text': item['text'],
          'source': item['source'],
          'category': item['category'],
          'count': item['count'] ?? 1,
        });
      }
      await batch.commit(noResult: true);
    } catch (e) {
      await _insertSampleDhikr(db);
    }
  }

  Future<void> _insertSampleVerses(Database db) async {
    final verses = [
      {'id': 1, 'surah': 1, 'verse': 1, 'surah_name': 'الفاتحة', 'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'tafseer': 'أبتدئ بكل اسم لله تعالى، والرحمن: ذو الرحمة الواسعة، والرحيم: ذو الرحمة الخاصة بالمؤمنين.'},
      {'id': 2, 'surah': 1, 'verse': 2, 'surah_name': 'الفاتحة', 'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'tafseer': 'الثناء لله وحده على نعمه الظاهرة والباطنة، وهو رب كل شيء ومالكه.'},
      {'id': 3, 'surah': 2, 'verse': 255, 'surah_name': 'البقرة', 'text': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ', 'tafseer': 'آية الكرسي: الله وحده المعبود بحق، الحي الدائم القيام على كل شيء، لا تغلبه سِنة ولا نوم.'},
      {'id': 4, 'surah': 3, 'verse': 18, 'surah_name': 'آل عمران', 'text': 'شَهِدَ اللَّهُ أَنَّهُ لَا إِلَٰهَ إِلَّا هُوَ وَالْمَلَائِكَةُ وَأُولُو الْعِلْمِ قَائِمًا بِالْقِسْطِ', 'tafseer': 'أعلم الله وأخبر بأنه لا معبود بحق سواه، وشهدت بذلك ملائكته وأهل العلم.'},
      {'id': 5, 'surah': 55, 'verse': 13, 'surah_name': 'الرحمن', 'text': 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ', 'tafseer': 'فبأي نعم ربكما أيها الثقلان تكذبان وتجحدان؟ ولا نعمة إلا منه.'},
      {'id': 6, 'surah': 93, 'verse': 11, 'surah_name': 'الضحى', 'text': 'وَأَمَّا بِنِعْمَةِ رَبِّكَ فَحَدِّثْ', 'tafseer': 'وأما نعمة ربك عليك بالنبوة والقرآن والهداية فاشكرها وأعلنها وحدث بها الناس.'},
      {'id': 7, 'surah': 94, 'verse': 5, 'surah_name': 'الشرح', 'text': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا', 'tafseer': 'إن مع الشدة والضيق فرجاً وسعة، فلا ييأس المؤمن من روح الله.'},
      {'id': 8, 'surah': 2, 'verse': 286, 'surah_name': 'البقرة', 'text': 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا', 'tafseer': 'لا يكلف الله أحداً فوق طاقته، فكل نفس مطالبة بما تطيق من الأعمال.'},
      {'id': 9, 'surah': 39, 'verse': 53, 'surah_name': 'الزمر', 'text': 'قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ', 'tafseer': 'قل يا محمد لعبادي الذين أكثروا الذنوب: لا تيأسوا من رحمة الله ومغفرته فإنها واسعة.'},
      {'id': 10, 'surah': 65, 'verse': 3, 'surah_name': 'الطلاق', 'text': 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ', 'tafseer': 'ومن يفوض أموره إلى الله ويثق به فهو كافيه ومعينه في كل شأنه.'},
    ];
    final batch = db.batch();
    for (final v in verses) {
      batch.insert('verses', v);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _insertSampleDhikr(Database db) async {
    final dhikrs = [
      {'id': 1, 'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ', 'source': 'أذكار الصباح', 'category': 'morning', 'count': 1},
      {'id': 2, 'text': 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ', 'source': 'أذكار الصباح - حصن المسلم', 'category': 'morning', 'count': 1},
      {'id': 3, 'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', 'source': 'أذكار الصباح - حصن المسلم', 'category': 'morning', 'count': 100},
      {'id': 4, 'text': 'أَصْبَحْنَا عَلَى فِطْرَةِ الْإِسْلَامِ، وَعَلَى كَلِمَةِ الْإِخْلَاصِ، وَعَلَى دِينِ نَبِيِّنَا مُحَمَّدٍ ﷺ، وَعَلَى مِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفًا مُسْلِمًا وَمَا كَانَ مِنَ الْمُشْرِكِينَ', 'source': 'أذكار الصباح - حصن المسلم', 'category': 'morning', 'count': 1},
      {'id': 5, 'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ', 'source': 'أذكار المساء - حصن المسلم', 'category': 'evening', 'count': 1},
      {'id': 6, 'text': 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ', 'source': 'أذكار المساء - حصن المسلم', 'category': 'evening', 'count': 1},
      {'id': 7, 'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ', 'source': 'أذكار المساء - حصن المسلم', 'category': 'evening', 'count': 1},
      {'id': 8, 'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ', 'source': 'حصن المسلم', 'category': 'general', 'count': 1},
      {'id': 9, 'text': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 'source': 'حصن المسلم', 'category': 'general', 'count': 100},
      {'id': 10, 'text': 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ', 'source': 'حصن المسلم', 'category': 'istighfar', 'count': 1},
      {'id': 11, 'text': 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', 'source': 'حصن المسلم', 'category': 'general', 'count': 10},
      {'id': 12, 'text': 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ', 'source': 'سيد الاستغفار - حصن المسلم', 'category': 'istighfar', 'count': 1},
      {'id': 13, 'text': 'اللَّهُمَّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ', 'source': 'حصن المسلم', 'category': 'istighfar', 'count': 100},
      {'id': 14, 'text': 'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي لِسَانِي نُورًا، وَفِي سَمْعِي نُورًا، وَفِي بَصَرِي نُورًا', 'source': 'دعاء - حصن المسلم', 'category': 'general', 'count': 1},
      {'id': 15, 'text': 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ', 'source': 'حصن المسلم', 'category': 'general', 'count': 7},
    ];
    final batch = db.batch();
    for (final d in dhikrs) {
      batch.insert('dhikr', d);
    }
    await batch.commit(noResult: true);
  }

  Database get db => _db!;

  Future<Map<String, dynamic>?> getSmartVerse() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneWeekAgo = now - (7 * 24 * 60 * 60 * 1000);

    // Get recently shown verse IDs
    final recentlyShown = await _db!.query(
      'shown_verses',
      where: 'shown_at > ?',
      whereArgs: [oneWeekAgo],
      orderBy: 'shown_at DESC',
    );
    final shownIds = recentlyShown.map((r) => r['verse_id'] as int).toList();

    List<Map<String, dynamic>> candidates;
    if (shownIds.isEmpty) {
      candidates = await _db!.query('verses', limit: 1, orderBy: 'RANDOM()');
    } else {
      final placeholders = List.filled(shownIds.length, '?').join(',');
      candidates = await _db!.rawQuery(
        'SELECT * FROM verses WHERE id NOT IN ($placeholders) ORDER BY RANDOM() LIMIT 1',
        shownIds,
      );
      if (candidates.isEmpty) {
        // All verses shown recently, pick any
        candidates = await _db!.query('verses', limit: 1, orderBy: 'RANDOM()');
      }
    }

    if (candidates.isEmpty) return null;
    final verse = candidates.first;

    // Mark as shown
    await _db!.insert('shown_verses', {
      'verse_id': verse['id'],
      'shown_at': now,
    });

    // Clean old records
    await _db!.delete('shown_verses', where: 'shown_at < ?', whereArgs: [oneWeekAgo]);

    return verse;
  }

  Future<Map<String, dynamic>?> getSmartDhikr(String category) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneDayAgo = now - (24 * 60 * 60 * 1000);

    final recentlyShown = await _db!.query(
      'shown_dhikr',
      where: 'shown_at > ?',
      whereArgs: [oneDayAgo],
    );
    final shownIds = recentlyShown.map((r) => r['dhikr_id'] as int).toList();

    List<Map<String, dynamic>> candidates;
    if (shownIds.isEmpty) {
      candidates = await _db!.query(
        'dhikr',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'RANDOM()',
        limit: 1,
      );
    } else {
      final placeholders = List.filled(shownIds.length, '?').join(',');
      candidates = await _db!.rawQuery(
        'SELECT * FROM dhikr WHERE category = ? AND id NOT IN ($placeholders) ORDER BY RANDOM() LIMIT 1',
        [category, ...shownIds],
      );
      if (candidates.isEmpty) {
        candidates = await _db!.query(
          'dhikr',
          where: 'category = ?',
          whereArgs: [category],
          orderBy: 'RANDOM()',
          limit: 1,
        );
      }
    }

    if (candidates.isEmpty) {
      candidates = await _db!.query('dhikr', orderBy: 'RANDOM()', limit: 1);
    }
    if (candidates.isEmpty) return null;

    final dhikr = candidates.first;
    await _db!.insert('shown_dhikr', {
      'dhikr_id': dhikr['id'],
      'shown_at': now,
    });
    await _db!.delete('shown_dhikr', where: 'shown_at < ?', whereArgs: [oneDayAgo]);

    return dhikr;
  }
}
