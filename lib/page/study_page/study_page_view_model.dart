import 'dart:math';

import 'package:ens/word_manager/word.dart';
import 'package:flutter/cupertino.dart';

const int SINGLE_WORD_STUDY_MAX_COUNT = 5;

class StudyPageViewModel extends ChangeNotifier {
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

  /// 记录需要复习的单词
  List<Word> _reviseWords = [];

  /// 已经复习了的单词
  List<Word> _alreadyReviseWords = [];

  /// 已经复习的单词的数量
  int get alreadyReviseWordsCount => _alreadyReviseWords.length;
  /// 总共需要复习的数量
  int get totalReviseWordsCount => alreadyStudyCount - 1/*已学习最后一个不在复习范围内*/;
  /// 是否在复习
  bool _revising = false;

  bool get revising => _revising;

  /// 学习
  void repeatStudy() {
    _studyingWordRepeatCount += 1;

    if (_studyingWordRepeatCount > SINGLE_WORD_STUDY_MAX_COUNT) {
      _studyingWordRepeatCount = 1;
      // 将学完的加到已经学习的数组里
      if (!_alreadyStudyWords.contains(currentShowWord)) {
        _alreadyStudyWords.add(currentShowWord);
      }
      switchNextWord();
    }
    notifyListeners();
  }

  /// 切换下一个要学习的词汇
  void switchNextWord() {
    if (_reviseWords.isEmpty && alreadyStudyCount > 1 && revising == false) {
      _reviseWords = _alreadyStudyWords.toList();
      _reviseWords.removeLast();
    }

    if (_reviseWords.isEmpty) {
      _revising = false;
      _currentShowWord = needStudyWords[alreadyStudyCount];
      _alreadyReviseWords.clear();
    } else {
      _revising = true;
      // 复习之前的
      int ri = random.nextInt(_reviseWords.length);
      Word word = _reviseWords.removeAt(ri);
      _alreadyReviseWords.add(word);
      _currentShowWord = word;
    }
  }
}
