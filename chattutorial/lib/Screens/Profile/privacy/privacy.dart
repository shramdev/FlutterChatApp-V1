import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/SignUP&SignIn/EmailVerifiy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class PrivacyScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;

  const PrivacyScreen(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.userModel})
      : super(key: key);
  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Privacy', style: GoogleFonts.lato(color: Colors.black)),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: VerifiyScreen()));
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  FlutterIcons.email_box_mco,
                  color: Colors.black,
                ),
                title: Text(
                  'Email: ${widget.userModel.email}',
                  style: GoogleFonts.lato(color: Colors.black, fontSize: 14),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Card(
              child: ListTile(
                leading: Icon(
                  FlutterIcons.lock1_ant,
                  color: Colors.black,
                ),
                title: Text(
                  'Password',
                  style: GoogleFonts.lato(color: Colors.black, fontSize: 14),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: AnonymousStatus(
                        currentUserId: widget.currentUserId,
                        userModel: widget.userModel,
                        visitedUserId: widget.visitedUserId,
                      )));
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  FontAwesome5.question_circle,
                  color: Colors.black,
                ),
                title: Text(
                  'Anonymous status',
                  style: GoogleFonts.lato(color: Colors.black, fontSize: 14),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                subtitle: Text(
                  widget.userModel.isAnonymous ? "On" : "Off",
                  style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 100, 100, 100), fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnonymousStatus extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;

  const AnonymousStatus(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.userModel})
      : super(key: key);

  @override
  State<AnonymousStatus> createState() => _AnonymousStatusState();
}

class _AnonymousStatusState extends State<AnonymousStatus> {
  bool _value = false;

  setupIsChanging() async {
    bool ischangingStatus = await widget.userModel.isAnonymous;
    setState(() {
      _value = ischangingStatus;
    });
  }

  Future changeStatus() async {
    if (widget.userModel.isAnonymous == false) {
      await usersRef
          .doc(widget.currentUserId)
          .update({'isAnonymousUser': true}).whenComplete(
              () => AnimatedSnackBar.material(
                    'Anonymous status successfully trun on',
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                    desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
                  ).show(context));
    } else if (widget.userModel.isAnonymous == true) {
      await usersRef
          .doc(widget.currentUserId)
          .update({'isAnonymousUser': false}).whenComplete(
              () => AnimatedSnackBar.material(
                    'Anonymous status successfully trun off',
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                    desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
                  ).show(context));
    }
  }

  @override
  void initState() {
    super.initState();
    setupIsChanging();
    widget.userModel.isAnonymous = widget.userModel.isAnonymous;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Anonymous status',
              style: GoogleFonts.lato(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Anonymous status',
                    style: GoogleFonts.lato(),
                  ),
                  trailing: Switch.adaptive(
                      value: _value,
                      onChanged: ((value) {
                        setState(() {
                          _value = value;
                          changeStatus();
                        });
                      })),
                ),
              )
            ],
          ),
        ));
  }
}
