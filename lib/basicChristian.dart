import 'package:flutter/material.dart';
import 'package:think/CardGameTwo.dart';

class BasicChristian extends StatefulWidget {
  BasicChristian({Key key}) : super(key: key);

  @override
  _BasicChristianState createState() => _BasicChristianState();
}

class _BasicChristianState extends State<BasicChristian> {
  @override
  Widget build(BuildContext context) {
    return CardGameTemplateTwo(
      dbName: "basicChristian",
      title: "Basic Christian Knowledge",
      responseDB: "BasicChristianResponses",
    );
  }
}
