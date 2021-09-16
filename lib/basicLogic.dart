import 'package:flutter/material.dart';
import 'package:think/CardGameTwo.dart';

class BasicLogic extends StatefulWidget {
  BasicLogic({Key key}) : super(key: key);

  @override
  _BasicLogicState createState() => _BasicLogicState();
}

class _BasicLogicState extends State<BasicLogic> {
  @override
  Widget build(BuildContext context) {
    return CardGameTemplateTwo(
      dbName: "basicLogic",
      title: "Basic Logic and Reasoning",
      responseDB: "BasicLogicResponses",
    );
  }
}
