import 'dart:math';

import 'package:ens/word_manager/word.dart';
import 'package:flutter/cupertino.dart';

const int SINGLE_WORD_STUDY_MAX_COUNT = 5;

class StudyPageViewModel extends ChangeNotifier{
  StudyPageViewModel(this.needStudyWords) {
    _currentShowWord = needStudyWords.first;
  }

  final List<Word> needStudyWords;
  final Random random = Random();

  List<Word> _alreadyStudyWords = [];

  /// 已经学习的单词数量
  int get alreadyStudyCount => _alreadyStudyWords.length;

  /// 正在学习的单词的次数
  int _studyingWordRepeatCount = 1;
  int get studyingWordRepeatCount => _studyingWordRepeatCount;

  /// 当前展示的单词
  late Word _currentShowWord;
  Word get currentShowWord => _currentShowWord;

  /// 是否正在复习
  bool _revise = false;

  /// 记录已经复习的单词
  List<Word> _alreadyStudyWordsCopy = [];

  /// 学习
  void repeatStudy() {
    _studyingWordRepeatCount = _studyingWordRepeatCount + 1;

    if (_studyingWordRepeatCount > SINGLE_WORD_STUDY_MAX_COUNT) {
      _studyingWordRepeatCount = 1;
      // 将学完的加到已经学习的数组里
      _alreadyStudyWords.add(currentShowWord);

      switchNextWord();
    }
    notifyListeners();
  }

  /// 切换下一个要学习的词汇
  void switchNextWord() {
    if (_alreadyStudyWordsCopy.isEmpty && alreadyStudyCount > 1) {
      _alreadyStudyWordsCopy = _alreadyStudyWords.toList();
    }

    if (_alreadyStudyWordsCopy.isEmpty) {
      _currentShowWord = needStudyWords[alreadyStudyCount];
    } else {
     // 复习之前的
       int ri = random.nextInt(_alreadyStudyWordsCopy.length);
      Word word = _alreadyStudyWordsCopy.removeAt(ri);
       _currentShowWord = word;
    }
  }
}