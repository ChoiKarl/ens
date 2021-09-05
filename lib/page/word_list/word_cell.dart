import 'package:ens/word_manager/word.dart';
import 'package:flutter/material.dart';

class WordCell extends StatelessWidget {
  final Word word;

  const WordCell({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          wordWidget(word),
          SizedBox(height: 2),
          explainWidget(word),
          SizedBox(height: 2),
          exampleWidget(word),
          SizedBox(height: 2),
          matchWidget(word),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: Colors.black,
            width: double.infinity,
            height: 0.5,
          )
        ],
      ),
    );
  }

  Widget wordWidget(Word word) {
    return Text(
      word.word,
      style: TextStyle(fontSize: 20, color: Colors.pink, fontWeight: FontWeight.bold),
    );
  }

  Widget explainWidget(Word word) {
    return Text(
      word.explain,
      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }

  Widget exampleWidget(Word word) {
    if (word.example.isEmpty) return Container();

    List<String> exampleString = word.example.split(word.word);
    if (word.example.startsWith(word.word)) {
      exampleString.insert(0, word.word);
    } else if (word.example.endsWith(word.word)) {
      exampleString.add(word.word);
    } else {
      exampleString.insert(1, word.word);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 2),
          margin: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(6)),
          child: Text(
            '例句',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(
                  children: exampleString.map((e) {
                Color color = e == word.word ? Colors.pink : Colors.black;
                FontWeight weight = e == word.word ? FontWeight.w600 : FontWeight.w400;
                return TextSpan(
                  text: e,
                  style: TextStyle(fontSize: 14, color: color, fontWeight: weight),
                );
              }).toList())),
              Text(
                word.exampleTranslation,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget matchWidget(Word word) {
    if (word.match.isEmpty) return Container();
    List<String> matchs = word.match.split("|");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 2),
          margin: EdgeInsets.only(right: 2),
          decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(6)),
          child: Text(
            '搭配',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: matchs.map((e) => Text(e)).toList(),
        ),
      ],
    );
  }
}
