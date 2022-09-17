import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/SignUP&SignIn/EmailVerifiy.dart';
import 'package:chattutorial/SignUP&SignIn/SignIn.dart';

import 'package:chattutorial/Widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../Services/Auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _email;
  String? _name;
  late String _password;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _gender;
  bool _isError = false;

  List<String> listOfValue = [
    'Male',
    'Famale',
    'Brand',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isError = _isError;
    _isLoading = _isLoading;
    // requestLocationPermission();
    // input seconds into parameter for getting location with repeating by timer.
    // this example set to 5 seconds.
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: MediaQuery.of(context).size.height - 10,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                          ))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: _isError ? Colors.red : textBlueColor),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8),
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height / 7,
                      //     decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //             image: AssetImage(
                      //                 "assets/images/ic_launcher.png"))),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2),
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.lato(
                                      color: textBlueColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(),
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                    validator: (input) => input!.trim().isEmpty
                                        ? 'please enter valid email'
                                        : null,
                                    obscureText: false,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the email',
                                      hintStyle: GoogleFonts.lato(fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.lato(
                                      color: textBlueColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(),
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                    validator: (input) =>
                                        input!.trim().length < 8
                                            ? 'please enter valid password'
                                            : null,
                                    obscureText: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the Password',
                                      hintStyle: GoogleFonts.lato(fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 2),
                                child: Text(
                                  'DisplayName',
                                  style: GoogleFonts.lato(
                                      color: textBlueColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 5),
                                  child: TextFormField(
                                    style: GoogleFonts.lato(),
                                    onChanged: (value) {
                                      _name = value;
                                    },
                                    validator: (input) =>
                                        input!.trim().length < 2
                                            ? 'please enter valid Name'
                                            : null,
                                    obscureText: false,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the DisplayName',
                                      hintStyle: GoogleFonts.lato(fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 180,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8)),
                                  isExpanded: true,
                                  value: _gender,
                                  hint: Text(
                                    'Gender',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value;
                                    });
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _gender = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "can't empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  items: listOfValue.map((String val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _isError
                      ? Text(
                          'Please Enter The Correct Email And Password',
                          style:
                              GoogleFonts.lato(color: Colors.red, fontSize: 14),
                        )
                      : SizedBox(),
                  _isLoading
                      ? CircleProgressIndicator()
                      : Container(
                          padding: EdgeInsets.only(
                              top: 4, left: 3, bottom: 4, right: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              border: Border(
                                bottom: BorderSide(color: Colors.white),
                                top: BorderSide(color: Colors.white),
                                left: BorderSide(color: Colors.white),
                                right: BorderSide(color: Colors.white),
                              )),
                          child: MaterialButton(
                            color: _isError ? errorColor : buttonscolor,
                            minWidth: double.infinity,
                            height: 50,
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate() &&
                                    _gender != null) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool isValid = await AuthService.signUp(
                                      _name!,
                                      _email,
                                      _password,
                                      _gender!,
                                      false);
                                  if (isValid) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerifiyScreen()));
                                  } else {
                                    setState(() {
                                      _isError = true;
                                    });
                                    _isLoading = false;
                                  }
                                }
                                if (_gender!.isEmpty) {
                                  Fluttertoast.showToast(
                                      backgroundColor: Colors.grey.shade600,
                                      msg: 'Gender is empty!');
                                  setState(() {
                                    _isLoading = false;
                                    _isError = true;
                                  });
                                }
                              } catch (e) {
                                print('This Error$e');
                              }
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("I have an account"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: Text(
                          " SignIn",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
