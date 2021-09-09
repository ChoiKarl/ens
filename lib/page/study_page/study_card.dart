import 'package:ens/page/study_page/study_page_view_model.dart';
import 'package:ens/word_manager/word.dart';
import 'package:ens/word_manager/word_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyCard extends StatefulWidget {
  @override
  _StudyCardState createState() => _StudyCardState();
}

class _StudyCardState extends State<StudyCard> {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<StudyPageViewModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
            spreadRadius: 5,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 5,
            right: 5,
            child: Selector<StudyPageViewModel, int>(
              selector: (_, vm) => vm.studyingWordRepeatCount,
              builder: (context, value, child) {
                return Text('$value/$SINGLE_WORD_STUDY_MAX_COUNT');
              },
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Selector<StudyPageViewModel, int>(
              selector: (_, vm) => vm.alreadyReviseWordsCount,
              builder: (context, value, child) {
                return Offstage(
                  offstage: value == 0,
                  child: Text('$value/${viewModel.totalReviseWordsCount}', style: TextStyle(color: Colors.green)),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: Selector<StudyPageViewModel, Word>(
              selector: (_, vm) => vm.currentShowWord,
              builder: (context, word, child) {
                return DefaultTextStyle(
                  style: TextStyle(
                    color: viewModel.revising ? Colors.green : Colors.black,
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          word.word,
                          maxLines: 1,
                          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        word.explain,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        word.example,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        word.exampleTranslation,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                WordManager.shared.collectionWord(viewModel.currentShowWord).then((value) {
                  setState(() {});
                });
              },
              child: Selector<StudyPageViewModel, Word>(
                selector: (_, vm) => vm.currentShowWord,
                builder: (context, value, child) {
                  return WordManager.shared.collectWords.contains(value)
                      ? Icon(Icons.star, color: Colors.pink)
                      : Icon(Icons.star_border_outlined);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
