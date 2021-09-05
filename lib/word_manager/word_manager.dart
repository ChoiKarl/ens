import 'package:ens/word_manager/word.dart';
import 'package:sqflite/sqflite.dart';

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
    if (_db == null) {
      _db = await openDatabase('db/english.db');
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
