import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:think/admin/addCards.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/notifications.dart';
import 'package:think/settings.dart';
import 'package:sizer/sizer.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar(
    this.title, {
    Key key,
  }) : super(key: key);
  final String title;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(SizerUtil.deviceType == DeviceType.mobile ? 9.h : 6.8.h);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
          SizerUtil.deviceType == DeviceType.mobile ? 9.h : 6.8.h),
      child: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: "Muli",
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        leading: Builder(
          builder: (context) => SizerUtil.deviceType == DeviceType.mobile
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.square_grid_2x2,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              : Container(
                  margin: EdgeInsets.all(1.w),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.square_grid_2x2,
                      color: Colors.black,
                      size: 12.sp,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
        ),
        actions: [
          SizerUtil.deviceType == DeviceType.mobile
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.gear_alt,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => Settings());
                    Navigator.push(context, route);
                  },
                )
              : Container(
                  margin: EdgeInsets.all(1.w),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.gear_alt,
                      color: Colors.black,
                      size: 12.sp,
                    ),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => Settings());
                      Navigator.push(context, route);
                    },
                  )),
          _shoppingCartBadge(),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFF0F2F2F2),
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        centerTitle: true,
      ),
    );
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
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ); //CIRCULAR INDICATOR
          else {
            return Text(
              snapshot.data["unViewed"].toString(),
              style: TextStyle(
                  fontSize:
                      SizerUtil.deviceType == DeviceType.mobile ? 8.sp : 6.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            );
          }
        },
      ),
      child: SizerUtil.deviceType == DeviceType.mobile
          ? IconButton(
              icon: Icon(
                CupertinoIcons.bell,
                color: Colors.black,
                size: 20.sp,
              ),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => NotificationPage());
                Navigator.push(context, route);
              })
          : Container(
              margin: EdgeInsets.all(1.w),
              child: IconButton(
                  icon: Icon(
                    CupertinoIcons.bell,
                    color: Colors.black,
                    size: 12.sp,
                  ),
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => NotificationPage());
                    Navigator.push(context, route);
                  })),
    );
  }
}
