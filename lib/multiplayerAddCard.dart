import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/notifications.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';

import 'config/thinkcard.dart';

class MultiplayerAddCard extends StatefulWidget {
  MultiplayerAddCard(
    this.gameRoomID, {
    Key key,
  }) : super(key: key);

  final String gameRoomID;

  @override
  _MultiplayerAddCardState createState() => _MultiplayerAddCardState();
}

class _MultiplayerAddCardState extends State<MultiplayerAddCard> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _desc1TextEditingController =
      TextEditingController();
  final TextEditingController _desc2TextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppBar("Notifications"),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(
            minHeight: screenheight * 0.9,
          ),
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/response.png",
                  width: screenWidth * 0.8,
                ),
              ),
              Text(
                "Add new card",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: "Muli",
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Form(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Card Details",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Muli",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _desc1TextEditingController,
                        maxLines: 4,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          fillColor: Color(0xFF0f1245),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(
                                width: 2, color: Color(0xFF025373)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF025373), width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          saveCardToFirestore();
                        },
                        child: Container(
                          height: 45,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Color(0xFF025373),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Muli",
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future saveCardToFirestore() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return SpinKitWanderingCubes(color: Colors.white, size: 100);
        });
    final QuerySnapshot qSnap = await Firestore.instance
        .collection('gameRooms')
        .document(widget.gameRoomID)
        .collection("stories")
        .getDocuments();
    var number = qSnap.documents.length + 1;
    DocumentReference documentReference = Firestore.instance
        .collection("gameRooms")
        .document(widget.gameRoomID)
        .collection("stories")
        .document();
    documentReference.setData({
      "creatorID":
          ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID),
      "id": number,
      "desc": _desc1TextEditingController.text.trim(),
      "answered": [],
      "tags": ["All Cards"],
      'cardMainID': documentReference.documentID,
    }).then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: '',
        desc: 'Card added successfully!',
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
