import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Home/Chats/ViewImageChat.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:uuid/uuid.dart';

class ChatWidget extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final String textMessage;
  final String image;
  final Timestamp timestamp;
  final bool isSendByMy;
  final String recevierId;
  final String senderId;
  final bool isSending;
  final String profilePicture;
  final String name;
  final bool loading;
  final String chatid;
  final bool isDarkMode;
   ChatWidget(
      {Key? key,
      required this.textMessage,
      required this.loading,
      required this.image,
      required this.timestamp,
      required this.isSendByMy,
      required this.recevierId,
      required this.senderId,
      required this.isSending,
      required this.profilePicture,
      required this.name,
      required this.currentUserId,
      required this.visitedUserId,
      required this.chatid,
      required this.isDarkMode,
      })
      : super(key: key);
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  Future deleteMessage() async {
// CurrentUser
    await chatsRef
        .doc(widget.currentUserId)
        .collection('Chat with')
        .doc(widget.visitedUserId)
        .collection('Messages')
        .doc(widget.chatid)
        .delete();
    // VisitedUser

    await chatsRef
        .doc(widget.visitedUserId)
        .collection('Chat with')
        .doc(widget.currentUserId)
        .collection('Messages')
        .doc(widget.chatid)
        .delete();
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: Column(
              children: [
                Text(DateFormat.Hm().format(widget.timestamp.toDate()),
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: widget.isSendByMy
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    
                      Container(
                        child: GestureDetector(
                          onLongPress: () {
                            showMessageBottom();
                          },
                          child: widget.textMessage.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewImage(
                                                image: widget.image,
                                                isloading: widget.loading,
                                                timeago: widget.timestamp,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: profileBGcolor,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: NetworkImage(widget.image),
                                            fit: BoxFit.cover)),
                                    width: 200,
                                    height: 250,
                                  ),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.80,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: widget.isDarkMode
                                        ? Color.fromARGB(255, 66, 66, 66)
                                        : Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.only(
                                      topLeft: widget.isSendByMy
                                          ? Radius.circular(10)
                                          : Radius.circular(10),
                                      topRight: widget.isSendByMy
                                          ? Radius.circular(10)
                                          : Radius.circular(10),
                                      bottomRight: widget.isSendByMy
                                          ? Radius.circular(0)
                                          : Radius.circular(10),
                                      bottomLeft: widget.isSendByMy
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
                                    widget.textMessage,
                                    style: TextStyle(
                                      color: widget.isDarkMode
                                          ? Color.fromARGB(255, 241, 241, 241)
                                          : Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
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

  showMessageBottom() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: widget.isDarkMode
                ? Color.fromARGB(255, 61, 61, 61)
                : Colors.white,
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(AntDesign.close,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Color.fromARGB(255, 61, 61, 61))),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.isSendByMy ? 'Me' : widget.name,
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Color.fromARGB(255, 61, 61, 61))),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: Text(
                            DateFormat.yMMMMEEEEd()
                                .format(widget.timestamp.toDate()),
                            style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Color.fromARGB(255, 61, 61, 61))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 5),
                  child: Column(
                    children: [
                      ReadMoreText(widget.textMessage,
                          style: GoogleFonts.lato(
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Color.fromARGB(255, 61, 61, 61)),
                          trimLines: 3,
                          colorClickableText: Color.fromARGB(255, 202, 17, 17),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 33, 67, 218),
                          )),
                    ],
                  ),
                ),
                widget.isSendByMy
                    ? ListTile(
                        onTap: () {
                          deleteMessage();
                        },
                        leading: Icon(
                          CupertinoIcons.trash,
                          color: widget.isDarkMode
                              ? Colors.white
                              : Color.fromARGB(255, 61, 61, 61),
                        ),
                        title: Text('Delete',
                            style: GoogleFonts.abel(
                              letterSpacing: 1,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Color.fromARGB(255, 61, 61, 61),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            )),
                      )
                    : ListTile(
                        onTap: () {
                          FlutterClipboard.copy(widget.textMessage)
                              .then((value) {
                            setState(() {
                              Fluttertoast.showToast(
                                  msg: 'Copied',
                                  backgroundColor:
                                      Color.fromARGB(255, 135, 135, 135));
                              Navigator.pop(context);
                            });
                          });
                        },
                        leading: Icon(
                          CupertinoIcons.doc_on_clipboard,
                          color: widget.isDarkMode
                              ? Colors.white
                              : Color.fromARGB(255, 61, 61, 61),
                        ),
                        title: Text('Copy',
                            style: GoogleFonts.abel(
                              letterSpacing: 1,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Color.fromARGB(255, 61, 61, 61),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            )),
                      ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    CupertinoIcons.eye_slash,
                    color: widget.isDarkMode
                        ? Colors.white
                        : Color.fromARGB(255, 61, 61, 61),
                  ),
                  title: Text('Hide',
                      style: GoogleFonts.abel(
                        letterSpacing: 1,
                        color: widget.isDarkMode
                            ? Colors.white
                            : Color.fromARGB(255, 61, 61, 61),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
