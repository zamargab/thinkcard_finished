import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think/addMultiPlayers.dart';
import 'package:think/config/thinkcard.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:think/multiplayerAddCard.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:flip_card/flip_card.dart';

class MultiPlayerStart extends StatefulWidget {
  MultiPlayerStart(
    this.docID,
    this.gameUsers, {
    Key key,
  }) : super(key: key);
  final String docID;
  final List gameUsers;

  @override
  _MultiPlayerStartState createState() => _MultiPlayerStartState();
}

class _MultiPlayerStartState extends State<MultiPlayerStart>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final PageController ctrl = PageController(viewportFraction: 0.8);
  final TextEditingController _responseTextEditingController =
      TextEditingController();
  AnimationController _controller, _controller2, _controller3, _controller4;
  Animation<Offset> _animation, _animation2, _animation3, _animation4;
  final Firestore db = Firestore.instance;
  Stream slides;

  bool isLoadingAllCards = false;
  bool isLoadingAnsCards = false;
  bool isLoadingUnansCards = false;

  String activeTag = 'All Cards';
  int t; //Tid
  double p;
  String currentFilter = "";
  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  playBackGroundSound() async {
    if (ThinkCardApp.sharedPreferences.getBool(ThinkCardApp.bgMusic)) {
      ThinkCardApp.player = await ThinkCardApp.cache.loop('safari.mp3');
      ThinkCardApp.player.setVolume(0.5);
    }
  }

  updatePageTracker() async {
    await ThinkCardApp.sharedPreferences
        .setString(ThinkCardApp.currentPage, "Game");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    playBackGroundSound();
    updatePageTracker();

    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      duration: const Duration(seconds: 0),
      vsync: this,
    )..forward();

    _controller3 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _controller4 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(0, 0.06),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    ));

    _animation2 = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    ));

    _animation3 = Tween<Offset>(
      begin: Offset(-0.5, 0.06),
      end: Offset(0.5, 0),
    ).animate(CurvedAnimation(
      parent: _controller3,
      curve: Curves.fastOutSlowIn,
    ));

    _animation4 = Tween<Offset>(
      begin: Offset(0.0, -0.3),
      end: Offset(0.0, 0.3),
    ).animate(CurvedAnimation(
      parent: _controller4,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ThinkCardApp.player.pause();
    }
    if (state == AppLifecycleState.resumed) {
      if (ThinkCardApp.sharedPreferences.getString(ThinkCardApp.currentPage) ==
          "Game") {
        ThinkCardApp.player.resume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ThinkCardApp.player.stop();
        Navigator.pop(context);
        await ThinkCardApp.sharedPreferences
            .setString(ThinkCardApp.currentPage, "Home");
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: MyAppBar(""),
          drawer: MyDrawer(),
          body: Container(
            color: Color(0xFFefebeb),
            child: Listener(
              onPointerMove: (pos) {
                //Get pointer position when pointer moves
                //If time since last scroll is undefined or over 100 milliseconds
                if (t == null ||
                    DateTime.now().millisecondsSinceEpoch - t > 100) {
                  t = DateTime.now().millisecondsSinceEpoch;
                  p = pos.position.dx; //x position
                } else {
                  //Calculate velocity
                  double v = (p - pos.position.dx) /
                      (DateTime.now().millisecondsSinceEpoch - t);
                  if (v < -2 || v > 2) {
                    //Don't run if velocity is to low
                    //Move to page based on velocity (increase velocity multiplier to scroll further)
                    ctrl.animateToPage(currentPage + (v * 0.8).round(),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic);
                  }
                }
              },
              child: StreamBuilder(
                  stream: slides,
                  initialData: [],
                  builder: (context, AsyncSnapshot snap) {
                    List slideList = snap.data.toList();

                    if (snap.data.length > 0) {
                      isLoadingAllCards = false;
                      isLoadingAnsCards = false;
                      isLoadingUnansCards = false;
                    }

                    if (snap.data.length == 0) {
                      print("no data");
                      if (isLoadingAllCards ||
                          isLoadingAnsCards ||
                          isLoadingUnansCards) {
                        Fluttertoast.showToast(msg: "No cards in this room");
                        isLoadingAllCards = false;
                        isLoadingAnsCards = false;
                        isLoadingUnansCards = false;
                      }
                    }

                    return PageView.builder(
                        controller: ctrl,
                        itemCount: slideList.length + 1,
                        itemBuilder: (context, int currentIdx) {
                          if (currentIdx == 0) {
                            return _buildTagPage();
                          } else if (slideList.length >= currentIdx) {
                            // Active page
                            bool active = currentIdx == currentPage;

                            return _buildStoryPage(
                                slideList[currentIdx - 1], active);
                          }
                        });
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Stream _queryDb({String tag = 'favorites'}) {
    // Make a Query
    Query query = db
        .collection('gameRooms')
        .document(widget.docID)
        .collection("stories")
        .where('tags', arrayContains: tag)
        .orderBy("id");

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = tag;
      currentFilter = "all";
    });
  }

  Stream _queryDbAnswered({String tag = 'favorites'}) {
    // Make a Query
    Query query = db
        .collection('gameRooms')
        .document(widget.docID)
        .collection("stories")
        .where('tags', arrayContains: "All Cards")
        .orderBy("id");

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = "answered";
      currentFilter = "answered";
    });
  }

  Stream _queryDbUnanswered({String tag = 'favorites'}) {
    // Make a Query
    Query query = db
        .collection('gameRooms')
        .document(widget.docID)
        .collection("stories")
        .where('tags', arrayContains: "All Cards")
        .orderBy("id");

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = "unanswered";
      currentFilter = "unanswered";
    });
  }

  // Builder Functions

  _buildStoryPage(Map data, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 5.h : 19.h;
    String userId =
        ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID);

    return SlideTransition(
      position: active ? _animation : _animation2,
      transformHitTests: true,
      textDirection: TextDirection.ltr,
      child: InkWell(
        enableFeedback: false,
        onDoubleTap: () {
          _modalBottomSheetMenu(data['id'], data['cardMainID']);
          ThinkCardApp.cache.play('pop.wav');
        },
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          speed: 1000,
          onFlipDone: (status) {
            print(status);
          },
          onFlip: () {
            ThinkCardApp.cache.play('flip.mp3');
          },
          front: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: top, bottom: 6.h, right: 4.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black87,
                      blurRadius: blur,
                      offset: Offset(offset, offset))
                ]),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: data['answered'].contains(userId) &&
                                  currentFilter == "unanswered"
                              ? AssetImage('assets/images/cardLook.png')
                              : currentFilter == "all"
                                  ? AssetImage('assets/images/cardLook.png')
                                  : data['answered'].contains(userId) &&
                                          currentFilter == "answered"
                                      ? AssetImage('assets/images/cardAns.png')
                                      : currentFilter == "answered"
                                          ? AssetImage(
                                              'assets/images/cardLook.png')
                                          : AssetImage(
                                              'assets/images/cardUn.png'),
                        ),
                      ),
                      padding: EdgeInsets.all(4.w),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.w),
                        child: Text(
                          data['id'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: data['id'] > 9 ? 15.sp : 18.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/cardFainted.png'),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 2.h),
                            Text(
                              data['desc'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 12.sp
                                        : 10.sp,
                                fontFamily: "Muli",
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: data['answered'].contains(userId) &&
                                  currentFilter == "unanswered"
                              ? AssetImage('assets/images/cardLook.png')
                              : currentFilter == "all"
                                  ? AssetImage('assets/images/cardLook.png')
                                  : data['answered'].contains(userId) &&
                                          currentFilter == "answered"
                                      ? AssetImage('assets/images/cardAns.png')
                                      : currentFilter == "answered"
                                          ? AssetImage(
                                              'assets/images/cardLook.png')
                                          : AssetImage(
                                              'assets/images/cardUn.png'),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.w),
                        child: Text(
                          data['id'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          back: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: top, bottom: 6.h, right: 4.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Color(0xFF222222),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black87,
                      blurRadius: blur,
                      offset: Offset(offset, offset))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/card.png",
                          height: 30.w,
                          width: 40.w,
                        ),
                        Text(
                          "ThinkCard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Signatra",
                          ),
                        ),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection("GameRoomresponses")
                                .where("cardID", isEqualTo: data['id'])
                                .where("gameRoomId", isEqualTo: widget.docID)
                                .limit(1)
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SpinKitDoubleBounce(
                                      color: Colors.white, size: 22.h),
                                );
                              }

                              if (snapshot.data.documents.length < 1) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 40.h,
                                        child: SpinKitCubeGrid(
                                            color: Colors.white, size: 22.h),
                                      ),
                                      Text(
                                        "No one has played this card yet, double tap this card",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: "Muli",
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                    ],
                                  ),
                                );
                              }

                              return Padding(
                                padding: EdgeInsets.only(top: 2.w),
                                child: new ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot _card =
                                        snapshot.data.documents[index];

                                    return Padding(
                                      padding: EdgeInsets.all(1.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.w),
                                          ),
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            1.w, 3.w, 1.w, 3.w),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: SizerUtil.deviceType ==
                                                      DeviceType.mobile
                                                  ? 38.h
                                                  : 36.h,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _card['response'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 7,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.sp,
                                                          fontFamily: "Muli",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 4.w),
                                                          child: Text(
                                                            "- " +
                                                                _card[
                                                                    'responderName'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10.sp,
                                                                fontFamily:
                                                                    "Muli",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _responseModalBottomSheetMenu(
                                                    data['id']);
                                              },
                                              child: Container(
                                                height: 6.h,
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF025373),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(CupertinoIcons.eye,
                                                        color: Colors.white,
                                                        size: 20),
                                                    SizedBox(width: 10),
                                                    Center(
                                                      child: Text(
                                                        "View Responses",
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTagPage() {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h, right: 5.w),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(15.w),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black87, blurRadius: 30, offset: Offset(20, 20))
          ]),
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cardLook.png'))),
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.w),
                    child: Text(
                      "0",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
            ),
            Image.asset(
              "assets/images/card.png",
              height: 15.h,
            ),
            Text(
              'Multi Player',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra",
                  color: Colors.black),
            ),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFf8f3f3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: 8.h,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF640c3f),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                      child: Center(
                        child: Icon(CupertinoIcons.person_badge_plus_fill,
                            color: Colors.white, size: 20.sp),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                          color: Colors.transparent,
                          textColor: Colors.black,
                          child: Text(
                            'Add Friends',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontFamily: "Muli",
                            ),
                          ),
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => AddMultiPlayers(
                                    widget.docID, widget.gameUsers));
                            Navigator.push(context, route);
                            if (ThinkCardApp.sharedPreferences
                                .getBool(ThinkCardApp.clickSound)) {
                              ThinkCardApp.cache.play('pop.wav');
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFf8f3f3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: 8.h,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF640c3f),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                      child: Center(
                        child: Icon(CupertinoIcons.folder_fill_badge_plus,
                            color: Colors.white, size: 20.sp),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                          color: Colors.transparent,
                          textColor: Colors.black,
                          child: Text(
                            'Add Cards',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontFamily: "Muli",
                            ),
                          ),
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (c) =>
                                    MultiplayerAddCard(widget.docID));
                            Navigator.push(context, route);
                            if (ThinkCardApp.sharedPreferences
                                .getBool(ThinkCardApp.clickSound)) {
                              ThinkCardApp.cache.play('pop.wav');
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.5.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      child: isLoadingAllCards == true
                          ? SpinKitCircle(color: Color(0xFF025373), size: 3.h)
                          : Container(
                              height: 3.h,
                            ),
                    ),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingAllCards = true;

                          isLoadingAnsCards = false;
                          isLoadingUnansCards = false;
                        });
                        _queryDb(tag: "All Cards");
                        if (ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.clickSound)) {
                          ThinkCardApp.cache.play('pop.wav');
                        }
                      },
                      child: Container(
                        height: 7.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xFF025373)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.circle_grid_hex,
                              color: Color(0xFF025373), size: 17.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: isLoadingAnsCards == true
                          ? SpinKitCircle(color: Color(0xFF025373), size: 3.h)
                          : Container(
                              height: 3.h,
                            ),
                    ),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingAnsCards = true;

                          isLoadingAllCards = false;
                          isLoadingUnansCards = false;
                        });
                        _queryDbAnswered(tag: "All Cards");
                        if (ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.clickSound)) {
                          ThinkCardApp.cache.play('pop.wav');
                        }
                      },
                      child: Container(
                        height: 7.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xFF05a895)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.checkmark_circle,
                              color: Color(0xFF05a895), size: 17.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: isLoadingUnansCards == true
                          ? SpinKitCircle(color: Color(0xFF025373), size: 3.h)
                          : Container(
                              height: 3.h,
                            ),
                    ),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingUnansCards = true;

                          isLoadingAllCards = false;

                          isLoadingAnsCards = false;
                        });
                        _queryDbUnanswered(tag: "All Cards");
                        if (ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.clickSound)) {
                          ThinkCardApp.cache.play('pop.wav');
                        }
                      },
                      child: Container(
                        height: 7.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Color(0xFFfb5a48)),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.xmark_circle,
                              color: Color(0xFFfb5a48), size: 17.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cardLook.png'))),
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.w),
                    child: Text(
                      "0",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: FlatButton(
            color: Colors.transparent,
            textColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Color(0xFFFA6E08), width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              '$tag',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              _queryDb(tag: tag);
            }),
      ),
    );
  }

  void _modalBottomSheetMenu(int cardID, String cardMainID) {
    var screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.2,
                maxChildSize: 0.90,
                builder: (_, controller) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 0),
                    decoration: BoxDecoration(
                      color: Color(0xFF222222),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.w),
                        topRight: Radius.circular(10.w),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(CupertinoIcons.chevron_compact_down,
                            color: Colors.white, size: 35.sp),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                color: Color(0xFF025373),
                                shape: BoxShape.circle),
                            child: Icon(CupertinoIcons.doc,
                                color: Colors.white, size: 16.sp),
                          ),
                        ),
                        Text(
                          "Answer this card below",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontFamily: "Muli",
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Color(0xFF0f1245),
                            primaryColorDark: Color(0xFF0f1245),
                          ),
                          child: TextFormField(
                            controller: _responseTextEditingController,
                            maxLines: 6,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 4.w
                                        : 3.w),
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.w),
                                borderSide: new BorderSide(
                                    width: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 2
                                        : 4,
                                    color: Colors.white),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(5.w),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  updateFirestore(cardID, cardMainID);
                                },
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF025373),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.floppy_disk,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      Center(
                                        child: Text(
                                          "Save",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: "Muli",
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _responseModalBottomSheetMenu(cardID);
                                },
                                child: Container(
                                  height: 6.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF025373),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.floppy_disk,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      Center(
                                        child: Text(
                                          "View Responses",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: "Muli",
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SlideTransition(
                          position: _animation3,
                          transformHitTests: true,
                          textDirection: TextDirection.ltr,
                          child: Image.asset("assets/images/card.png",
                              width: 80.w),
                        )
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

  Future updateFirestore(int cardInfoID, String cardMainID) async {
    showDialog(
        context: context,
        builder: (c) {
          return SpinKitWanderingCubes(color: Colors.white, size: 100);
        });
    Firestore.instance.collection("GameRoomresponses").document().setData({
      "cardID": cardInfoID,
      "cardMainID": cardMainID,
      "gameRoomId": widget.docID,
      "responder":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID),
      "responderName":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userName),
      "category": "Word",
      "response": _responseTextEditingController.text.trim(),
      "time": DateTime.now(),
    }).then((value) {
      Firestore.instance
          .collection("gameRooms")
          .document(widget.docID)
          .collection("stories")
          .document(cardMainID)
          .updateData({
        "answered": FieldValue.arrayUnion(
            [ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID)])
      });
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '',
        desc: 'Your response has been saved',
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
      )..show();

      _responseTextEditingController.clear();
    });
  }

  void _responseModalBottomSheetMenu(int cardID) {
    var screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.2,
                maxChildSize: 0.90,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                          size: 35.sp,
                        ),
                        Expanded(
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('GameRoomresponses')
                                  .where("cardID", isEqualTo: cardID)
                                  .where("responder",
                                      isEqualTo: ThinkCardApp.sharedPreferences
                                          .getString(ThinkCardApp.userUID))
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SpinKitDoubleBounce(
                                        color: Colors.white, size: 22.h),
                                  );
                                }

                                if (snapshot.data.documents.length < 1) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: SlideTransition(
                                              position: _animation4,
                                              transformHitTests: true,
                                              textDirection: TextDirection.ltr,
                                              child: Image.asset(
                                                "assets/images/multi2.png",
                                                height: 60.w,
                                                width: 60.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "You have not answered this card yet!",
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              fontFamily: "Muli",
                                              color: Color(0xFF05242C)),
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.only(top: 2.w),
                                  child: new ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot _card =
                                          snapshot.data.documents[index];

                                      return Padding(
                                        padding: EdgeInsets.all(1.w),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.w),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFf3efef),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.w),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                1.w, 3.w, 1.w, 3.w),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 20.w,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFF025373),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .pencil_outline,
                                                        color: Colors.white,
                                                        size: 20.sp,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        _card['response'],
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF333333),
                                                          fontSize: 10.sp,
                                                          fontFamily: "Muli",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2.h),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 6.w, right: 6.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .clock_fill,
                                                            color: Color(
                                                                0xFF025373),
                                                            size: 15.sp,
                                                          ),
                                                          Text(
                                                            "${ThinkCardApp.timeFormat2.format(_card['time'].toDate())}",
                                                            style: TextStyle(
                                                              fontSize: 8.sp,
                                                              fontFamily:
                                                                  "Muli",
                                                              color: Color(
                                                                  0xFF808080),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "- " +
                                                            _card[
                                                                'responderName'],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF808080),
                                                            fontSize: 10.sp,
                                                            fontFamily: "Muli",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
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
}
