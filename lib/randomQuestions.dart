import 'package:flutter/material.dart';
import 'package:think/cardGame.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RandomQuestions extends StatefulWidget {
  RandomQuestions({Key key}) : super(key: key);

  @override
  _RandomQuestionsState createState() => _RandomQuestionsState();
}

class _RandomQuestionsState extends State<RandomQuestions> {
  @override
  Widget build(BuildContext context) {
    return CardGameTemplate(
      dbName: "randomQuestions",
      title: "Random Questions",
      responseDB: "RandomQuestionsResponses",
    );
  }
}
