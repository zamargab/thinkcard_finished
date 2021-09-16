import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:think/editProfile.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:sizer/sizer.dart';

import 'config/thinkcard.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  AnimationController _controller, _rippleController;

  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> alphaAnimation;

  Animation<Offset> _animation,
      _animation2,
      _animation3,
      _animation4,
      _animation5,
      _animation6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ThinkCardApp.player.stop();
    _rippleController = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: _rippleController, curve: Curves.decelerate);
    animation =
        Tween(begin: (80.0 * 2) / 6, end: (80.0 * 2) * (3 / 4)).animate(curve)
          ..addListener(() {
            setState(() {});
          });
    animation2 = Tween(begin: 0.0, end: (80.0 * 2)).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    alphaAnimation = Tween(begin: 0.70, end: 0.0).animate(_rippleController);
    _rippleController.addStatusListener((_) async {
      if (_rippleController.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 50));
        _rippleController.reset();
        _rippleController.forward();
      }
    });
    _rippleController.forward();

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.16, 0.32, curve: Curves.fastOutSlowIn),
    ));
    _animation2 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.32, 0.48, curve: Curves.fastOutSlowIn),
    ));
    _animation3 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.48, 0.64, curve: Curves.fastOutSlowIn),
    ));
    _animation4 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.64, 0.80, curve: Curves.fastOutSlowIn),
    ));
    _animation5 = Tween<Offset>(
      begin: Offset(1.2, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.64, 0.80, curve: Curves.fastOutSlowIn),
    ));

    _animation6 = Tween<Offset>(
      begin: Offset(-4, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.fastOutSlowIn),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _rippleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: SlideTransition(
        position: _animation6,
        transformHitTests: true,
        textDirection: TextDirection.ltr,
        child: Container(
          margin: EdgeInsets.all(0),
          height: 50.0 * 2,
          width: 50.0 * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: animation2.value,
                width: animation2.value,
                child: SizedBox(),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
              ),
              Container(
                height: animation.value,
                width: animation.value,
                child: SizedBox(),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
              ),
              SizedBox(
                height: 9.5.h,
                width: 9.5.h,
                child: FloatingActionButton(
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => EditProfile());
                      Navigator.push(context, route);
                    },
                    child: Icon(CupertinoIcons.pencil_outline,
                        color: Colors.white, size: 16.sp),
                    backgroundColor: Color(0xFF025373)),
              ),
            ],
          ),
        ),
      ),
      body: Container(
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
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 7.h,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.only(right: 5.h),
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 10.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: ThinkCardApp.sharedPreferences
                              .getString(ThinkCardApp.userAvatarUrl),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 23.h,
                            height: 23.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 6),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => SpinKitDoubleBounce(
                              color: Colors.white, size: 15.h),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 7.h,
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                padding: EdgeInsets.only(left: 5.h),
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: 10.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 4.h,
                    width: screenWidth,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                                size: 4.5.h,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Full Name",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ThinkCardApp.sharedPreferences
                                      .getString(ThinkCardApp.fullName),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.signature,
                                color: Colors.white,
                                size: 4.5.h,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Username",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ThinkCardApp.sharedPreferences
                                      .getString(ThinkCardApp.userName),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.at_badge_plus,
                                color: Colors.white,
                                size: 4.5.h,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ThinkCardApp.sharedPreferences
                                      .getString(ThinkCardApp.userEmail),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Divider(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.h),
                              decoration: BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.device_phone_portrait,
                                color: Colors.white,
                                size: 4.5.h,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  ThinkCardApp.sharedPreferences
                                      .getString(ThinkCardApp.phoneNumber),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontFamily: "Muli",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
