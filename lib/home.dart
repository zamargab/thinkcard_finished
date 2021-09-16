import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think/basicChristian.dart';
import 'package:think/basicLogic.dart';

import 'package:think/config/thinkcard.dart';
import 'package:think/howToPlay.dart';
import 'package:think/multiplayer.dart';
import 'package:think/notifications.dart';
import 'package:think/randomQuestions.dart';
import 'package:think/settings.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:think/wordCart.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  Home(this.registered, {Key key}) : super(key: key);
  final bool registered;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _controller, _rippleController;

  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> alphaAnimation;

  Animation<Offset> _animation,
      _animation2,
      _animation3,
      _animation4,
      _animation5,
      _animation6;
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ThinkCardApp.player.stop();

    if (widget.registered) {
      print("registered");
    }

    _rippleController = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: _rippleController, curve: Curves.decelerate);
    animation = Tween(begin: (7.5.h * 2) / 7.5, end: (7.5.h * 2) * (3 / 4))
        .animate(curve)
          ..addListener(() {
            setState(() {});
          });
    animation2 = Tween(begin: 0.0, end: (7.5.h * 2)).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    alphaAnimation = Tween(begin: 0.70, end: 0.0).animate(_rippleController);
    _rippleController.addStatusListener((_) async {
      if (_rippleController.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 50));
        _rippleController.reset();
        _rippleController.forward();
      }
    });
    _rippleController.forward();

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.16, 0.32, curve: Curves.fastOutSlowIn),
    ));
    _animation2 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.32, 0.48, curve: Curves.fastOutSlowIn),
    ));
    _animation3 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.48, 0.64, curve: Curves.fastOutSlowIn),
    ));
    _animation4 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.64, 0.80, curve: Curves.fastOutSlowIn),
    ));
    _animation5 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.80, 1, curve: Curves.fastOutSlowIn),
    ));

    _animation6 = Tween<Offset>(
      begin: Offset(SizerUtil.deviceType == DeviceType.mobile ? -5 : -9, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.77, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

/*
  playBackGroundSound() async {
    if (ThinkCardApp.sharedPreferences.getBool(ThinkCardApp.bgMusic)) {
      ThinkCardApp.player = await ThinkCardApp.cache.loop('safari.mp3');
      ThinkCardApp.player.setVolume(0.5);
    }
  }

  */

  @override
  void dispose() {
    _rippleController.dispose();
    _controller.dispose();
    super.dispose();
  }

/*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ThinkCardApp.player.stop();
    }
    if (state == AppLifecycleState.resumed) {
      playBackGroundSound();
    }
  }

  */

  int _currentIndex = 0;
  List cardList = [Item1(), Item2(), Item3(), Item4()];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  /*  
    callSounds() {
    Timer(Duration(milliseconds: 1200), () {
      ThinkCardApp.player.play('Unlock.mp3');
    });

    Timer(Duration(milliseconds: 2400), () {
      ThinkCardApp.player.play('Unlock.mp3');
    });

    Timer(Duration(milliseconds: 3600), () {
      ThinkCardApp.player.play('Unlock.mp3');
    });

    Timer(Duration(milliseconds: 4800), () {
      ThinkCardApp.player.play('Final8.mp3');
    });
  }

  */

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(""),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 37.h,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: cardList.map((card) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.blueAccent,
                          child: card,
                        ),
                      );
                    });
                  }).toList(),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: _screenWidth,
                  decoration: new BoxDecoration(
                    color: Color(0xFFeeecec),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Select a category to play",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontFamily: "Muli",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      SlideTransition(
                        position: _animation,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            if (ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.Sub) ==
                                "Expired") {
                              ThinkCardApp.cache.play('error.mp3');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  title: '',
                                  desc:
                                      "Please go to settings and purchase a subcription package",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (c) => FirestoreSlideshow());
                              Navigator.push(context, route);
                              updatePageTracker();
                              if (ThinkCardApp.sharedPreferences
                                  .getBool(ThinkCardApp.clickSound)) {
                                ThinkCardApp.cache.play('pop.wav');
                              }
                            }
                          },
                          child: homeBox(
                              "Word",
                              "Tell us what you feel about certain words that will be randomly displayed ob cards",
                              CupertinoIcons.layers_alt,
                              Color(0xFF025373)),
                        ),
                      ),
                      SizedBox(height: 15),
                      SlideTransition(
                        position: _animation2,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            if (ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.Sub) ==
                                "Expired") {
                              ThinkCardApp.cache.play('error.mp3');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  title: '',
                                  desc:
                                      "Please go to settings and purchase a subcription package",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (c) => RandomQuestions());
                              Navigator.push(context, route);
                              updatePageTracker();
                              if (ThinkCardApp.sharedPreferences
                                  .getBool(ThinkCardApp.clickSound)) {
                                ThinkCardApp.cache.play('pop.wav');
                              }
                            }
                          },
                          child: homeBox(
                              "Random Questions",
                              "Tell us what you feel about certain words that will be randomly displayed ob cards",
                              CupertinoIcons.link_circle_fill,
                              Color(0xFFF938FD)),
                        ),
                      ),
                      SizedBox(height: 15),
                      SlideTransition(
                        position: _animation3,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            if (ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.Sub) ==
                                "Expired") {
                              ThinkCardApp.cache.play('error.mp3');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  title: '',
                                  desc:
                                      "Please go to settings and purchase a subcription package",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (c) => BasicLogic());
                              Navigator.push(context, route);
                              updatePageTracker();
                              if (ThinkCardApp.sharedPreferences
                                  .getBool(ThinkCardApp.clickSound)) {
                                ThinkCardApp.cache.play('pop.wav');
                              }
                            }
                          },
                          child: homeBox(
                              "Basic Logic and Reasoning",
                              "Tell us what you feel about certain words that will be randomly displayed ob cards",
                              CupertinoIcons.circle_grid_hex,
                              Color(0xFFFA6E08)),
                        ),
                      ),
                      SizedBox(height: 15),
                      SlideTransition(
                        position: _animation4,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            if (ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.Sub) ==
                                "Expired") {
                              ThinkCardApp.cache.play('error.mp3');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  title: '',
                                  desc:
                                      "Please go to settings and purchase a subcription package",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (c) => BasicChristian());
                              Navigator.push(context, route);
                              updatePageTracker();
                              if (ThinkCardApp.sharedPreferences
                                  .getBool(ThinkCardApp.clickSound)) {
                                ThinkCardApp.cache.play('pop.wav');
                              }
                            }
                          },
                          child: homeBox(
                              "Basic Christian Knowledge",
                              "Tell us what you feel about certain words that will be randomly displayed ob cards",
                              CupertinoIcons.book_circle,
                              Colors.redAccent),
                        ),
                      ),
                      SizedBox(height: 15),
                      SlideTransition(
                        position: _animation5,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child: InkWell(
                          onTap: () {
                            if (ThinkCardApp.sharedPreferences
                                    .getString(ThinkCardApp.Sub) ==
                                "Expired") {
                              ThinkCardApp.cache.play('error.mp3');
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  title: '',
                                  desc:
                                      "Please go to settings and purchase a subcription package",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            } else {
                              Route route = MaterialPageRoute(
                                  builder: (c) => MultiPlayerHome());
                              Navigator.push(context, route);
                              updatePageTracker();
                              if (ThinkCardApp.sharedPreferences
                                  .getBool(ThinkCardApp.clickSound)) {
                                ThinkCardApp.cache.play('pop.wav');
                              }
                            }
                          },
                          child: homeBox(
                              "Play with Friends",
                              "Tell us what you feel about certain words that will be randomly displayed ob cards",
                              CupertinoIcons.book_circle,
                              Colors.greenAccent),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: SlideTransition(
          position: _animation6,
          transformHitTests: true,
          textDirection: TextDirection.ltr,
          child: Container(
            margin: EdgeInsets.all(0),
            height: 6.5.h * 2,
            width: 6.5.h * 2,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: animation2.value,
                  width: animation2.value,
                  child: SizedBox(),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xFF025373).withOpacity(alphaAnimation.value)),
                ),
                Container(
                  height: animation.value,
                  width: animation.value,
                  child: SizedBox(),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xFF025373).withOpacity(alphaAnimation.value)),
                ),
                SizedBox(
                  height: 7.h,
                  width: 7.h,
                  child: FloatingActionButton(
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => HowToPlay());
                        Navigator.push(context, route);
                      },
                      child: Text(
                        "Help",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: "Muli",
                        ),
                      ),
                      backgroundColor: Color(0xFF025373)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatePageTracker() async {
    await ThinkCardApp.sharedPreferences
        .setString(ThinkCardApp.currentPage, "Game");
  }

  Widget homeBox(String title, String descText, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 20.sp),
              ),
              SizedBox(
                width: 3.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: "Muli",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      descText,
                      style: TextStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                            ? 10.sp
                            : 8.sp,
                        fontFamily: "Muli",
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF808080),
                      ),
                    ),
                    SizedBox(
                        height: SizerUtil.deviceType == DeviceType.mobile
                            ? 2.w
                            : 3.w),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Icon(CupertinoIcons.chevron_right_circle,
                    color: Colors.black, size: 20.sp),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(
                ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
            .get(),
        builder: (c, snapshot) {
          if (!snapshot.hasData)
            return Text(
              "",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ); //CIRCULAR INDICATOR
          else {
            return Text(
              snapshot.data["unViewed"].toString(),
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            );
          }
        },
      ),
      child: IconButton(
          icon: Icon(
            CupertinoIcons.bell,
            color: Colors.black,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => NotificationPage());
            Navigator.push(context, route);
          }),
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
            'assets/images/card.png',
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Welcome to ThinkCard",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Here, get thrilled by our categories of card games",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage('assets/images/bg5.jpg'),
            fit: BoxFit.cover,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/multi2.png',
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "MultiPlayer games",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Enjoy Thinkcard with friends and family anyday",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage('assets/images/bg5.jpg'),
            fit: BoxFit.cover,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/anyone.png',
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Anyone can Play",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "Thincard is easy to use and suitable for everyone",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: AssetImage('assets/images/bg5.jpg'),
            fit: BoxFit.cover,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/response.png',
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "View Cards your Anytime",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Text(
              "You can always return to card to view your responses",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
