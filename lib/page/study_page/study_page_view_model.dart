import 'package:ens/word_manager/word.dart';
import 'package:flutter/cupertino.dart';

class StudyPageViewModel extends ChangeNotifier{
  final List<Word> needStudyWords;

  List<Word> alreadyStudyWords = [];

  StudyPageViewModel(this.needStudyWords);



  void study(Word word) {
    alreadyStudyWords.add(word);
    notifyListeners();
  }
}