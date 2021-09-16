import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';

class HowToPlay extends StatefulWidget {
  HowToPlay({Key key}) : super(key: key);

  @override
  _HowToPlayState createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: MyAppBar("How To Play"),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(3.w, 4.w, 3.w, 5.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontFamily: "Muli",
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
