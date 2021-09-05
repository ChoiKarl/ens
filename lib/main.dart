import 'package:ens/page/home/home.dart';
import 'package:ens/word_manager/word_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  // UserDefault.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: WordManager.shared.fetchWords(),
        builder: (context, snapshot) {
          return HomePage();
        },
      )
    );
  }
}
