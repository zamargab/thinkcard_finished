import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/addMultiPlayers.dart';
import 'package:think/multiplayerStart.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:think/wordCart.dart';
import 'package:uuid/uuid.dart';
import 'package:sizer/sizer.dart';

import 'config/thinkcard.dart';

class MultiPlayerHome extends StatefulWidget {
  MultiPlayerHome({Key key}) : super(key: key);

  @override
  _MultiPlayerHomeState createState() => _MultiPlayerHomeState();
}

class _MultiPlayerHomeState extends State<MultiPlayerHome> {
  final TextEditingController _gameNameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ThinkCardApp.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final Color background = Color(0xFFeeecec);
    final Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 56.23; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    //other one
    final Color background2 = Colors.white;
    final Color fill2 = Color(0xFF025373);
    final List<Color> gradient2 = [
      background2,
      background2,
      fill2,
      fill2,
    ];
    final double fillPercent2 = 10.23; // fills 56.23% for container from bottom
    final double fillStop2 = (100 - fillPercent2) / 100;
    final List<double> stops2 = [0.0, fillStop2, fillStop2, 1.0];
    return Scaffold(
      appBar: MyAppBar(""),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 90.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg5.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/multi2.png',
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w, right: 3.w),
                        child: Text(
                          "MultiPlayer games",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: "Muli",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w, right: 3.w),
                        child: Text(
                          "Enjoy Thinkcard with friends and family anyday",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontFamily: "Muli",
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                constraints: BoxConstraints(
                  minHeight: 57.h,
                ),
                padding: EdgeInsets.all(1.h),
                width: screenWidth,
                decoration: new BoxDecoration(
                  color: Color(0xFFeeecec),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.h),
                    topLeft: Radius.circular(5.h),
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _modalBottomSheetMenu();
                        if (ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.clickSound)) {
                          ThinkCardApp.cache.play('pop.wav');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                  color: Color(0xFF025373),
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.plus,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "Create a game room",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          "My Games",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontFamily: "Muli",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('gameRooms')
                            .where("Creator",
                                isEqualTo: ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.userUID))
                            .orderBy("timeCreated", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.h),
                                child: SpinKitDoubleBounce(
                                    color: Color(0xFF025373), size: 15.h),
                              ),
                            );
                          }

                          if (snapshot.data.documents.length < 1) {
                            return Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 85.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradient,
                                          stops: stops,
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                        ),
                                      ),
                                      child: Container(
                                        width: 35.w,
                                        height: 35.w,
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.w),
                                            color: Colors.green,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          CupertinoIcons
                                              .gamecontroller_alt_fill,
                                          color: Colors.white,
                                          size: 15.w,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 21.h,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(3.h),
                                            bottomLeft: Radius.circular(3.h)),
                                        gradient: LinearGradient(
                                          colors: gradient2,
                                          stops: stops2,
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                        ),
                                      ),
                                      width: 85.w,
                                      child: Column(
                                        children: [
                                          Text(
                                            "No Game Room found!",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.sp,
                                                fontFamily: "Muli",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.w),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(1.h),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF025373),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h),
                                                    ),
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .checkmark_alt,
                                                        color: Colors.white,
                                                        size: 16.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 1.w),
                                                        Text(
                                                          "Click the button below to create a game room",
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily: "Muli",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xFF808080),
                                                          ),
                                                        ),
                                                        SizedBox(height: 1.h),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: InkWell(
                                              onTap: () {
                                                _modalBottomSheetMenu();
                                                if (ThinkCardApp
                                                    .sharedPreferences
                                                    .getBool(ThinkCardApp
                                                        .clickSound)) {
                                                  ThinkCardApp.cache
                                                      .play('pop.wav');
                                                }
                                              },
                                              child: Container(
                                                height: 7.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF025373),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(1.h)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Create",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily: "Muli",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Container(
                            width: 90.w,
                            height: 50.h,
                            color: Color(0xFFeeecec),
                            padding: EdgeInsets.only(top: 0.5.h),
                            child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot _card =
                                    snapshot.data.documents[index];

                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 35.w,
                                        margin: EdgeInsets.only(
                                            left: snapshot.data.documents
                                                        .length ==
                                                    1
                                                ? 0
                                                : 3.w),
                                        width:
                                            snapshot.data.documents.length == 1
                                                ? 90.w
                                                : 75.w,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradient,
                                            stops: stops,
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Container(
                                          width: 35.w,
                                          height: 35.w,
                                          padding: EdgeInsets.all(2.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.w),
                                              color: Color(0xFFFA6E08),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            CupertinoIcons
                                                .gamecontroller_alt_fill,
                                            color: Colors.white,
                                            size: 15.w,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 21.h,
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(3.h),
                                              bottomLeft: Radius.circular(3.h)),
                                          gradient: LinearGradient(
                                            colors: gradient2,
                                            stops: stops2,
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                            left: snapshot.data.documents
                                                        .length ==
                                                    1
                                                ? 0
                                                : 3.w),
                                        width:
                                            snapshot.data.documents.length == 1
                                                ? 90.w
                                                : 75.w,
                                        child: Column(
                                          children: [
                                            Text(
                                              _card['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontFamily: "Muli",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(3.w),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(1.h),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF025373),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.h),
                                                      ),
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .checkmark_alt,
                                                          color: Colors.white,
                                                          size: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(height: 1.w),
                                                          Text(
                                                            "Click the button below to access this game room",
                                                            style: TextStyle(
                                                              fontSize: SizerUtil
                                                                          .deviceType ==
                                                                      DeviceType
                                                                          .mobile
                                                                  ? 8.sp
                                                                  : 7.sp,
                                                              fontFamily:
                                                                  "Muli",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xFF808080),
                                                            ),
                                                          ),
                                                          SizedBox(height: 1.h),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  Route route = MaterialPageRoute(
                                                      builder: (c) =>
                                                          MultiPlayerStart(
                                                              _card['docID'],
                                                              _card[
                                                                  'gameusers']));
                                                  Navigator.push(
                                                      context, route);
                                                  if (ThinkCardApp
                                                      .sharedPreferences
                                                      .getBool(ThinkCardApp
                                                          .clickSound)) {
                                                    ThinkCardApp.cache
                                                        .play('pop.wav');
                                                  }
                                                },
                                                child: Container(
                                                  height: 7.h,
                                                  width: 30.w,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF025373),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                1.h)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Play",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily: "Muli",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    SizedBox(height: 2.h),
                    Divider(color: Colors.grey),
                    SizedBox(height: 1.5.h),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.h),
                        child: Text(
                          "Game Rooms by Friends",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Muli",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('gameRooms')
                            .where('gameusers',
                                arrayContains: ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.userUID))
                            .orderBy("timeCreated", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 1.5.h),
                              child: SpinKitDoubleBounce(
                                  color: Color(0xFF025373), size: 20.h),
                            ));
                          }

                          if (snapshot.data.documents.length < 1) {
                            return Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 85.w,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradient,
                                          stops: stops,
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                        ),
                                      ),
                                      child: Container(
                                        width: 35.w,
                                        height: 35.w,
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.w),
                                            color: Colors.green,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          CupertinoIcons
                                              .gamecontroller_alt_fill,
                                          color: Colors.white,
                                          size: 15.w,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 21.h,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(3.h),
                                            bottomLeft: Radius.circular(3.h)),
                                        gradient: LinearGradient(
                                          colors: gradient2,
                                          stops: stops2,
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                        ),
                                      ),
                                      width: 85.w,
                                      child: Column(
                                        children: [
                                          Text(
                                            "No Game Room found!",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.sp,
                                                fontFamily: "Muli",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(3.w),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(1.h),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF025373),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.h),
                                                    ),
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .checkmark_alt,
                                                        color: Colors.white,
                                                        size: 16.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height: 1.w),
                                                        Text(
                                                          "Click the button below to create a game room",
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily: "Muli",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xFF808080),
                                                          ),
                                                        ),
                                                        SizedBox(height: 1.h),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: InkWell(
                                              onTap: () {
                                                _modalBottomSheetMenu();
                                                if (ThinkCardApp
                                                    .sharedPreferences
                                                    .getBool(ThinkCardApp
                                                        .clickSound)) {
                                                  ThinkCardApp.cache
                                                      .play('pop.wav');
                                                }
                                              },
                                              child: Container(
                                                height: 7.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF025373),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Create",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily: "Muli",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Container(
                            width: 90.w,
                            height: 50.h,
                            color: Color(0xFFeeecec),
                            padding: EdgeInsets.only(top: 0.5.h),
                            child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot _card =
                                    snapshot.data.documents[index];

                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 35.w,
                                        margin: EdgeInsets.only(
                                            left: snapshot.data.documents
                                                        .length ==
                                                    1
                                                ? 0
                                                : 3.w),
                                        width:
                                            snapshot.data.documents.length == 1
                                                ? 90.w
                                                : 75.w,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradient,
                                            stops: stops,
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Container(
                                          width: 35.w,
                                          height: 35.w,
                                          padding: EdgeInsets.all(2.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.w),
                                              color: Color(0xFFFA6E08),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            CupertinoIcons
                                                .gamecontroller_alt_fill,
                                            color: Colors.white,
                                            size: 15.w,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 21.h,
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(3.h),
                                              bottomLeft: Radius.circular(3.h)),
                                          gradient: LinearGradient(
                                            colors: gradient2,
                                            stops: stops2,
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                            left: snapshot.data.documents
                                                        .length ==
                                                    1
                                                ? 0
                                                : 3.w),
                                        width:
                                            snapshot.data.documents.length == 1
                                                ? 90.w
                                                : 75.w,
                                        child: Column(
                                          children: [
                                            Text(
                                              _card['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontFamily: "Muli",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(3.w),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2.h),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF025373),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.h),
                                                      ),
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .checkmark_alt,
                                                          color: Colors.white,
                                                          size: 16.sp),
                                                    ),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(height: 1.w),
                                                          Text(
                                                            "Click the button below to access this game room",
                                                            style: TextStyle(
                                                              fontSize: SizerUtil
                                                                          .deviceType ==
                                                                      DeviceType
                                                                          .mobile
                                                                  ? 8.sp
                                                                  : 7.sp,
                                                              fontFamily:
                                                                  "Muli",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xFF808080),
                                                            ),
                                                          ),
                                                          SizedBox(height: 1.h),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  Route route = MaterialPageRoute(
                                                      builder: (c) =>
                                                          MultiPlayerStart(
                                                              _card['docID'],
                                                              _card[
                                                                  'gameusers']));
                                                  Navigator.push(
                                                      context, route);
                                                  if (ThinkCardApp
                                                      .sharedPreferences
                                                      .getBool(ThinkCardApp
                                                          .clickSound)) {
                                                    ThinkCardApp.cache
                                                        .play('pop.wav');
                                                  }
                                                },
                                                child: Container(
                                                  height: 7.h,
                                                  width: 30.w,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF025373),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                1.h)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Play",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily: "Muli",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.2,
                maxChildSize: 0.65,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(5.h, 2.h, 5.h, 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(CupertinoIcons.chevron_compact_down,
                            color: Colors.black, size: 35.sp),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "Enter name of Game Room below",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xFF0f1245),
                              fontFamily: "Muli",
                              height: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Color(0xFF0f1245),
                            primaryColorDark: Color(0xFF0f1245),
                          ),
                          child: TextFormField(
                            controller: _gameNameTextEditingController,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.h, vertical: 0),
                              fillColor: Color(0xFFCC5500),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(2.h),
                                borderSide: new BorderSide(width: 1.w),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        InkWell(
                          onTap: () {
                            saveGameName();
                            if (ThinkCardApp.sharedPreferences
                                .getBool(ThinkCardApp.clickSound)) {
                              ThinkCardApp.cache.play('pop.wav');
                            }
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Color(0xFF025373),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.h)),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(3.h, 1.5.h, 3.h, 1.5.h),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontFamily: "Muli",
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  saveGameName() {
    showDialog(
        context: context,
        builder: (c) {
          return SpinKitWanderingCubes(
            color: Colors.white,
            size: 20.h,
          );
        });
    var uuid = Uuid();
    String docID = uuid.v1();

    Firestore.instance.collection("gameRooms").document(docID).setData({
      "gameusers": [],
      "timeCreated": DateTime.now(),
      "docID": docID,
      "users": 1,
      "cards": 0,
      "Creator": ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID),
      "name": _gameNameTextEditingController.text.trim(),
    }).then((value) {
      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .updateData({
        "activeGameRooms": FieldValue.arrayUnion([docID])
      });
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '',
        desc: 'Your Game Room has been created',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      )..show();

      _gameNameTextEditingController.clear();
    });
  }

  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        "2",
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(
            CupertinoIcons.bell,
            color: Colors.black,
          ),
          onPressed: () {}),
    );
  }
}
