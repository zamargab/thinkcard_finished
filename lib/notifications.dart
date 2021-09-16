import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    ThinkCardApp.player.stop();
    updatePageTracker();
  }

  updatePageTracker() async {
    await ThinkCardApp.sharedPreferences
        .setString(ThinkCardApp.currentPage, "Notifications");
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppBar("Notifications"),
      drawer: MyDrawer(),
      body: Column(
        children: [
          StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(ThinkCardApp.sharedPreferences
                      .getString(ThinkCardApp.userUID))
                  .collection("notifications")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.30),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: SpinKitDoubleBounce(
                          color: Color(0xFF025373), size: 80),
                    )),
                  );
                }

                if (snapshot.data.documents.length < 1) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/notifications.png",
                            height: 40.h,
                            width: 60.w,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "No Notifications",
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: "Muli",
                                color: Color(0xFF05242C)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return new ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot _card =
                        snapshot.data.documents[index];

                    return InkWell(
                      onTap: () {
                        if (_card['status'] == "0") {
                          if (_card['gameRoomID'] == "receieverToken") {
                            toggleRecieverNotification(_card['notificationID']);
                          } else {
                            AwesomeDialog(
                              context: context,
                              btnCancelColor: Color(0xFF025373),
                              btnOkColor: Color(0xFF025373),
                              btnCancelText: "Reject",
                              buttonsTextStyle: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.mobile
                                        ? 10.sp
                                        : 8.sp,
                                fontFamily: "Muli",
                              ),
                              btnOkText: "Accept",
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              width: SizerUtil.deviceType == DeviceType.mobile
                                  ? 60.h
                                  : 50.h,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              headerAnimationLoop: false,
                              animType: AnimType.BOTTOMSLIDE,
                              title: '',
                              body: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Do you want to accept this invitation?',
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
                                            : 7.h)
                                  ],
                                ),
                              ),
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                acceptInvitation(
                                    _card['gameRoomID'],
                                    _card['notificationID'],
                                    _card['sentBy'],
                                    _card['gameRoomName']);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Route route = MaterialPageRoute(
                                    builder: (c) => NotificationPage());
                                Navigator.push(context, route);
                              },
                            )..show();
                          }
                        }
                      },
                      child: _card['gameRoomID'] == "receieverToken"
                          ? Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 2.0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf3efef),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.fromLTRB(
                                        2.w, 4.5.w, 2.w, 4.5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20.w,
                                          padding: EdgeInsets.all(1.w),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF025373),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: EdgeInsets.all(1.5.w),
                                            child: Icon(
                                                CupertinoIcons.person_3_fill,
                                                color: Colors.white,
                                                size: 20.sp),
                                          ),
                                        ),
                                        Container(
                                          width: 2.w,
                                          child: Icon(
                                            CupertinoIcons.app_fill,
                                            color: _card['status'] == "0"
                                                ? Colors.redAccent
                                                : Color(0xFF808080),
                                            size: 3.w,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 4.w, right: 2.w),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      _card['receiver'] +
                                                          "has accepted your invite to the Game Room called " +
                                                          _card['gameRoomName'],
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontFamily: "Muli",
                                                        color: _card[
                                                                    'status'] ==
                                                                "0"
                                                            ? Colors.black
                                                            : Color(0xFF808080),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "${ThinkCardApp.timeFormat2.format(_card['date'].toDate())}",
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        fontFamily: "Muli",
                                                        color: _card[
                                                                    'status'] ==
                                                                "0"
                                                            ? Colors.black
                                                            : Color(0xFF808080),
                                                      ),
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
                                ],
                              ),
                            )
                          : Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 2.0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFf3efef),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.fromLTRB(
                                        2.w, 4.5.w, 2.w, 4.5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20.w,
                                          padding: EdgeInsets.all(1.w),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF025373),
                                              shape: BoxShape.circle),
                                          child: Padding(
                                            padding: EdgeInsets.all(1.5.w),
                                            child: Icon(
                                                CupertinoIcons.person_3_fill,
                                                color: Colors.white,
                                                size: 20.sp),
                                          ),
                                        ),
                                        Container(
                                          width: 2.w,
                                          child: Icon(
                                            CupertinoIcons.app_fill,
                                            color: _card['status'] == "0"
                                                ? Colors.redAccent
                                                : Color(0xFF808080),
                                            size: 3.w,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 4.w, right: 2.w),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      _card['senderName'] +
                                                          " has invited you to a Game Room called " +
                                                          _card['gameRoomName'],
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontFamily: "Muli",
                                                        color: _card[
                                                                    'status'] ==
                                                                "0"
                                                            ? Colors.black
                                                            : Color(0xFF808080),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "${ThinkCardApp.timeFormat2.format(_card['date'].toDate())}",
                                                      style: TextStyle(
                                                        fontSize: 9.sp,
                                                        fontFamily: "Muli",
                                                        color: _card[
                                                                    'status'] ==
                                                                "0"
                                                            ? Colors.black
                                                            : Color(0xFF808080),
                                                      ),
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
                                ],
                              ),
                            ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  toggleRecieverNotification(String notificationID) {
    Firestore.instance
        .collection("users")
        .document(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
        .collection("notifications")
        .document(notificationID)
        .updateData({
      "status": "1",
    }).then((value) async {
      var unViewedCounter = await Firestore.instance
          .collection('users')
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .get();
      int previousCount = unViewedCounter["unViewed"];
      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .updateData({"unViewed": previousCount - 1});
    });
  }

  acceptInvitation(String gameRoomId, String notifyID, String sentBy,
      String gameRoomName) async {
    Firestore.instance.collection("gameRooms").document(gameRoomId).updateData({
      "gameusers": FieldValue.arrayUnion(
          [ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID)])
    }).then((value) async {
      //update user active game rooms
      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .updateData({
        "activeGameRooms": [gameRoomId],
      });

      //update status of notification
      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .collection("notifications")
          .document(notifyID)
          .updateData({
        "status": "1",
      });

      //update unviewed Count
      var unViewedCounter = await Firestore.instance
          .collection('users')
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .get();
      int previousCount = unViewedCounter["unViewed"];

      Firestore.instance
          .collection("users")
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .updateData({"unViewed": previousCount - 1});
    });

    //update pending invites
    var val = [];
    val.add(gameRoomId);
    Firestore.instance
        .collection("users")
        .document(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
        .updateData({"pendingInvites": FieldValue.arrayRemove(val)});

    //inform inviter of acceptance
    var uuid2 = Uuid();
    String notifyID2 = uuid2.v1();
    Firestore.instance
        .collection("users")
        .document(sentBy)
        .collection("notifications")
        .document(notifyID2)
        .setData({
      "notificationID": notifyID2,
      "gameRoomID": "receieverToken",
      "receiver":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userName),
      "gameRoomName": gameRoomName,
      "date": DateTime.now(),
      "status": "0"
    }).then((value) async {
      var unViewedCounter =
          await Firestore.instance.collection('users').document(sentBy).get();

      int previousCount = unViewedCounter["unViewed"];
      Firestore.instance
          .collection("users")
          .document(sentBy)
          .updateData({"unViewed": previousCount + 1});
    });
  }
}
