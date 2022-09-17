import 'dart:async';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Home/Chats/GlobalChatWidget.dart';
import 'package:chattutorial/Screens/Profile/profile.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class GlobalChats extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;

  const GlobalChats(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.userModel})
      : super(key: key);

  @override
  State<GlobalChats> createState() => _GlobalChatsState();
}

class _GlobalChatsState extends State<GlobalChats> {
  final messageController = TextEditingController();
  int _chatsCount = 0;
  int _usersCont = 0;

  Future sendMessage() async {
    var messageId = const Uuid().v4();

    await publicChatsRef
        .doc('GlobalChats')
        .collection('UserChats')
        .doc(messageId)
        .set({
      'messageText': messageController.text,
      'SenderId': widget.currentUserId,
      'TimeStamp': Timestamp.now(),
    });
    setState(() {
      messageController.clear();
      messageId = messageId;
    });
  }

  Future getchatsCount() async {
    await Future.delayed(Duration(seconds: 3));
    int chatsCount =
        await DatabaseServices.chatsCountNumber(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _chatsCount = chatsCount;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getchatsCount();
    AnimatedSnackBar.material(
      'Delete messages every 24 hours',
      type: AnimatedSnackBarType.warning,
      mobileSnackBarPosition:
          MobileSnackBarPosition.top, // Position of snackbar on mobile devices
      desktopSnackBarPosition: DesktopSnackBarPosition
          .topRight, // Position of snackbar on desktop devices
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 3), (Timer t) => getchatsCount());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          "Messages: ${_chatsCount.toString()}",
          style: GoogleFonts.lato(color: Colors.black, fontSize: 14),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.userModel.isAnonymous
                  ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/anonlogo.png',
                              ),
                              fit: BoxFit.cover)),
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.userModel.profilePicture,
                              ),
                              fit: BoxFit.cover)),
                    ))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            child: Expanded(
              child: StreamBuilder(
                stream: publicChatsRef
                    .doc('GlobalChats')
                    .collection('UserChats')
                    .orderBy('TimeStamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          bool isMy = snapshot.data.docs[index]['SenderId'] ==
                              widget.currentUserId;
                          return BuildGlobalChats(
                            userModel: widget.userModel,
                            visitedUserId: snapshot.data.docs[index]
                                ['SenderId'],
                            currentUserId: widget.currentUserId,
                            isMy: isMy,
                            timestamp: snapshot.data.docs[index]['TimeStamp'],
                            message: snapshot.data.docs[index]['messageText'],
                          );
                        });
                  }

                  return Center(
                    child: CircleProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 175, 175, 175).withOpacity(.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Color.fromARGB(255, 40, 33, 33),
                ),
                controller: messageController,
                onSubmitted: (value) => sendMessage(),
                cursorColor: Color.fromARGB(255, 40, 33, 33),
                decoration: new InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.folder,
                          color: Color.fromARGB(255, 40, 33, 33),
                        )),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Type a message...",
                    hintStyle: GoogleFonts.lato(
                      letterSpacing: 0.5,
                      color: Color.fromARGB(255, 40, 33, 33),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
