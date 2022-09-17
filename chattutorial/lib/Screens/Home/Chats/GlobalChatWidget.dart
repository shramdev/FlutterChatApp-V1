import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Profile/profile.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class BuildGlobalChats extends StatefulWidget {
  final bool isMy;
  final String currentUserId;
  final Timestamp timestamp;
  final String message;
  final String visitedUserId;
  final UserModel userModel;
  const BuildGlobalChats({
    Key? key,
    required this.isMy,
    required this.currentUserId,
    required this.timestamp,
    required this.message,
    required this.visitedUserId,
    required this.userModel,
  }) : super(key: key);
  @override
  State<BuildGlobalChats> createState() => _BuildGlobalChatsState();
}

class _BuildGlobalChatsState extends State<BuildGlobalChats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(DateFormat.Hm().format(widget.timestamp.toDate()),
              style: GoogleFonts.lato(fontSize: 12, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Row(
              mainAxisAlignment:
                  widget.isMy ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 247, 247),
                    borderRadius: BorderRadius.only(
                      topLeft: widget.isMy
                          ? Radius.circular(10)
                          : Radius.circular(10),
                      topRight: widget.isMy
                          ? Radius.circular(10)
                          : Radius.circular(10),
                      bottomRight: widget.isMy
                          ? Radius.circular(0)
                          : Radius.circular(10),
                      bottomLeft: widget.isMy
                          ? Radius.circular(10)
                          : Radius.circular(0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
