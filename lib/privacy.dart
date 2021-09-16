import 'package:flutter/material.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';

class Privacy extends StatefulWidget {
  Privacy({Key key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar("Privacy"),
        drawer: MyDrawer(),
      ),
    );
  }
}
