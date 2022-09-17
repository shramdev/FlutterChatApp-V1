import 'dart:math';

import 'package:chattutorial/Constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  bool _isError = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isError = _isError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Forget Password",
            style: GoogleFonts.lato(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 5.0, right: 5, top: 10, bottom: 10),
            child: Text(
              'We send a reset password link to your gmail, please check your email',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                    child: TextFormField(
                      style: GoogleFonts.lato(),
                      controller: _emailController,
                      validator: (input) => input!.trim().length < 2
                          ? 'please enter valid email'
                          : null,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: GoogleFonts.lato(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 170,
            padding: EdgeInsets.only(top: 10, left: 3, bottom: 4, right: 3),
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
              height: 50,
              onPressed: () async {
                try {
                  _isError = false;
                  await auth.sendPasswordResetEmail(
                      email: _emailController.text.trim());
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ok'))
                          ],
                          content: Text('We send a reset password link.'),
                        );
                      });
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    _isError = true;
                  });
                  print(e);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancle'))
                          ],
                          content: Text(
                            e.message.toString(),
                            style: TextStyle(
                                color: _isError ? Colors.red : Colors.black),
                          ),
                        );
                      });
                }
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              child: Text(
                "Send email",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
          _isError
              ? Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 5),
                  child: Row(
                    children: [
                      Text(
                        'Sorry you have some problems!\nFeedback T-chat for sloving your problems',
                        style: TextStyle(
                            color: _isError ? Colors.red : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
