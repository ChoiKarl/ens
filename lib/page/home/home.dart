import 'package:ens/page/select_page_day/select_page_day_page.dart';
import 'package:ens/page/study_page/study_page.dart';
import 'package:ens/page/word_list/word_list_page.dart';
import 'package:ens/word_manager/word.dart';
import 'package:ens/word_manager/word_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WordManager wordManager = WordManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _wordPageItem(),
            SizedBox(height: 10),
            _recitePageItem(),
            SizedBox(height: 10),
            _reviewPageItem(),
            SizedBox(height: 10),
            _collectPageItem(),
          ],
        ),
      ),
    );
  }

  Widget _wordPageItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return WordListPage();
          },
        ));
      },
      child: _itemText('单词页面'),
    );
  }

  Widget _recitePageItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            if (pageViewModels[PageStyle.recite] != null) {
              return StudyPage(words: [], pageStyle: PageStyle.recite);
            }
            return SelectPageOrDayPage(
              confirmCallback: (type, select) {
                List<Word> words = [];
                if (type == PageDaySelectType.page) {
                  select.forEach((element) {
                    words.addAll(WordManager.shared.pageWords[element]?.toList() ?? []);
                  });
                } else {
                  select.forEach((element) {
                    words.addAll(WordManager.shared.dayWords[element]?.toList() ?? []);
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return StudyPage(words: words, pageStyle: PageStyle.recite);
                }));
              },
            );
          },
        ));
      },
      child: _itemText('背诵页面'),
    );
  }

  Widget _reviewPageItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            if (pageViewModels[PageStyle.recite] != null) {
              return StudyPage(words: [], pageStyle: PageStyle.review);
            }
            return SelectPageOrDayPage(
              confirmCallback: (type, select) {
                List<Word> words = [];
                if (type == PageDaySelectType.page) {
                  select.forEach((element) {
                    words.addAll(WordManager.shared.pageWords[element]?.toList() ?? []);
                  });
                } else {
                  select.forEach((element) {
                    words.addAll(WordManager.shared.dayWords[element]?.toList() ?? []);
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return StudyPage(words: words, pageStyle: PageStyle.review);
                }));
              },
            );
          },
        ));
      },
      child: _itemText('复习页面'),
    );
  }

  Widget _collectPageItem() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return StudyPage(words: WordManager.shared.collectWords, pageStyle: PageStyle.review);
          },
        ));
      },
      child: _itemText('收藏页面')
    );
  }

  Widget _itemText(String text) {
    return Container(
      alignment: Alignment.center,
      height: 44,
      child: Text(text, style: TextStyle(color: Colors.white)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.blue,
      )
    );
  }
}
