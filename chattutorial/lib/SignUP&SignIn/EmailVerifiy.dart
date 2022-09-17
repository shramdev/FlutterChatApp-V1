import 'dart:async';

import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/ActivityModel.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifiyScreen extends StatefulWidget {
  @override
  State<VerifiyScreen> createState() => _VerifiyScreenState();
}

class _VerifiyScreenState extends State<VerifiyScreen> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;
  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      chekEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Future<void> chekEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      print(user!.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Verifiy Email',
          style: GoogleFonts.lato(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Center(
          child: Card(
            color: Color.fromARGB(255, 248, 248, 248),
            child: Container(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please Chek Your Email',
                    style: GoogleFonts.oswald(fontSize: 20),
                  ),
                  Text(
                    '${user!.email}',
                    style: GoogleFonts.oswald(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 8, left: 6, bottom: 8, right: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                          top: BorderSide(color: Colors.white),
                          left: BorderSide(color: Colors.white),
                          right: BorderSide(color: Colors.white),
                        )),
                    child: MaterialButton(
                      color: buttonscolor,
                      minWidth: double.infinity,
                      height: 55,
                      onPressed: () async {
                        await chekEmailVerified();
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Text(
                        "Resend Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
