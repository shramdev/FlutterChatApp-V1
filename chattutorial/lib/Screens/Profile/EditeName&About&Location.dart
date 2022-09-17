import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Constant/constant.dart';
import '../../Models/usermodel.dart';
import '../../Services/DatabaseServices.dart';
import '../../Widgets/widget.dart';

class EditeName extends StatefulWidget {
  final user;
  final String visitedUserId;
  final String currentUserId;
  const EditeName(
      {required Key key,
      required this.user,
      required this.visitedUserId,
      required this.currentUserId})
      : super(key: key);
  @override
  _EditeNameState createState() => _EditeNameState();
}

class _EditeNameState extends State<EditeName> {
  late String _name;
  late String _bio;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  get joinedAt => null;

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      UserModel user = UserModel(
          coverPicture: widget.user.coverPicture,
          id: widget.user.id,
          admin: widget.user.admin,
          name: _name,
          profilePicture: profilePictureUrl,
          bio: _bio,
          email: '',
          verification: widget.user.verification,
          gender: '',
          joinedAt: joinedAt,
          isAnonymous: widget.user.isAnonymous,
          isVerified: widget.user.isVerified);

      DatabaseServices.updateUserDisplayName(user);
      var key;

      showsuccsesSnackbar();
      Navigator.pop(context);
    }
  }

  showsuccsesSnackbar() {
    return showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: Icon(
          CupertinoIcons.person_circle_fill,
          color: Colors.white,
        ),
        iconPositionLeft: 8,
        message: "Your display name successfully has been update",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Display Name',
          style: GoogleFonts.oswald(fontSize: 20, color: Colors.black),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Change Your Display Name',
                  style: GoogleFonts.oswald(color: Colors.black, fontSize: 20),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          maxLength: 12,
                          initialValue: _name,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          validator: (input) => input!.trim().length < 2
                              ? 'please enter valid name'
                              : null,
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              splashColor: Color.fromARGB(0, 255, 214, 64),
                              // highlightedBorderColor: appBarcolor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCEL",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                  )),
                            ),
                            RaisedButton(
                              splashColor: Color.fromARGB(0, 255, 214, 64),
                              onPressed: () {
                                saveProfile();
                              },
                              color: textBlueColor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        _isLoading
                            ? CircleProgressIndicator()
                            : SizedBox.shrink()
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// Edite About

class EditeAbout extends StatefulWidget {
  final user;
  final String visitedUserId;
  final String currentUserId;
  const EditeAbout(
      {required Key key,
      required this.user,
      required this.visitedUserId,
      required this.currentUserId})
      : super(key: key);
  @override
  _EditeAboutState createState() => _EditeAboutState();
}

class _EditeAboutState extends State<EditeAbout> {
  late String _name;
  late String _bio;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  get joinedAt => null;

  saveProfile() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      UserModel user = UserModel(
          coverPicture: widget.user.coverPicture,
          admin: widget.user.admin,
          id: widget.user.id,
          name: _name,
          profilePicture: profilePictureUrl,
          bio: _bio,
          email: '',
          verification: widget.user.verification,
          gender: '',
          joinedAt: joinedAt,
          isAnonymous: widget.user.isAnonymous,
          isVerified: widget.user.isVerified);

      DatabaseServices.updateAboutUser(user);
      var key;

      showsuccsesSnackbar();
      Navigator.pop(context);
    }
  }

  showsuccsesSnackbar() {
    return showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: Icon(
          FlutterIcons.check_all_mco,
          color: Colors.white,
        ),
        iconPositionLeft: 8,
        message: "Your bio successfully has been update",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bio = widget.user.bio;
    _name = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'About',
            style: GoogleFonts.oswald(fontSize: 20, color: Colors.black),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black))),
      body: FutureBuilder(
          future: usersRef.doc(auth.currentUser!.uid).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircleProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Have Something Error!',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      userModel.bio.isEmpty
                          ? Text(
                              'Write Something\n   about your company.',
                              style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              'Change About',
                              style: GoogleFonts.oswald(
                                  color: Colors.black, fontSize: 20),
                            ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              TextFormField(
                                maxLength: 500,
                                maxLines: 3,
                                initialValue: _bio,
                                decoration: InputDecoration(
                                  labelText: 'About',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onSaved: (value) {
                                  _bio = value!;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                    splashColor:
                                        Color.fromARGB(0, 255, 214, 64),
                                    // highlightedBorderColor: appBarcolor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("CANCEL",
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                        )),
                                  ),
                                  RaisedButton(
                                    splashColor:
                                        Color.fromARGB(0, 255, 214, 64),
                                    onPressed: () {
                                      saveProfile();
                                    },
                                    color: textBlueColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2.2,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                              _isLoading
                                  ? CircleProgressIndicator()
                                  : SizedBox.shrink()
                            ],
                          )),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  void inputData() async {
    final user = await auth.currentUser!;
    final userid = user.uid;
  }
}
