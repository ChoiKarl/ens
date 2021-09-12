import 'package:dio/dio.dart';
import 'package:ens/network/network.dart';
import 'package:ens/word_manager/word.dart';
import 'package:ens/yd/yd_translate.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const String WORD_TABLE = 'word';
const String COLLECT_WORD_TABLE = 'collect_word';

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
  List<Word> collectWords = [];

  Map<String, YDTranslateResult> translates = {};

  Future<void> fetchWords() async {
    if (words.isNotEmpty) return;
    String path = await loadLocalDB();
    if (_db == null) {
      _db = await openDatabase(path);
    }

    List<Map<String, dynamic>> result = await _db!.rawQuery('select * from $WORD_TABLE');

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

    result = await _db!.rawQuery('select * from $COLLECT_WORD_TABLE');
    result.forEach((element1) {
      Word word = words.firstWhere((element2) => element2.word == element1['word']);
      collectWords.add(word);
    });

    return;
  }

  Future<bool> collectionWord(Word word) async {
    var query = await _db!.query(COLLECT_WORD_TABLE, where: 'word = ?', whereArgs: [word.word]);
    if (query.isNotEmpty) {
      int delete = await _db!.delete(COLLECT_WORD_TABLE, where: 'word = ?', whereArgs: [word.word]);
      collectWords.removeWhere((element) => element.word == word.word);
      return delete != 0;
    }
    var insert = await _db!.insert(COLLECT_WORD_TABLE, {'word': word.word});
    collectWords.add(word);
    return insert != 0;
  }

  Future<YDTranslateResult> getTranslate(String word) async {
    if (translates[word] != null) return translates[word]!;
    Response response = await Network.shared.queryWord(word);
    var result = YDTranslateResult.fromJson(response.data);
    translates[word] = result;
    return result;
  }
}

Future<String> loadLocalDB() async {
  io.Directory applicationDirectory = await getApplicationDocumentsDirectory();

  String dbPathEnglish = path.join(applicationDirectory.path, "english.db");

  bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

  if (true) {
    ByteData data = await rootBundle.load(path.join("assets", "english.db"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
  }
  return Future.value(dbPathEnglish);
}
