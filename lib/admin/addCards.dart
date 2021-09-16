import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';

class AdminAddCards extends StatefulWidget {
  AdminAddCards({Key key}) : super(key: key);

  @override
  _AdminAddCardsState createState() => _AdminAddCardsState();
}

class _AdminAddCardsState extends State<AdminAddCards> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _desc1TextEditingController =
      TextEditingController();
  final TextEditingController _desc2TextEditingController =
      TextEditingController();

  final TextEditingController _answersTextEditingController =
      TextEditingController();
  var currentSelectedValue;
  var deviceTypes = [
    "Word",
    "Random Questions",
    "Basic Logic and Reasonong",
    "Basic Christian Knowledge"
  ];
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: MyAppBar(""),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select Category",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Muli",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            fillColor: Color(0xFF0f1245),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(
                                  width: 2, color: Color(0xFF025373)),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: currentSelectedValue,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  currentSelectedValue = newValue;
                                });
                                print(currentSelectedValue);
                              },
                              items: deviceTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: currentSelectedValue == "Word",
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Card Title",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Muli",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentSelectedValue == "Word",
                      child: TextFormField(
                        controller: _titleTextEditingController,
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
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description",
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    Visibility(
                      visible: currentSelectedValue ==
                              "Basic Logic and Reasonong" ||
                          currentSelectedValue == "Basic Christian Knowledge",
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Card Answer",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Muli",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: currentSelectedValue ==
                              "Basic Logic and Reasonong" ||
                          currentSelectedValue == "Basic Christian Knowledge",
                      child: TextFormField(
                        controller: _answersTextEditingController,
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

  Future saveCardToFirestore() async {
    if (currentSelectedValue == "Word") {
      showDialog(
          context: context,
          builder: (c) {
            return SpinKitWanderingCubes(color: Colors.white, size: 100);
          });
      final QuerySnapshot qSnap =
          await Firestore.instance.collection('stories').getDocuments();
      var number = qSnap.documents.length + 1;
      DocumentReference documentReference =
          Firestore.instance.collection("stories").document();
      documentReference.setData({
        "id": number,
        "title": _titleTextEditingController.text.trim(),
        "desc": _desc1TextEditingController.text.trim(),
        "tags": ["All Cards"],
        'cardMainID': documentReference.documentID,
        "answered": []
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
    } else if (currentSelectedValue == "Random Questions") {
      showDialog(
          context: context,
          builder: (c) {
            return SpinKitWanderingCubes(color: Colors.white, size: 100);
          });
      final QuerySnapshot qSnap =
          await Firestore.instance.collection('randomQuestions').getDocuments();
      var number = qSnap.documents.length + 1;
      DocumentReference documentReference =
          Firestore.instance.collection("randomQuestions").document();
      documentReference.setData({
        "id": number,
        "title": "Random Question",
        "desc": _desc1TextEditingController.text.trim(),
        "tags": ["All Cards"],
        'cardMainID': documentReference.documentID,
        "answered": []
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
    } else if (currentSelectedValue == "Basic Logic and Reasonong") {
      showDialog(
          context: context,
          builder: (c) {
            return SpinKitWanderingCubes(color: Colors.white, size: 100);
          });
      final QuerySnapshot qSnap =
          await Firestore.instance.collection('basicLogic').getDocuments();
      var number = qSnap.documents.length + 1;
      DocumentReference documentReference =
          Firestore.instance.collection("basicLogic").document();
      documentReference.setData({
        "id": number,
        "desc": _desc1TextEditingController.text.trim(),
        "answer": _answersTextEditingController.text.trim(),
        "tags": ["All Cards"],
        'cardMainID': documentReference.documentID,
        "answered": []
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
    } else if (currentSelectedValue == "Basic Christian Knowledge") {
      showDialog(
          context: context,
          builder: (c) {
            return SpinKitWanderingCubes(color: Colors.white, size: 100);
          });
      final QuerySnapshot qSnap =
          await Firestore.instance.collection('basicChristian').getDocuments();
      var number = qSnap.documents.length + 1;
      DocumentReference documentReference =
          Firestore.instance.collection("basicChristian").document();
      documentReference.setData({
        "id": number,
        "desc": _desc1TextEditingController.text.trim(),
        "answer": _answersTextEditingController.text.trim(),
        "tags": ["All Cards"],
        'cardMainID': documentReference.documentID,
        "answered": []
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
  }
}
