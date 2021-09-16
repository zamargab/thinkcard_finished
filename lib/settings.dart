import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:think/admin/addCards.dart';
import 'package:think/manageSubscriptions.dart';
import 'package:think/notifications.dart';
import 'package:think/privacy.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';

import 'config/thinkcard.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ThinkCardApp.player.stop();
    updatePageTracker();
  }

  updatePageTracker() async {
    await ThinkCardApp.sharedPreferences
        .setString(ThinkCardApp.currentPage, "Settings");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("Settings"),
      drawer: MyDrawer(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 1.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Background music",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                                color: Colors.black),
                          ),
                          Text(
                            "Toggle on and off to switch state of background music",
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontFamily: "Muli",
                                color: Color(0xFF808080)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CupertinoSwitch(
                        value: ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.bgMusic),
                        activeColor: Color(0xFF025373),
                        onChanged: (value) {
                          setState(() {
                            updateBgMusic(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Click Sound",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                                color: Colors.black),
                          ),
                          Text(
                            "Turn Click Sound on and off",
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontFamily: "Muli",
                                color: Color(0xFF808080)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CupertinoSwitch(
                        value: ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.clickSound),
                        activeColor: Color(0xFF025373),
                        onChanged: (value) {
                          setState(() {
                            updateclikSound(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: InkWell(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (c) => ManageSubscriptions());
                    Navigator.push(context, route);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Manage Subscriptions",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: "Muli",
                                  color: Colors.black),
                            ),
                            Text(
                              "Click here to view and manage your subscription ",
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  fontFamily: "Muli",
                                  color: Color(0xFF808080)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w, right: 6.w),
                        child: Icon(
                          CupertinoIcons.chevron_right_circle,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Game Room",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                                color: Colors.black),
                          ),
                          Text(
                            "Allow users to add me to Game Rooms",
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontFamily: "Muli",
                                color: Color(0xFF808080)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CupertinoSwitch(
                        value: ThinkCardApp.sharedPreferences
                            .getBool(ThinkCardApp.allowUsers),
                        activeColor: Color(0xFF025373),
                        onChanged: (value) {
                          setState(() {
                            updateAllowusers(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "App Version",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                                color: Colors.black),
                          ),
                          Text(
                            "V 1.0.2",
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontFamily: "Muli",
                                color: Color(0xFF808080)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, right: 6.w),
                      child: Icon(
                        CupertinoIcons.chevron_right_circle,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: InkWell(
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => Privacy());
                    Navigator.push(context, route);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: "Muli",
                                  color: Colors.black),
                            ),
                            Text(
                              "Click here to view and manage your subscription ",
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  fontFamily: "Muli",
                                  color: Color(0xFF808080)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w, right: 6.w),
                        child: Icon(
                          CupertinoIcons.chevron_right_circle,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              /*
              Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: InkWell(
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => AdminAddCards());
                    Navigator.push(context, route);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin Access",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: "Muli",
                                  color: Colors.black),
                            ),
                            Text(
                              "Click here to access admin panel",
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  fontFamily: "Muli",
                                  color: Color(0xFF808080)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w, right: 6.w),
                        child: Icon(
                          CupertinoIcons.chevron_right_circle,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }

  updateBgMusic(bool newValue) async {
    await ThinkCardApp.sharedPreferences
        .setBool(ThinkCardApp.bgMusic, newValue);
    if (newValue == false) {
      ThinkCardApp.player.stop();

      print(newValue);
    }

    if (newValue == true) {
      print(newValue);
    }
  }

  updateclikSound(bool newValue) async {
    await ThinkCardApp.sharedPreferences
        .setBool(ThinkCardApp.clickSound, newValue);
  }

  updateAllowusers(bool newValue) async {
    await ThinkCardApp.sharedPreferences
        .setBool(ThinkCardApp.allowUsers, newValue);

    Firestore.instance
        .collection("users")
        .document(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
        .updateData({
      "allowUsers": newValue,
    });
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
