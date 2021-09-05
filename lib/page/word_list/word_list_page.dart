import 'package:ens/page/word_list/word_cell.dart';
import 'package:ens/word_manager/word.dart';
import 'package:ens/word_manager/word_manager.dart';
import 'package:flutter/material.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({Key? key}) : super(key: key);

  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  @override
  Widget build(BuildContext context) {
    var words = WordManager.shared.words;
    return Scaffold(
      appBar: AppBar(title: Text('单词列表')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            Word word = words[index];
            return WordCell(word: word);
          },
        ),
      ),
    );
  }
}
