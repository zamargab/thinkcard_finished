import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:think/cardGame.dart';
import 'package:think/config/thinkcard.dart';

import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';

class FirestoreSlideshow extends StatefulWidget {
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<FirestoreSlideshow>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CardGameTemplate(
      dbName: "stories",
      title: "Word",
      responseDB: "responses",
    );
  }
}
