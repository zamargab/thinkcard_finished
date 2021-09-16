import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:think/searchservice.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:uuid/uuid.dart';

import 'config/thinkcard.dart';

class AddMultiPlayers extends StatefulWidget {
  AddMultiPlayers(
    this.docID,
    this.gameUsers, {
    Key key,
  }) : super(key: key);
  final String docID;
  final List gameUsers;

  @override
  _AddMultiPlayersState createState() => _AddMultiPlayersState();
}

class _AddMultiPlayersState extends State<AddMultiPlayers> {
  final TextEditingController _userTextEditingController =
      TextEditingController();

  var queryResultSet = [];
  var tempSearchStore = [];

  bool membersAnimatedOpacity = true;

  bool resultCardVisibility = false;
  bool animatedResultCardVisibility = false;

  bool searchVisibility = true;
  bool animatedSearchVisibility = true;
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        setState(() {
          resultCardVisibility = false;
          resultCardVisibility = false;
          membersAnimatedOpacity = true;

          searchVisibility = true;
          animatedSearchVisibility = true;
        });
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      setState(() {
        resultCardVisibility = true;
        animatedResultCardVisibility = true;
        membersAnimatedOpacity = false;

        animatedSearchVisibility = false;
        searchVisibility = false;
      });
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['displayName'].startsWith(capitalizedValue)) {
          if (element['uid'] !=
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(""),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: searchVisibility ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 2000),
                  child: Visibility(
                    visible: searchVisibility,
                    child: Container(
                      child: Image.asset(
                        "assets/images/search.png",
                        height: screenHeight * 0.35,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Search and add friends",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontFamily: "Muli",
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        onChanged: (val) {
                          initiateSearch(val);
                        },
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.search),
                              iconSize: 20.0,
                              onPressed: () {},
                            ),
                            contentPadding: EdgeInsets.only(left: 25.0),
                            hintText: 'Search by name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFFCC5500), width: 2.0),
                                borderRadius: BorderRadius.circular(4.0))),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Visibility(
                      visible: resultCardVisibility,
                      child: GridView.count(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        primary: false,
                        shrinkWrap: true,
                        children: tempSearchStore.map((element) {
                          return buildResultCard(element);
                        }).toList(),
                      ),
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .where('activeGameRooms', arrayContains: widget.docID)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: const Text('Loading events...'));
                        }
                        return AnimatedOpacity(
                            opacity: membersAnimatedOpacity ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 2000),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("Room members",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontFamily: "Muli",
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: screenWidth,
                                  child: GridView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 1.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFefebeb),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 50,
                                                backgroundImage: AssetImage(
                                                    "assets/images/loader.gif"),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data
                                                              .documents[index]
                                                          ['url']),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Center(
                                                  child: Text(
                                                snapshot.data.documents[index]
                                                    ['displayName'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17.0,
                                                    fontFamily: "Muli",
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFefebeb),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  if (data['allowUsers']) {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return SpinKitWanderingCubes(
                              color: Colors.white, size: 100);
                        });
                    if (data['pendingInvites'].contains(widget.docID)) {
                      Navigator.of(context, rootNavigator: true).pop();
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.RIGHSLIDE,
                          headerAnimationLoop: true,
                          title: '',
                          desc:
                              "This user has been invited but has not responded to your invite",
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red)
                        ..show();
                    } else if (data['activeGameRooms'].contains(widget.docID)) {
                      Navigator.of(context, rootNavigator: true).pop();
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          animType: AnimType.RIGHSLIDE,
                          headerAnimationLoop: true,
                          title: '',
                          desc: "This user is already in this Game Room",
                          btnOkOnPress: () {},
                          btnOkIcon: Icons.cancel,
                          btnOkColor: Colors.red)
                        ..show();
                    } else {
                      addUser(data['uid']);
                    }
                  } else {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: true,
                        title: '',
                        desc:
                            "This user does not want to be added to game rooms",
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red)
                      ..show();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFFFA6E08), shape: BoxShape.circle),
                  child: Icon(
                    CupertinoIcons.plus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              backgroundImage: AssetImage("assets/images/loader.gif"),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(data['url']),
              ),
            ),
            Center(
                child: Text(
              data['displayName'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontFamily: "Muli",
                  fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }

  addUser(String userID) async {
    showDialog(
        context: context,
        builder: (c) {
          return SpinKitWanderingCubes(color: Colors.white, size: 100);
        });
    var document = await Firestore.instance
        .collection('gameRooms')
        .document(widget.docID)
        .get();

    var unViewedCounter =
        await Firestore.instance.collection('users').document(userID).get();

    int previousCount = unViewedCounter["unViewed"];
    var uuid = Uuid();
    String notifyID = uuid.v1();
    Firestore.instance
        .collection("users")
        .document(userID)
        .collection("notifications")
        .document(notifyID)
        .setData({
      "gameRoomID": widget.docID,
      "sentBy": ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID),
      "sentTo": userID,
      "status": "0",
      "notificationID": notifyID,
      "gameRoomName": document["name"],
      "senderName":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userName),
      "senderImgUrl":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userAvatarUrl),
      "date": DateTime.now(),
      "seen": "0"
    });

    Firestore.instance.collection("users").document(userID).updateData({
      "pendingInvites": FieldValue.arrayUnion([widget.docID])
    });

    Firestore.instance
        .collection("users")
        .document(userID)
        .updateData({"unViewed": previousCount + 1}).then((value) {
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
                'your reqquest has been sent!',
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
    });
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
