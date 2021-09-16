import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think/auth/login.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/home.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  AnimationController _registerController;

  Animation<Offset> _animation, _animation2, _animation3, _animation4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _registerController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _registerController,
      curve: Interval(0.16, 0.32, curve: Curves.fastOutSlowIn),
    ));
    _animation2 = Tween<Offset>(
      begin: Offset(2.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _registerController,
      curve: Interval(0.32, 0.48, curve: Curves.fastOutSlowIn),
    ));
    _animation3 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _registerController,
      curve: Interval(0.48, 0.64, curve: Curves.fastOutSlowIn),
    ));
    _animation4 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _registerController,
      curve: Interval(0.64, 80, curve: Curves.easeInOutSine),
    ));
  }

  @override
  void dispose() {
    _registerController.dispose();

    super.dispose();
  }

  final TextEditingController _fullNameTextEditingController =
      TextEditingController();

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();

  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  String displayUsername;
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(flip: false),
              child: Container(
                height: screenHeight * 0.45,
                color: Color(0xFF0f1245),
                child: Center(
                  child: SlideTransition(
                    position: _animation,
                    transformHitTests: true,
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
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SlideTransition(
                    position: _animation2,
                    transformHitTests: true,
                    child: InkWell(
                      onTap: () => _selectAndPickImage(),
                      child: CircleAvatar(
                        radius: SizerUtil.deviceType == DeviceType.mobile
                            ? 15.w
                            : 10.w,
                        backgroundColor: Color(0xFF0f1245),
                        backgroundImage:
                            _imageFile == null ? null : FileImage(_imageFile),
                        child: _imageFile == null
                            ? Icon(
                                Icons.add_a_photo_sharp,
                                size: SizerUtil.deviceType == DeviceType.mobile
                                    ? 15.w
                                    : 10.w,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Form(
                      key: _formKey,
                      child: SlideTransition(
                        position: _animation3,
                        transformHitTests: true,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameTextEditingController,
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 4.w
                                          : 3.w),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.5.h, vertical: 2.5.h),
                                prefixIcon: Padding(
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Full Name",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                            SizedBox(height: 1.5.h),
                            TextFormField(
                              controller: _nameTextEditingController,
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 4.w
                                          : 3.w),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.5.h, vertical: 2.5.h),
                                prefixIcon: Padding(
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Username",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                            SizedBox(height: 1.5.h),
                            TextFormField(
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
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Email",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                            SizedBox(height: 1.5.h),
                            TextFormField(
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
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                            SizedBox(height: 1.5.h),
                            TextFormField(
                              controller: _cPasswordTextEditingController,
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
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Confirm Password",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                            SizedBox(height: 1.5.h),
                            TextFormField(
                              controller: _phoneNumberTextEditingController,
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.mobile
                                          ? 4.w
                                          : 3.w),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.5.h, vertical: 2.5.h),
                                prefixIcon: Padding(
                                  padding:
                                      EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Icon(Icons.person,
                                      color: Color(0xFF0f1245), size: 17.sp),
                                ),

                                labelText: "Phone Number",
                                labelStyle: TextStyle(
                                  fontSize: 8.sp,
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
                          ],
                        ),
                      )),
                  SizedBox(height: 25),
                  SlideTransition(
                    position: _animation3,
                    transformHitTests: true,
                    child: Column(
                      children: [
                        Container(
                          height: 6.h,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          width: double.infinity,
                          child: FlatButton(
                            child: Text(
                              "Register",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 13
                                        : 9.sp,
                                color: Color(0xFFffffff),
                                fontFamily: "Muli",
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (c) {
                                    return SpinKitWanderingCubes(
                                        color: Colors.white, size: 15.h);
                                  });
                              String name =
                                  _nameTextEditingController.text.toLowerCase();
                              final valid = await usernameCheck(
                                  toBeginningOfSentenceCase(name));

                              String searchIndex = toBeginningOfSentenceCase(
                                  _nameTextEditingController.text.trim());

                              String firstLetter = searchIndex[0];
                              print(firstLetter);
                              if (!valid) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: true,
                                  dialogType: DialogType.ERROR,
                                  body: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: SizerUtil.deviceType ==
                                                    DeviceType.mobile
                                                ? 1.h
                                                : 4.h),
                                        Text(
                                          'Username is taken',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: "Muli",
                                          ),
                                        ),
                                        SizedBox(
                                            height: SizerUtil.deviceType ==
                                                    DeviceType.mobile
                                                ? 1.h
                                                : 4.h)
                                      ],
                                    ),
                                  ),
                                  buttonsTextStyle: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                  ),
                                  desc: 'Your response has been saved',
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red,
                                  btnOkOnPress: () {},
                                )..show();
                              } else {
                                uploadAndsaveImage();
                              }
                            },
                            color: Color(0xFF0f1245),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
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
                        SizedBox(height: 2.h),
                        Container(
                          height: 6.h,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          width: double.infinity,
                          child: FlatButton(
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 13
                                        : 9.sp,
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
                            onPressed: () {},
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      Fluttertoast.showToast(msg: "Image Selected successfully");
    } else {
      Fluttertoast.showToast(msg: "You have not selected an image");
    }
  }

  Future<bool> usernameCheck(String username) async {
    String capitalised = toBeginningOfSentenceCase(username);
    final result = await Firestore.instance
        .collection('users')
        .where('displayName', isEqualTo: capitalised)
        .getDocuments();

    if (result.documents.isEmpty) {
      displayUsername = toBeginningOfSentenceCase(username);
    }
    return result.documents.isEmpty;
  }

  Future<void> uploadAndsaveImage() async {
    if (_imageFile == null) {
      AwesomeDialog(
        context: context,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  height:
                      SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h),
              Text(
                'Please Select an Image',
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
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
      )..show();
    } else {
      _passwordTextEditingController.text ==
              _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cPasswordTextEditingController.text.isNotEmpty &&
                  _nameTextEditingController.text.isNotEmpty &&
                  _phoneNumberTextEditingController.text.isNotEmpty &&
                  _fullNameTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please Complete form Appropriately")
          : displayDialog("Password do not match");
    }
  }

  displayDialog(String msg) {
    AwesomeDialog(
      context: context,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: true,
      dialogType: DialogType.ERROR,
      body: Center(
        child: Column(
          children: [
            SizedBox(
                height: SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h),
            Text(
              msg,
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
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
      btnOkOnPress: () {},
    )..show();
  }

  uploadToStorage() async {
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);

      AwesomeDialog(
        context: context,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  height:
                      SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h),
              Text(
                error.message.toString(),
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
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
      )..show();
    });

    if (firebaseUser != null) {
      saveUserInfoToFirestore(firebaseUser).then((value) {
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
                  'Your account has been created!',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: "Muli",
                  ),
                ),
                SizedBox(
                    height:
                        SizerUtil.deviceType == DeviceType.mobile ? 1.h : 4.h)
              ],
            ),
          ),
          buttonsTextStyle: TextStyle(
            fontSize: 10.sp,
            fontFamily: "Muli",
          ),
          desc: 'Your response has been saved',
          btnOkText: "Proceed to login",
          btnOkOnPress: () {
            Route route = MaterialPageRoute(builder: (c) => Login());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Login()));
            });
          },
          btnOkIcon: Icons.check_circle,
        )..show();
      });
    }
  }

  Future saveUserInfoToFirestore(FirebaseUser fUser) async {
    String name = _nameTextEditingController.text.toLowerCase();

    String searchIndex = toBeginningOfSentenceCase(name);

    String firstLetter = searchIndex[0];
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "searchKey": firstLetter,
      "fullName": _fullNameTextEditingController.text.trim(),
      "displayName": displayUsername,
      "phoneNumber": _phoneNumberTextEditingController.text.trim(),
      "url": userImageUrl,
      "unViewed": 0,
      "activeGameRooms": [],
      "pendingInvites": [],
      "allowUsers": true,
      "Sub": "Trial",
      "SubTrialEnd":
          DateTime.now().add(Duration(days: 0, hours: 0, minutes: 2)),
    });
  }
}
