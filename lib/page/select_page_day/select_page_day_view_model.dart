import 'package:ens/word_manager/word_manager.dart';
import 'package:flutter/cupertino.dart';

class SelectPageOrDayViewModel extends ChangeNotifier {
  late List<int> days;
  late List<int> pages;

  List<int> selectedDays = [];
  List<int> selectedPages = [];

  SelectPageOrDayViewModel() {
    days = WordManager.shared.dayWords.keys.toList();
    days.sort();

    pages = WordManager.shared.pageWords.keys.toList();
    pages.sort();
  }

  void selectDay(int day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    selectedPages.clear();
    notifyListeners();
  }

  void selectPage(int page) {
    if (selectedPages.contains(page)) {
      selectedPages.remove(page);
    } else {
      selectedPages.add(page);
    }
    selectedDays.clear();
    notifyListeners();
  }
}
