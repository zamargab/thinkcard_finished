import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think/auth/forgotPassword.dart';
import 'package:think/auth/register.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/home.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController _loginController;

  Animation<Offset> _animation, _animation2, _animation3, _animation4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedInirial();

    _loginController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _loginController,
      curve: Interval(0.16, 0.32, curve: Curves.fastOutSlowIn),
    ));
    _animation2 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _loginController,
      curve: Interval(0.32, 0.48, curve: Curves.fastOutSlowIn),
    ));
    _animation3 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _loginController,
      curve: Interval(0.48, 0.64, curve: Curves.fastOutSlowIn),
    ));
    _animation4 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _loginController,
      curve: Interval(0.64, 1.0, curve: Curves.easeInOutSine),
    ));
  }

  @override
  void dispose() {
    _loginController.dispose();

    super.dispose();
  }

  Future<void> sharedInirial() async {
    ThinkCardApp.sharedPreferences = await SharedPreferences.getInstance();
  }

  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(flip: false),
              child: Container(
                height: 50.h,
                color: Color(0xFF0f1245),
                child: Center(
                  child: SlideTransition(
                    position: _animation,
                    transformHitTests: true,
                    textDirection: TextDirection.ltr,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/card.png',
                          height: 25.h,
                        ),
                        Text(
                          'ThinkCard',
                          style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Signatra",
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SlideTransition(
                          position: _animation2,
                          transformHitTests: true,
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _emailTextEditingController,
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 4.w
                                        : 3.w),
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.5.h, vertical: 2.5.h),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 4.w, left: 2.w),
                                child: Icon(
                                  Icons.mail,
                                  color: Color(0xFF0f1245),
                                  size: 17.sp,
                                ),
                              ),

                              labelText: "Enter Email",
                              labelStyle: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                              ),

                              fillColor: Color(0xFF0f1245),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.w),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SlideTransition(
                          position: _animation2,
                          transformHitTests: true,
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _passwordTextEditingController,
                            obscureText: true,
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 4.w
                                        : 3.w),
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.5.h, vertical: 2.5.h),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 4.w, left: 2.w),
                                child: Icon(
                                  Icons.lock,
                                  color: Color(0xFF0f1245),
                                  size: 17.sp,
                                ),
                              ),

                              labelText: "Enter Password",
                              labelStyle: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                              ),
                              fillColor: Color(0xFF0f1245),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.w),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SlideTransition(
                      position: _animation4,
                      transformHitTests: true,
                      textDirection: TextDirection.ltr,
                      child: InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (c) => ForgotPassword());
                          Navigator.push(context, route);
                        },
                        child: Text(
                          "Forgot Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Color(0xFF0f1245),
                            fontFamily: "Muli",
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 6.5.h,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: double.infinity,
                    child: SlideTransition(
                      position: _animation3,
                      transformHitTests: true,
                      textDirection: TextDirection.ltr,
                      child: FlatButton(
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 13
                                : 8.sp,
                            color: Color(0xFFffffff),
                            fontFamily: "Muli",
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        onPressed: () {
                          loginUser();
                        },
                        color: Color(0xFF0f1245),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SlideTransition(
                    position: _animation3,
                    transformHitTests: true,
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: Color(0xFF0f1245),
                        )),
                        Text(
                          "  Or  ",
                          style: TextStyle(
                            fontSize: 5.sp,
                            fontFamily: "Muli",
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: Color(0xFF0f1245),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    height: 6.5.h,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: double.infinity,
                    child: SlideTransition(
                      position: _animation3,
                      transformHitTests: true,
                      textDirection: TextDirection.ltr,
                      child: FlatButton(
                        child: Text(
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.mobile
                                ? 13
                                : 8.sp,
                            color: Color(0xFF0f1245),
                            fontFamily: "Muli",
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color(0xFF0f1245),
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (c) => Register());
                          Navigator.pushReplacement(context, route);
                        },
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return SpinKitWanderingCubes(color: Colors.white, size: 13.h);
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: '',
          desc: error.message.toString(),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    });

    if (firebaseUser != null) {
      readData(firebaseUser).then((s) async {
        var document = await ThinkCardApp.firestore
            .collection('users')
            .document(firebaseUser.uid)
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
            Navigator.of(context, rootNavigator: true).pop();
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Expired");
          } else {
            Navigator.of(context, rootNavigator: true).pop();
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
              Navigator.of(context, rootNavigator: true).pop();
              Route route = MaterialPageRoute(builder: (_) => Home(false));
              Navigator.pushReplacement(context, route);
              print("Trial Expired");
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              Route route = MaterialPageRoute(builder: (_) => Home(false));
              Navigator.pushReplacement(context, route);
              print("Trial active");
            }
          }

          if (document["Sub"] == "Expired") {
            await ThinkCardApp.sharedPreferences
                .setString(ThinkCardApp.Sub, "Expired");
            Navigator.of(context, rootNavigator: true).pop();
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Expired User");
          }

          if (document["Sub"] == "Paid") {
            Navigator.of(context, rootNavigator: true).pop();
            Route route = MaterialPageRoute(builder: (_) => Home(false));
            Navigator.pushReplacement(context, route);
            print("Subbed user");
          }
        }
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await ThinkCardApp.sharedPreferences
          .setString("uid", dataSnapshot.data[ThinkCardApp.userUID]);

      await ThinkCardApp.sharedPreferences.setString(
          ThinkCardApp.userEmail, dataSnapshot.data[ThinkCardApp.userEmail]);

      await ThinkCardApp.sharedPreferences
          .setString(ThinkCardApp.userName, dataSnapshot.data["displayName"]);

      await ThinkCardApp.sharedPreferences.setString(
          ThinkCardApp.phoneNumber, dataSnapshot.data["phoneNumber"]);

      await ThinkCardApp.sharedPreferences.setString(ThinkCardApp.userAvatarUrl,
          dataSnapshot.data[ThinkCardApp.userAvatarUrl]);

      await ThinkCardApp.sharedPreferences
          .setString(ThinkCardApp.fullName, dataSnapshot.data["fullName"]);

      await ThinkCardApp.sharedPreferences
          .setString(ThinkCardApp.Sub, dataSnapshot.data["Sub"]);

      //setting files
      await ThinkCardApp.sharedPreferences.setBool(ThinkCardApp.bgMusic, true);
      await ThinkCardApp.sharedPreferences
          .setBool(ThinkCardApp.clickSound, true);
      await ThinkCardApp.sharedPreferences
          .setBool(ThinkCardApp.allowUsers, dataSnapshot.data["allowUsers"]);

      //current page tracker
      await ThinkCardApp.sharedPreferences
          .setString(ThinkCardApp.currentPage, "Home");
    });
  }
}
