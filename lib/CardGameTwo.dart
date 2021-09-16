import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';

class CardGameTemplateTwo extends StatefulWidget {
  final String dbName;
  final String title;
  final String responseDB;

  const CardGameTemplateTwo({Key key, this.dbName, this.title, this.responseDB})
      : super(key: key);

  @override
  _CardGameTemplateTwoState createState() => _CardGameTemplateTwoState();
}

class _CardGameTemplateTwoState extends State<CardGameTemplateTwo>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final PageController ctrl = PageController(viewportFraction: 0.8);
  final TextEditingController _responseTextEditingController =
      TextEditingController();

  final Firestore db = Firestore.instance;
  Stream slides;

  String activeTag = 'All Cards';
  int t; //Tid
  double p;

  AnimationController _controller, _controller2, _controller3, _controller4;
  Animation<Offset> _animation, _animation2, _animation3, _animation4;

  String currentFilter = "";

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  bool isLoadingAllCards = false;
  bool isLoadingAnsCards = false;
  bool isLoadingUnansCards = false;

  playBackGroundSound() async {
    if (ThinkCardApp.sharedPreferences.getBool(ThinkCardApp.bgMusic)) {
      ThinkCardApp.player = await ThinkCardApp.cache.loop('safari.mp3');
      ThinkCardApp.player.setVolume(0.5);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    playBackGroundSound();
    _queryDb();

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
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
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
        .collection(widget.dbName)
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

  Stream _queryDbAnswered() {
    // Make a Query
    Query query = db.collection(widget.dbName).orderBy("id");

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = "answered";
      currentFilter = "answered";
    });
  }

  Stream _queryDbUnanswered() {
    // Make a Query
    Query query = db.collection(widget.dbName).orderBy("id");

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
    return GestureDetector(
      onLongPress: () {
        _controller.stop();
      },
      onLongPressUp: () {
        _controller.repeat(reverse: true);
      },
      child: SlideTransition(
        position: active ? _animation : _animation2,
        transformHitTests: true,
        textDirection: TextDirection.ltr,
        child: InkWell(
          enableFeedback: false,
          onDoubleTap: () {
            _modalBottomSheetMenu(data['id'], data['cardMainID']);
            if (ThinkCardApp.sharedPreferences
                .getBool(ThinkCardApp.clickSound)) {
              ThinkCardApp.cache.play('pop.wav');
            }
          },
          child: FlipCard(
            direction: FlipDirection.HORIZONTAL,
            speed: 1000,
            onFlip: () {
              ThinkCardApp.cache.play('flip.mp3');
            },
            onFlipDone: (status) {
              print(status);
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
                                        ? AssetImage(
                                            'assets/images/cardAns.png')
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
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 12.sp
                                          : 10.sp,
                                  color: Color(0xFF808080),
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
                                        ? AssetImage(
                                            'assets/images/cardAns.png')
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
                          SizedBox(height: 5.h),
                          Container(
                            height: SizerUtil.deviceType == DeviceType.mobile
                                ? 38.h
                                : 36.h,
                            child: Text(
                              data['answer'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 7,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 16.sp
                                          : 12.sp,
                                  fontFamily: "Signatra",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _responseModalBottomSheetMenu(data['id']);
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
                                  Icon(CupertinoIcons.eye,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //all cards
  }

  _buildTagPage() {
    var screenHeight = MediaQuery.of(context).size.width;
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
              height: 18.h,
            ),
            Text(
              widget.title + ' Category',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra",
                  color: Color(0xFF025373)),
            ),
            SizedBox(height: 2.h),
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
                          color: Color(0xFF025373),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.rectangle_3_offgrid,
                              color: Colors.white, size: 18.sp),
                        )),
                    Expanded(
                      child: InkWell(
                        enableFeedback: false,
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
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "All Cards",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Container(
                                margin: EdgeInsets.only(right: 4.w),
                                width: 6.w,
                                child: isLoadingAllCards == true
                                    ? SpinKitCircle(
                                        color: Color(0xFF025373), size: 3.h)
                                    : Container(
                                        height: 6.h,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          color: Color(0xFF05a895),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.checkmark_circle,
                              color: Colors.white, size: 18.sp),
                        )),
                    Expanded(
                      child: InkWell(
                        enableFeedback: false,
                        onTap: () {
                          setState(() {
                            isLoadingAnsCards = true;

                            isLoadingAllCards = false;
                            isLoadingUnansCards = false;
                          });
                          _queryDbAnswered();
                          if (ThinkCardApp.sharedPreferences
                              .getBool(ThinkCardApp.clickSound)) {
                            ThinkCardApp.cache.play('pop.wav');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "Answered Cards",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 4.w),
                                width: 6.w,
                                child: isLoadingAnsCards == true
                                    ? SpinKitCircle(
                                        color: Color(0xFF025373), size: 3.h)
                                    : Container(height: 6.h),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                          color: Color(0xFFfb5a48),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(4.w, 1.w, 4.w, 1.w),
                        child: Center(
                          child: Icon(CupertinoIcons.xmark_circle_fill,
                              color: Colors.white, size: 18.sp),
                        )),
                    Expanded(
                      child: InkWell(
                        enableFeedback: false,
                        onTap: () {
                          setState(() {
                            isLoadingUnansCards = true;

                            isLoadingAllCards = false;

                            isLoadingAnsCards = false;
                          });
                          _queryDbUnanswered();
                          if (ThinkCardApp.sharedPreferences
                              .getBool(ThinkCardApp.clickSound)) {
                            ThinkCardApp.cache.play('pop.wav');
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "Unanswered Cards",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Container(
                                margin: EdgeInsets.only(right: 4.w),
                                width: 6.w,
                                child: isLoadingUnansCards == true
                                    ? SpinKitCircle(
                                        color: Color(0xFF025373), size: 3.h)
                                    : Container(height: 6.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFf8f3f3),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 50,
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color(0xFF025373),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Center(
                  child: Icon(CupertinoIcons.floppy_disk,
                      color: Colors.white, size: 20),
                )),
            Expanded(
              child: FlatButton(
                  color: Colors.transparent,
                  textColor: Colors.black,
                  child: Text(
                    '$tag',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _queryDb(tag: tag);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(int cardID, String cardMainID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            onDoubleTap: () => Navigator.of(context, rootNavigator: true).pop(),
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
                          topLeft: Radius.circular(5.w),
                          topRight: Radius.circular(5.w),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.chevron_compact_down,
                              color: Colors.white, size: 35.sp),
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
                              maxLines:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 6
                                      : 6,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 4.w
                                          : 3.w),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.h, vertical: 2.h),

                                fillColor: Color(0xFFCC5500),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.eye,
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
                                width: 85.w),
                          )
                        ],
                      ),
                    );
                  },
                ),
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
    Firestore.instance.collection(widget.responseDB).document().setData({
      "cardID": cardInfoID,
      "responder":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID),
      "category": widget.title,
      "response": _responseTextEditingController.text.trim(),
      "time": DateTime.now(),
    }).then((value) {
      Firestore.instance
          .collection(widget.dbName)
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
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  height:
                      SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h),
              Text(
                'Your response has been saved',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                ),
              ),
              SizedBox(
                  height: SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h)
            ],
          ),
        ),
        buttonsTextStyle: TextStyle(
          fontSize: 10.sp,
          fontFamily: "Muli",
        ),
        desc: 'Your response has been saved',
        btnOk: null,
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      )..show();

      _responseTextEditingController.clear();
    });
  }

  void _responseModalBottomSheetMenu(int cardID) {
    var screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.001),
              child: GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 0.80,
                  minChildSize: 0.2,
                  maxChildSize: 0.80,
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
                          Icon(CupertinoIcons.chevron_compact_down,
                              color: Colors.black, size: 35.sp),
                          Expanded(
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection(widget.responseDB)
                                    .where("cardID", isEqualTo: cardID)
                                    .where("responder",
                                        isEqualTo: ThinkCardApp
                                            .sharedPreferences
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
                                                textDirection:
                                                    TextDirection.ltr,
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
                                                            EdgeInsets.all(3.w),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xFF025373),
                                                                shape: BoxShape
                                                                    .circle),
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
                                                              color: Color(
                                                                  0xFF333333),
                                                              fontSize: 10.sp,
                                                              fontFamily:
                                                                  "Muli",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons
                                                              .clock_fill,
                                                          color:
                                                              Color(0xFF025373),
                                                          size: 15.sp,
                                                        ),
                                                        Text(
                                                          "${ThinkCardApp.timeFormat2.format(_card['time'].toDate())}",
                                                          style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontFamily: "Muli",
                                                            color: Color(
                                                                0xFF808080),
                                                          ),
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
          ),
        );
      },
    );
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
