import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Services/Auth.dart';
import 'package:chattutorial/SignUP&SignIn/SignIn.dart';
import 'package:chattutorial/SignUP&SignIn/SignUp.dart';

import 'package:chattutorial/Widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  bool _isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isError = _isError;
    _isLoading = _isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Center(
            //   child: Container(
            //     height: MediaQuery.of(context).size.height / 3,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage("assets/images/ic_launcher.png"))),
            //   ),
            // ),

            Column(
              children: <Widget>[
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  color: buttonscolor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text("SignIn",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white)),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  color: buttonscolor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text("Sign up",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white)),
                )
              ],
            ),

            Text("Created by Shram.Dev",
                style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 0.1))
          ],
        ),
      ),
    );
  }
}
