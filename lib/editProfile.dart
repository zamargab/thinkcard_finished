import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/home.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _fullNameTextEditingController =
      TextEditingController();

  String userImageUrl = "";

  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: 100.w,
                decoration: new BoxDecoration(
                  color: Color(0xFF025373),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => Home(false));
                        Navigator.push(context, route);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.w, 5.w, 3.w, 1.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(CupertinoIcons.house_fill,
                              color: Colors.white, size: 15.sp),
                        ),
                      ),
                    ),
                    Text(
                      "Edit profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: "Muli",
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Use the form below to edit your profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: "Muli",
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Image.asset(
                      "assets/images/profile.png",
                      height: 33.h,
                      width: 33.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.h, 2.h, 5.h, 2.h),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _selectAndPickImage(),
                      child: CircleAvatar(
                        radius: SizerUtil.deviceType == DeviceType.mobile
                            ? 15.w
                            : 10.w,
                        backgroundColor: Color(0xFF025373),
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
                    SizedBox(height: 3.h),
                    TextFormField(
                      controller: _fullNameTextEditingController,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 4.w
                              : 3.w),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 2.5.h, vertical: 2.5.h),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 4.w, left: 2.w),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF0f1245),
                            size: 17.sp,
                          ),
                        ),

                        labelText: "Enter Full name",
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
                    SizedBox(height: 2.h),
                    TextFormField(
                      controller: _phoneNumberTextEditingController,
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 4.w
                              : 3.w),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 2.5.h, vertical: 2.5.h),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 4.w, left: 2.w),
                          child: Icon(
                            Icons.phone,
                            color: Color(0xFF0f1245),
                            size: 17.sp,
                          ),
                        ),

                        labelText: "Enter Phone number",
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
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        uploadImageToStorage();
                      },
                      child: Container(
                        height: 6.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Color(0xFF025373),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  ],
                ),
              ),
            ],
          ),
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

  uploadImageToStorage() async {
    if (_imageFile != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) {
            return SpinKitWanderingCubes(color: Colors.white, size: 13.h);
          });
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(imageFileName);

      StorageUploadTask storageUploadTask =
          storageReference.putFile(_imageFile);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        userImageUrl = urlImage;

        saveEdit();
      });
    } else {
      saveEdit();
    }
  }

  saveEdit() {
    if (_fullNameTextEditingController.text != "" ||
        _phoneNumberTextEditingController.text != "" ||
        _imageFile != null) {
      if (_imageFile == null) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) {
              return SpinKitWanderingCubes(color: Colors.white, size: 13.h);
            });
      }
      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .updateData({
        "fullName": _fullNameTextEditingController.text != ""
            ? _fullNameTextEditingController.text.trim()
            : ThinkCardApp.sharedPreferences.getString(ThinkCardApp.fullName),
        "phoneNumber": _phoneNumberTextEditingController.text != ""
            ? _phoneNumberTextEditingController.text.trim()
            : ThinkCardApp.sharedPreferences
                .getString(ThinkCardApp.phoneNumber),
        "url": _imageFile != null
            ? userImageUrl
            : ThinkCardApp.sharedPreferences
                .getString(ThinkCardApp.userAvatarUrl),
      }).then((value) async {
        if (_imageFile != null) {
          await ThinkCardApp.sharedPreferences
              .setString(ThinkCardApp.userAvatarUrl, userImageUrl);
        }

        if (_fullNameTextEditingController.text != "") {
          await ThinkCardApp.sharedPreferences.setString(
              ThinkCardApp.fullName, _fullNameTextEditingController.text);
        }

        if (_phoneNumberTextEditingController.text != "") {
          await ThinkCardApp.sharedPreferences.setString(
              ThinkCardApp.phoneNumber, _phoneNumberTextEditingController.text);
        }

        _fullNameTextEditingController.clear();
        _phoneNumberTextEditingController.clear();
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
                  'Saved succesfully',
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
          desc: 'Saved succesfully',
          btnOkOnPress: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          btnOkIcon: Icons.check_circle,
        )..show();
      });
    } else {
      Fluttertoast.showToast(msg: "You have not made any modification");
    }
  }
}
