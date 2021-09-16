import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:think/Onboarding/onboarding_content.dart';
import 'package:think/auth/login.dart';
import 'package:think/config/colors.dart';
import 'package:sizer/sizer.dart';

class Onbording extends StatefulWidget {
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> with TickerProviderStateMixin {
  int currentIndex = 0;
  PageController _controller;

  AnimationController _onboardingController, _onboardingRippleController;

  Animation<Offset> _animation, _animation2, _animation3, _animation4;
  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> alphaAnimation;

  @override
  void initState() {
    _onboardingRippleController = AnimationController(
        duration: Duration(milliseconds: 3500), vsync: this);
    final Animation curve = CurvedAnimation(
        parent: _onboardingRippleController, curve: Curves.decelerate);
    animation =
        Tween(begin: (14.h * 2) / 6, end: (14.h * 2) * (3 / 4)).animate(curve)
          ..addListener(() {
            setState(() {});
          });
    animation2 = Tween(begin: 0.0, end: (14.h * 2)).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    alphaAnimation =
        Tween(begin: 0.70, end: 0.0).animate(_onboardingRippleController);
    _onboardingRippleController.addStatusListener((_) async {
      if (_onboardingRippleController.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 5));
        _onboardingRippleController.reset();
        _onboardingRippleController.forward();
      }
    });
    _onboardingRippleController.forward();

    _controller = PageController(initialPage: 0);
    super.initState();

    _onboardingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(0, -5.0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _onboardingController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _onboardingController.dispose();
    _onboardingRippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  _onboardingController.reset();
                  _onboardingController.forward();
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(4.w, 3.w, 4.w, 4.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: SlideTransition(
                          position: _animation,
                          transformHitTests: true,
                          textDirection: TextDirection.ltr,
                          child: Image.asset(
                            contents[i].image,
                            height: 40.h,
                          ),
                        ),
                      ),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Muli",
                          color: Color(0xFF05242C),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "Muli",
                          color: Color(0xFF05242C),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.all(0),
            height: 12.h * 2,
            width: 12.h * 2,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: animation2.value,
                  width: animation2.value,
                  child: SizedBox(),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xFF025373).withOpacity(alphaAnimation.value)),
                ),
                Container(
                  height: animation.value,
                  width: animation.value,
                  child: SizedBox(),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xFF025373).withOpacity(alphaAnimation.value)),
                ),
                Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                        color: Color(0xFF025373), shape: BoxShape.circle),
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.arrowshape_turn_up_right,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          if (currentIndex == contents.length - 1) {
                            Route route =
                                MaterialPageRoute(builder: (c) => Login());
                            Navigator.pushReplacement(context, route);
                          }
                          _controller.nextPage(
                            duration: Duration(milliseconds: 100),
                            curve: Curves.bounceIn,
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 1.h,
      width: currentIndex == index ? 4.w : 2.w,
      margin: EdgeInsets.only(right: 1.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.w),
        color: Color(0xFF025373),
      ),
    );
  }
}
