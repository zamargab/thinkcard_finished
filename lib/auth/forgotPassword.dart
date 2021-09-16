import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:think/auth/login.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _resetTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              ClipPath(
                clipper: WaveClipperTwo(flip: false),
                child: Container(
                  height: 50.h,
                  color: Color(0xFF0f1245),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/card.png',
                          height: 25.h,
                        ),
                        Text(
                          'Think Card',
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
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.fromLTRB(5.h, 2.h, 5.h, 2.h),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Enter your registered email below to reset password",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Muli",
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.h, 1.h, 5.h, 0.h),
                child: TextFormField(
                  controller: _resetTextEditingController,
                  style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                          ? 4.w
                          : 3.w),
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 2.5.h, vertical: 2.5.h),
                    fillColor: Color(0xFFCC5500),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(3.h),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.h),
                      borderSide:
                          new BorderSide(color: Color(0xFFFA6E08), width: 2),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.h, 1.4.h, 5.h, 2.h),
                child: Container(
                  height: 8.h,
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      "Reset password",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    onPressed: () {
                      resetPassword();
                    },
                    color: Color(0xFF0f1245),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return SpinKitWanderingCubes(color: Colors.white, size: 20.h);
        });
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth
        .sendPasswordResetEmail(email: _resetTextEditingController.text.trim())
        .then((value) {
      Route route = MaterialPageRoute(builder: (c) => Login());
      Navigator.pushReplacement(context, route);

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
                'Password reset email sent',
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
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      )..show();
    });
  }
}
