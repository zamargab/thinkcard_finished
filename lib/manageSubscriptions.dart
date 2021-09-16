import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paystack_manager/paystack_pay_manager.dart';

import 'package:sizer/sizer.dart';
import 'package:think/config/thinkcard.dart';
import 'package:think/deposit.dart';
import 'package:think/deposit2.dart';
import 'package:think/home.dart';
import 'package:think/manageSubscriptionsTwo.dart';
import 'package:think/widgets/Myappbar.dart';
import 'package:think/widgets/drawer.dart';
import 'package:paystack_manager/models/transaction.dart';

class ManageSubscriptions extends StatefulWidget {
  ManageSubscriptions({Key key}) : super(key: key);

  @override
  _ManageSubscriptionsState createState() => _ManageSubscriptionsState();
}

class _ManageSubscriptionsState extends State<ManageSubscriptions> {
  int payAmount;
  String duration;
  int days;
  String dueDate;

  @override
  void initState() {
    getDueDate();
    // TODO: implement initState
    super.initState();
  }

  getDueDate() async {
    var document = await ThinkCardApp.firestore
        .collection('users')
        .document(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
        .get();
    dueDate = ThinkCardApp.timeFormat2.format(document["SubDueDate"].toDate());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                    InkWell(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => Home(false));
                        Navigator.push(context, route);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.w, 5.w, 3.w, 1.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(CupertinoIcons.house_fill,
                              color: Colors.white, size: 15.sp),
                        ),
                      ),
                    ),
                    Text(
                      "Get started today",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: "Muli",
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Go through our cheap plans below",
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
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.Sub) ==
                      "Paid"
                  ? Container(
                      child: paidBox(),
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 1.h),
                      color: Color(0xFFf6fafb),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _processPayment(100000, "Monthly");
                                  payAmount = 1000;
                                  duration = "Monthly";
                                  days = 30;
                                },
                                child: pricingBox("Monthly", "1000"),
                              ),
                              SizedBox(width: 1.h),
                              InkWell(
                                  onTap: () {
                                    _processPayment(270000, "Trimonthly");
                                    payAmount = 2700;
                                    duration = "Trimonthly";
                                    days = 90;
                                  },
                                  child: pricingBox("Trimonthly", "2700"))
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    _processPayment(540000, "Half Year");
                                    payAmount = 5400;
                                    duration = "Half Year";
                                    days = 180;
                                  },
                                  child: pricingBox("Half Year", "5400")),
                              SizedBox(width: 1.h),
                              InkWell(
                                  onTap: () {
                                    _processPayment(1080000, "Full Year");
                                    payAmount = 10800;
                                    duration = "Full Year";
                                    days = 360;
                                  },
                                  child: pricingBox("Full Year", "10800"))
                            ],
                          ),
                        ],
                      ),
                    )
            ],
          )),
        ),
      ),
    ));
  }

  Widget pricingBox(String title, String price) {
    return Container(
      padding: EdgeInsets.fromLTRB(1.3.h, 3.h, 1.3.h, 1.h),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 10.sp,
                fontFamily: "Muli",
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                "₦",
                style: TextStyle(color: Color(0xFF808080), fontSize: 10.sp),
              ),
              Text(
                price,
                style: TextStyle(
                    fontFamily: "Muli", color: Colors.black, fontSize: 20.sp),
              ),
              Text(
                "/Monthly",
                style: TextStyle(
                    fontFamily: "Muli",
                    color: Color(0xFF808080),
                    fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: 40.w,
            child: Row(
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle,
                    color: Color(0xFF025373), size: 12.sp),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "Unlimited number of cards",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Muli",
                        color: Color(0xFF808080),
                        fontSize: 9.sp),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 40.w,
            child: Row(
              children: [
                Icon(CupertinoIcons.checkmark_alt_circle,
                    color: Color(0xFF025373), size: 12.sp),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "Unlimited number of Game Rooms",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Muli",
                        color: Color(0xFF808080),
                        fontSize: 9.sp),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/images/leaf.png",
              height: 10.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget paidBox() {
    return Padding(
      padding: EdgeInsets.all(5.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.h, 3.h, 5.h, 1.h),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          border: Border.all(color: Colors.green),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Route route =
                    MaterialPageRoute(builder: (c) => ManageSubscriptionsTwo());
                Navigator.push(context, route);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration:
                    BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child:
                    Icon(CupertinoIcons.plus, color: Colors.white, size: 20.sp),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Subscription Status:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Muli", color: Colors.black, fontSize: 10.sp),
                ),
                Text(
                  " Active",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Muli", color: Colors.black, fontSize: 10.sp),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Subscription Due Date: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Muli", color: Colors.black, fontSize: 10.sp),
                ),
                Text(
                  dueDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Muli", color: Colors.black, fontSize: 10.sp),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              "You can add to your subscription by tapping the button above",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    SizerUtil.deviceType == DeviceType.mobile ? 10.sp : 8.sp,
                fontFamily: "Muli",
                fontWeight: FontWeight.w400,
                color: Color(0xFF808080),
              ),
            ),
            SizedBox(height: 8.h),
            Image.asset(
              "assets/images/leaf.png",
              height: 10.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(int amount, String duration) {
    try {
      PaystackPayManager(context: context)
        // Don't store your secret key on users device.
        // Make sure this is retrive from your server at run time
        ..setSecretKey("sk_test_273c814d7c96c32e4310fbd722f00e7d3fa620f7")
        //accepts widget
        ..setCompanyAssetImage(Image(
          image: AssetImage("assets/images/card.png"),
        ))
        ..setAmount(amount)
        // ..setReference("your-unique-transaction-reference")
        ..setReference(DateTime.now().millisecondsSinceEpoch.toString())
        ..setCurrency("NGN")
        ..setEmail(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userEmail))
        ..setFirstName(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userName))
        ..setLastName("")
        ..setMetadata(
          {
            "custom_fields": [
              {
                "value": "snapTask",
                "display_name": "Payment to",
                "variable_name": "payment_to"
              }
            ]
          },
        )
        ..onSuccesful(_onPaymentSuccessful)
        ..onPending(_onPaymentPending)
        ..onFailed(_onPaymentFailed)
        ..onCancel(_onPaymentCancelled)
        ..initialize();
    } catch (error) {
      print("Payment Error ==> $error");
    }
  }

  void _onPaymentSuccessful(Transaction transaction) {
    print("Transaction was successful");
    print("Transaction Message ===> ${transaction.message}");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
    ThinkCardApp.firestore
        .collection("users")
        .document(
            ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
        .collection("transactions")
        .document()
        .setData({
      "Amount": payAmount,
      "duration": duration,
      "paymentDate": DateTime.now(),
      "SubDueDate":
          DateTime.now().add(Duration(days: days, hours: 0, minutes: 0)),
    }).then((value) async {
      var document = await ThinkCardApp.firestore
          .collection('users')
          .document(
              ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
          .get();

//subscriped users
      if (document["Sub"] == "Paid") {
        int newSubDays = document["SubDays"] + days;
        ThinkCardApp.firestore
            .collection("users")
            .document(
                ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
            .updateData({
          "Sub": "Paid",
          "SubDays": newSubDays,
          "SubDueDate": document["subPaymentDate"]
              .toDate()
              .add(Duration(days: newSubDays, hours: 0, minutes: 2)),
        });
        await ThinkCardApp.sharedPreferences
            .setString(ThinkCardApp.Sub, "Paid");
      } else {
        //unsubed users
        ThinkCardApp.firestore
            .collection("users")
            .document(
                ThinkCardApp.sharedPreferences.getString(ThinkCardApp.userUID))
            .updateData({
          "Sub": "Paid",
          "SubDays": days,
          "subPaymentDate": DateTime.now(),
          "SubDueDate":
              DateTime.now().add(Duration(days: days, hours: 0, minutes: 2)),
        });
        await ThinkCardApp.sharedPreferences
            .setString(ThinkCardApp.Sub, "Paid");
      }

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
                'Payment Successful',
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
          Route route =
              MaterialPageRoute(builder: (c) => ManageSubscriptions());
          Navigator.pushReplacement(context, route);
        },
        btnOkIcon: Icons.check_circle,
      )..show();
    });
  }

  void _onPaymentPending(Transaction transaction) {
    print("Transaction is pendinng");
    print("Transaction Refrence ===> ${transaction.refrenceNumber}");
  }

  void _onPaymentFailed(Transaction transaction) {
    print("Transaction failed");
    print("Transaction Message ===> ${transaction.message}");
  }

  void _onPaymentCancelled(Transaction transaction) {
    print("Transaction was cancelled");
  }
}
