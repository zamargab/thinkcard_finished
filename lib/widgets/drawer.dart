import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/auth/login.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/multiplayer.dart';
import 'package:think/profile.dart';
import 'package:think/settings.dart';
import 'package:sizer/sizer.dart';
import 'package:think/sizeConfig.dart';

import '../home.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      child: Drawer(
        child: Container(
          color: Color(0xFF025373),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/back3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.5, 2.h, 0.5.h, 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 2.w),
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 4.h,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 8.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: ThinkCardApp.sharedPreferences
                              .getString(ThinkCardApp.userAvatarUrl),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 21.h,
                            height: 21.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 6),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => SpinKitDoubleBounce(
                              color: Colors.white, size: 22.h),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 8.h,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.only(left: 2.w),
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 4.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  ThinkCardApp.sharedPreferences
                      .getString(ThinkCardApp.fullName),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Muli",
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  ThinkCardApp.sharedPreferences
                      .getString(ThinkCardApp.userEmail),
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: "Muli",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFcecccc)),
                ),
                SizedBox(height: 6.h),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.house_fill,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 5.w),
                            InkWell(
                              onTap: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => Home(false));
                                Navigator.pushReplacement(context, route);
                                updatePageTracker();
                              },
                              child: Text(
                                "Home",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "Muli",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(
                              builder: (c) => MultiPlayerHome());
                          Navigator.push(context, route);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.gamecontroller_alt_fill,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Game Rooms",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      InkWell(
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (c) => Profile());
                          Navigator.push(context, route);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons
                                    .person_crop_circle_fill_badge_checkmark,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "Muli",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        margin: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Divider(color: Color(0xFFcecccc)),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Route route =
                              MaterialPageRoute(builder: (c) => Settings());
                          Navigator.push(context, route);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.gear_alt,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "Muli",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              btnCancelText: "Cancel",
                              btnCancelColor: Color(0xFF025373),
                              btnOkColor: Color(0xFF025373),
                              btnOkText: "Logout",
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              width: SizerUtil.deviceType == DeviceType.mobile
                                  ? 60.h
                                  : 50.h,
                              buttonsTextStyle: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 10.sp
                                        : 8.sp,
                                fontFamily: "Muli",
                              ),
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              title: '',
                              body: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 1.h
                                            : 3.h),
                                    Text(
                                      'Do you want to logout?',
                                      style: TextStyle(
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 10.sp
                                            : 8.sp,
                                        fontFamily: "Muli",
                                      ),
                                    ),
                                    SizedBox(
                                        height: SizerUtil.deviceType ==
                                                DeviceType.mobile
                                            ? 1.h
                                            : 3.h)
                                  ],
                                ),
                              ),
                              btnCancelOnPress: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              btnOkOnPress: () async {
                                await ThinkCardApp.sharedPreferences
                                    .setString("uid", "");
                                ThinkCardApp.auth.signOut().then((value) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Route route = MaterialPageRoute(
                                      builder: (c) => Login());
                                  Navigator.pushReplacement(context, route);
                                });
                              },
                            )..show();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "Muli",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.waveform_circle_fill,
                      color: Color(0xFFcecccc),
                      size: 20.sp,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "ThinkCard",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: "Signatra",
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFcecccc)),
                    ),
                  ],
                ),
                ClipPath(
                  clipper: WaveClipperTwo(reverse: true),
                  child: Container(
                    height: 10.h,
                    color: Color(0xFF2ea3d7),
                    child: Center(
                      child: Text(""),
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

  updatePageTracker() async {
    await ThinkCardApp.sharedPreferences
        .setString(ThinkCardApp.currentPage, "Game");
  }
}
