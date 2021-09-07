import 'package:ens/network/network.dart';
import 'package:ens/page/study_page/study_page_view_model.dart';
import 'package:ens/word_manager/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudyPage extends StatefulWidget {
  final List<Word> words;

  const StudyPage({
    Key? key,
    required this.words,
  }) : super(key: key);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  late final StudyPageViewModel viewModel;

  @override
  void initState() {
    viewModel = StudyPageViewModel(widget.words);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudyPageViewModel>.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Selector<StudyPageViewModel, int>(
              selector: (ctx, vm) => vm.alreadyStudyCount,
              builder: (context, value, child) {
                return Text('$value/${viewModel.needStudyWords.length}');
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    bottom: 100,
                    child: StudyCard(),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(22)),
                      child: TextButton(
                        onPressed: () {
                          viewModel.repeatStudy();
                        },
                        child: Selector<StudyPageViewModel, int>(
                          selector: (_, vm) => vm.studyingWordRepeatCount,
                          builder: (context, value, child) {
                            return Text(
                              value == SINGLE_WORD_STUDY_MAX_COUNT ? '下一个' : '重复',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StudyCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
            left: 0,
            right: 0,
            top: 40,
            child: Selector<StudyPageViewModel, Word>(
              selector: (_, vm) => vm.currentShowWord,
              builder: (context, word, child) {
                return Column(
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
                      maxLines: 1,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
