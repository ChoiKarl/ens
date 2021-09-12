import 'dart:math';

import 'package:ens/page/study_page/study_page.dart';
import 'package:ens/word_manager/word.dart';
import 'package:flutter/cupertino.dart';

const int SINGLE_WORD_STUDY_MAX_COUNT = 5;

class StudyPageViewModel extends ChangeNotifier {
  StudyPageViewModel({required this.pageStyle, required this.needStudyWords}) {
    _currentShowWord = needStudyWords.first;
  }

  final PageStyle pageStyle;
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
  int get totalReviseWordsCount {
    // 全部学完,最后一个也复习
    if (needStudyWords.length == alreadyStudyCount) return alreadyStudyCount;
    // 已学习的最后一个不在复习范围内
    return alreadyStudyCount - 1;
  }
  /// 是否在复习
  bool _revising = false;
  bool get revising => _revising;

  /// 是否显示中文
  bool _showChinese = true;
  bool get showChinese => _showChinese;
  set showChinese(bool value) {
    if (_showChinese == value) return;
    _showChinese = value;
    notifyListeners();
  }
  /// 学习
  void repeatStudy() {
    _studyingWordRepeatCount += 1;

    if (_studyingWordRepeatCount > SINGLE_WORD_STUDY_MAX_COUNT) {
      _studyingWordRepeatCount = 1;
      // 将学完的加到已经学习的数组里
      if (!_alreadyStudyWords.contains(currentShowWord)) {
        _alreadyStudyWords.add(currentShowWord);
      }
      _switchNextWord();
    }
    notifyListeners();
  }

  /// 切换下一个要学习的词汇
  void _switchNextWord() {
    // 学完了,也复习完了,就不再继续.
    if (alreadyStudyCount == needStudyWords.length && revising && _reviseWords.length == 0) return;

    if (_reviseWords.isEmpty && alreadyStudyCount > 1 && revising == false) {
      _reviseWords = _alreadyStudyWords.toList();
      // 最后一个是刚学的,不需要复习,如果是全部学完了,就将最后一个保留复习一次.
      if (alreadyStudyCount != needStudyWords.length) {
        _reviseWords.removeLast();
      }
    }

    // 只有背诵模式才需要反复
    if (_reviseWords.isEmpty || pageStyle != PageStyle.recite) {
      _revising = false;
      _alreadyReviseWords.clear();
      _currentShowWord = needStudyWords[alreadyStudyCount];
    } else {
      _revising = true;
      // 复习之前的
      int ri = random.nextInt(_reviseWords.length);
      Word word = _reviseWords.removeAt(ri);
      _alreadyReviseWords.add(word);
      _currentShowWord = word;
    }
    _showChinese = revising == false;
  }
}
