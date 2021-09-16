import "package:flutter/material.dart";

class Welcome extends StatefulWidget {
  Welcome({Key key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 35),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      "assets/images/rain.png",
                      height: 300,
                    ),
                  ),
                  Text(
                    "Welcome to 02 Loans",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Muli",
                      color: Color(0xFF05242C),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Enjoy sweet and low interest rate loan on 02 Loans. Do not stress yourself again searching for urgent 2k",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Muli",
                      color: Color(0xFF05242C),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
            width: double.infinity,
            child: FlatButton(
              child: Text(
                "Register",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {},
              color: Color(0xFF1AB6DC),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
            width: double.infinity,
            child: new InkWell(
              onTap: () => print('hello'),
              child: new Container(
                //width: 100.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(color: Color(0xFF1AB6DC), width: 2.0),
                  borderRadius: new BorderRadius.circular(3.0),
                ),
                child: new Center(
                  child: new Text(
                    'Sign in',
                    style:
                        new TextStyle(color: Color(0xFF1AB6DC), fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
