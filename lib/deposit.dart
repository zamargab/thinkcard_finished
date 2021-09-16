import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Deposit extends StatefulWidget {
  Deposit(this.amount, {Key key}) : super(key: key);

  final int amount;

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
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
                  Container(
                    margin: EdgeInsets.fromLTRB(5.w, 5.w, 3.w, 1.w),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(CupertinoIcons.house_fill,
                          color: Colors.white, size: 15.sp),
                    ),
                  ),
                  Text(
                    "Make payment below",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: "Muli",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Your data is secured by Flutterwave",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontFamily: "Muli",
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Image.asset(
                    "assets/images/bill.png",
                    height: 33.h,
                    width: 33.h,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
