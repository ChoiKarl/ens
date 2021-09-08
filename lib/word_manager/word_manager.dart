import 'package:ens/word_manager/word.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class WordManager {
  static WordManager? _instance;

  static WordManager get shared {
    _instance ??= WordManager();
    return _instance!;
  }

  Database? _db;
  List<Word> words = [];

  Map<int, List<Word>> dayWords = {};
  Map<int, List<Word>> pageWords = {};

  Future<void> fetchWords() async {
    if (words.isNotEmpty) return;
    String path = await loadLocalDB();
    if (_db == null) {
      _db = await openDatabase(path);
    }

    List<Map<String, dynamic>> result = await _db!.rawQuery('select * from word');

    Set<int> days = Set();
    Set<int> pages = Set();
    result.forEach((element) {
      Word word = Word.fromJson(element);
      words.add(word);
      days.add(word.day);
      pages.add(word.page);
    });

    days.forEach((day) {
      dayWords[day] = words.where((word) => word.day == day).toList();
    });

    pages.forEach((page) {
      pageWords[page] = words.where((word) => word.page == page).toList();
    });

    return;
  }
}

Future<String> loadLocalDB() async {
  io.Directory applicationDirectory = await getApplicationDocumentsDirectory();

  String dbPathEnglish = path.join(applicationDirectory.path, "english.db");

  bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

  if (!dbExistsEnglish) {
    ByteData data = await rootBundle.load(path.join("assets", "english.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
  }
  return Future.value(dbPathEnglish);
}
