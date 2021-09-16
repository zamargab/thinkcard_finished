import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class name extends StatefulWidget {
  name({Key key}) : super(key: key);

  @override
  _nameState createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 85.w,
              child: Container(
                width: 35.w,
                height: 35.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.w),
                    color: Colors.green,
                    shape: BoxShape.circle),
                child: Icon(
                  CupertinoIcons.gamecontroller_alt_fill,
                  color: Colors.white,
                  size: 15.w,
                ),
              ),
            ),
            Container(
              height: 21.h,
              width: 85.w,
              child: Column(
                children: [
                  Text(
                    "No Game Room found!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontFamily: "Muli",
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Color(0xFF025373),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(CupertinoIcons.checkmark_alt,
                              color: Colors.white, size: 16.sp),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.w),
                              Text(
                                "Click the button below to create a game room",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontFamily: "Muli",
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF808080),
                                ),
                              ),
                              SizedBox(height: 1.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 7.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          color: Color(0xFF025373),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Create",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: "Muli",
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
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
    );
  }
}
