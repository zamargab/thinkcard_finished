import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:think/Onboarding/body.dart';
import 'package:think/auth/login.dart';
import 'package:think/config/colors.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/home.dart';
import 'package:think/multiplayer.dart';
import 'package:think/multiplayerStart.dart';
import 'package:think/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThinkCardApp.auth = FirebaseAuth.instance;
  ThinkCardApp.sharedPreferences = await SharedPreferences.getInstance();
  ThinkCardApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'ThinkCard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: SplashScreen(),
      );
    });
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation heartbeatAnimation;
  bool loaderToggle = false;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    heartbeatAnimation =
        Tween<double>(begin: 0.h, end: 20.h).animate(controller);
    controller.forward();
    controller.addStatusListener((_) async {
      if (controller.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 1));
      }
    });

    Timer(Duration(seconds: 3), () {
      loaderToggle = true;
    });

    super.initState();
    displaySplash();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  showLoader() {}

  displaySplash() {
    Timer(Duration(seconds: 6), () async {
      if (await ThinkCardApp.auth.currentUser() != null) {
        var document = await ThinkCardApp.firestore
            .collection('users')
            .document(
                ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
            .get();

        //check expired
        if (document["SubDueDate"] != null) {
          if (DateTime.now().isAfter(document["SubDueDate"].toDate())) {
            await ThinkCardApp.sharedPreferences
                .setString(ThinkCardApp.Sub, "Expired");
            ThinkCardApp.firestore
                .collection("users")
                .document(ThinkCardApp.sharedPreferences
                    .getString(ThinkCardApp.userUID))
                .updateData({
              "Sub": "Expired",
            });
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Expired");
          } else {
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Active paid user");
          }
        } else {
          if (document["Sub"] == "Trial") {
            if (DateTime.now().isAfter(document["SubTrialEnd"].toDate())) {
              await ThinkCardApp.sharedPreferences
                  .setString(ThinkCardApp.Sub, "Expired");
              ThinkCardApp.firestore
                  .collection("users")
                  .document(ThinkCardApp.sharedPreferences
                      .getString(ThinkCardApp.userUID))
                  .updateData({
                "Sub": "Expired",
              });
              Route route = MaterialPageRoute(builder: (_) => Home(false));
              Navigator.pushReplacement(context, route);
              print("Trial Expired");
            } else {
              Route route = MaterialPageRoute(builder: (_) => Home(false));
              Navigator.pushReplacement(context, route);
              print("Trial active");
            }
          }

          if (document["Sub"] == "Expired") {
            await ThinkCardApp.sharedPreferences
                .setString(ThinkCardApp.Sub, "Expired");
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Expired User");
          }

          if (document["Sub"] == "Paid") {
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Subbed user");
          }
        }
      } else {
        Route route = MaterialPageRoute(builder: (_) => Onbording());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: heartbeatAnimation,
        builder: (context, widget) {
          return Material(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Color(0xFF025373), Color(0xFF025373)],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/card.png",
                            height: heartbeatAnimation.value,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "ThinkCard",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Signatra",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Container(
                        height: 7.h,
                        child: SpinKitCircle(color: Colors.white, size: 7.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
