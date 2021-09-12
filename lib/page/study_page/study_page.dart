import 'package:ens/page/study_page/study_card.dart';
import 'package:ens/page/study_page/study_page_view_model.dart';
import 'package:ens/word_manager/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

StudyPageViewModel? studyViewModel;

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
    viewModel = studyViewModel != null ? studyViewModel! : StudyPageViewModel(widget.words);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(

                title: Text('保存学习记录?'),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        studyViewModel = null;
                        Navigator.of(context).pop(true);
                      },
                      child: Text('取消')),
                  CupertinoDialogAction(
                    onPressed: () {
                      studyViewModel = viewModel;
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      '保留',
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                  )
                ],
              );
            });
        return value ?? false;
      },
      child: ChangeNotifierProvider<StudyPageViewModel>.value(
        value: viewModel,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: Selector<StudyPageViewModel, Word>(
                selector: (ctx, vm) => vm.currentShowWord,
                builder: (context, value, child) {
                  int count = viewModel.alreadyStudyCount;
                  count = viewModel.revising ? count : count + 1;
                  return Text('$count/${viewModel.needStudyWords.length}');
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
      ),
    );
  }
}
