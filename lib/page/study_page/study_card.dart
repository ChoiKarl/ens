import 'package:audioplayers/audioplayers.dart';
import 'package:ens/page/study_page/study_page_view_model.dart';
import 'package:ens/word_manager/word.dart';
import 'package:ens/word_manager/word_manager.dart';
import 'package:ens/yd/yd_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

AudioPlayer _audioPlayer = AudioPlayer();

class StudyCard extends StatefulWidget {
  @override
  _StudyCardState createState() => _StudyCardState();
}

class _StudyCardState extends State<StudyCard> {
  YDTranslateResult? _translateResult;

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
            bottom: 35,
            child: Selector<StudyPageViewModel, Word>(
              selector: (_, vm) => vm.currentShowWord,
              builder: (context, word, child) {
                return SingleChildScrollView(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: viewModel.revising ? Colors.green : Colors.black,
                    ),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: GestureDetector(
                            onTap: () {
                              if (_translateResult?.webdict?.url != null) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return Scaffold(
                                    appBar: AppBar(title: Text(viewModel.currentShowWord.word)),
                                    body: WebView(
                                      initialUrl: _translateResult!.webdict!.url!,
                                      javascriptMode: JavascriptMode.unrestricted,
                                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                        new Factory<OneSequenceGestureRecognizer>(
                                              () => new EagerGestureRecognizer(),
                                        ),
                                      ].toSet(),
                                    ),
                                  );
                                }));
                              }
                            },
                            onDoubleTap: () {
                              viewModel.showChinese = true;
                            },
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(
                                text: viewModel.currentShowWord.word,
                              )).then((value) {
                                Fluttertoast.showToast(msg: '复制成功', gravity: ToastGravity.CENTER);
                              });
                            },
                            child: Text(
                              word.word,
                              maxLines: 1,
                              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FutureBuilder<YDTranslateResult>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _translateResult = snapshot.data;
                              return GestureDetector(
                                onTap: () {
                                  if (snapshot.data?.basic?.ukSpeech != null) {
                                    _audioPlayer.play(snapshot.data!.basic!.ukSpeech!);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data?.basic?.ukPhonetic ?? '',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.record_voice_over_sharp)
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                          future: WordManager.shared.getTranslate(viewModel.currentShowWord.word),
                        ),
                        Selector<StudyPageViewModel, bool>(
                          selector: (_, vm) => vm.showChinese,
                          builder: (context, value, child) => Visibility(
                            visible: value,
                            child: Text(
                              word.explain,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Selector<StudyPageViewModel, bool>(
                          selector: (_, vm) => vm.showChinese,
                          builder: (context, value, child) => Visibility(
                              visible: value,
                              child: Column(
                                children: viewModel.currentShowWord.match.split("|").map((e) {
                                  if (e.isEmpty) return Container();
                                  return Text(
                                    e,
                                    style: TextStyle(fontSize: 15),
                                  );
                                }).toList(),
                              )),
                        ),
                        SizedBox(height: 20),
                        Selector<StudyPageViewModel, bool>(
                          selector: (_, vm) {
                            if (vm.showChinese) {
                              return true;
                            }
                            if (vm.showChinese == false && vm.studyingWordRepeatCount > 1) {
                              return true;
                            }
                            return false;
                          },
                          builder: (context, value, child) => Visibility(
                              visible: value,
                              child: SelectableText(
                                word.example,
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                        ),
                        Selector<StudyPageViewModel, bool>(
                          selector: (_, vm) => vm.showChinese,
                          builder: (context, value, child) => Visibility(
                            visible: value,
                            child: Text(
                              word.exampleTranslation,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
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
