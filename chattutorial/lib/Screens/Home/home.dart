import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/ActivityModel.dart';
import 'package:chattutorial/Models/ChatModel.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Activites/activites.dart';
import 'package:chattutorial/Screens/Home/Chats/ChatsScreen.dart';
import 'package:chattutorial/Screens/Home/Chats/GlobalChat.dart';
import 'package:chattutorial/Screens/Profile/profile.dart';
import 'package:chattutorial/Screens/Search/search.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreenChats extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;
  final ActivityModel activityModel;
  const HomeScreenChats(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.userModel,
      required this.activityModel})
      : super(key: key);
  @override
  State<HomeScreenChats> createState() => _HomeScreenChatsState();
}

class _HomeScreenChatsState extends State<HomeScreenChats> {
  var key;
  List _addedusers = [];
  bool _loading = false;
  getaddedUsers() async {
    List<ChatModel> users = await DatabaseServices.getCollectionChats(
      widget.currentUserId,
    );
    if (mounted) {
      setState(() {
        _addedusers = users.toList();
      });
      print('This Result: ${_addedusers.length}');
    }
  }

  buildchats(ChatModel chatModel) {
    return StreamBuilder(
        stream: usersRef.doc(chatModel.visitedUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return listcacheUI();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
            return Column(
              children: [
                Card(
                  elevation: 1,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ChatScreen(
                                activityModel: widget.activityModel,
                                isAnonymous: user.isAnonymous,
                                user: widget.userModel,
                                verification: user.verification,
                                name: user.name,
                                profilePicture: user.profilePicture,
                                lastSeen: chatModel.lastSeen,
                                key: key,
                                currentUserId: widget.currentUserId,
                                visitedUserId: user.id,
                                isDarkMode: chatModel.isDarkMode,
                              )));
                      setState(() {
                        getaddedUsers();
                      });
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
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
                                            child: Icon(
                                              AntDesign.close,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        Text(user.name,
                                            style: GoogleFonts.abel(
                                              letterSpacing: 1,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          width: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: ProfileScreen(
                                                userModel: key,
                                                currentUserId:
                                                    widget.currentUserId,
                                                visitedUserId:
                                                    chatModel.visitedUserId,
                                                key: key,
                                              )));
                                    },
                                    leading: Icon(CupertinoIcons.person_circle),
                                    title: Text('View Profile',
                                        style: GoogleFonts.abel(
                                          letterSpacing: 1,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        )),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      CupertinoIcons.info_circle,
                                    ),
                                    title: Text(
                                      'Info',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      CupertinoIcons.trash_circle,
                                    ),
                                    title: Text(
                                      'Unfollow',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: ChatScreen(
                                                isAnonymous: user.isAnonymous,
                                                user: user,
                                                activityModel:
                                                    widget.activityModel,
                                                isDarkMode:
                                                    chatModel.isDarkMode,
                                                verification: user.verification,
                                                name: user.name,
                                                profilePicture:
                                                    user.profilePicture,
                                                lastSeen: chatModel.lastSeen,
                                                key: key,
                                                currentUserId:
                                                    widget.currentUserId,
                                                visitedUserId:
                                                    chatModel.visitedUserId,
                                              )));
                                      getaddedUsers();
                                    },
                                    leading: Icon(
                                      CupertinoIcons.chat_bubble_text,
                                    ),
                                    title: Text(
                                      'Chat',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    textColor: Colors.black,
                    leading: user.isAnonymous
                        ? GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                                radius: 23,
                                backgroundColor: profileBGcolor,
                                backgroundImage:
                                    AssetImage('assets/images/anonlogo.png')),
                          )
                        : GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: profileBGcolor,
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                            ),
                          ),
                    title: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ProfileScreen(
                                      userModel: key,
                                      currentUserId: widget.currentUserId,
                                      visitedUserId: chatModel.visitedUserId,
                                      key: key,
                                    )));
                          },
                          child: Text(user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        user.verification.isNotEmpty
                            ? Icon(
                                CupertinoIcons.checkmark_seal_fill,
                                size: 14.5,
                                color: Colors.blueAccent,
                              )
                            : SizedBox()
                      ],
                    ),
                    subtitle: Text(
                        '${timeago.format(chatModel.lastMessagetimestamp.toDate())} ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            fontSize: 10.5)),
                    trailing: Icon(Icons.chevron_right_sharp),
                  ),
                ),
                //
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    getaddedUsers();
  }

  buildFloationAction() {
    return StreamBuilder(
        stream: usersRef.doc(widget.currentUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return listcacheUI();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: GlobalChats(
                          currentUserId: widget.currentUserId,
                          visitedUserId: widget.visitedUserId,
                          userModel: user,
                          key: key,
                        )));
              },
              borderRadius: BorderRadius.circular(20),
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 44, 37, 244),
                radius: 30,
                child: Icon(
                  FlutterIcons.globe_ent,
                  color: Colors.white,
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloationAction(),
      appBar: AppBar(
          title: Text(
            'T-Chat',
            style: GoogleFonts.lato(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.topToBottom,
                          child: SearchSC(
                            currentUserId: widget.currentUserId,
                            key: key,
                          )));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.topToBottom,
                          child: ActivitesScreen(
                            key: key,
                            activityModel: widget.activityModel,
                            currentUserId: widget.currentUserId,
                            visitedUserId: widget.currentUserId,
                          )));
                },
                icon: Icon(
                  FlutterIcons.user_friends_faw5s,
                  color: Colors.black,
                )),
            StreamBuilder(
                stream: usersRef.doc(widget.currentUserId).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: Center(child: CircleProgressIndicator()),
                    );
                  } else if (snapshot == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: Center(child: CircleProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Snapshot Error',
                              style: GoogleFonts.alef(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: errorColor)),
                        ],
                      ),
                    );
                  }
                  UserModel userModel = UserModel.fromDoc(snapshot.data);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: ProfileScreen(
                                currentUserId: widget.currentUserId,
                                userModel: widget.userModel,
                                visitedUserId: userModel.id,
                              )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: userModel.isAnonymous
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/anonlogo.png'),
                              backgroundColor: profileBGcolor,
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(userModel.profilePicture),
                              backgroundColor: profileBGcolor,
                            ),
                    ),
                  );
                }),
          ]),
      body: RefreshIndicator(
          strokeWidth: 2,
          color: Colors.white,
          backgroundColor: Colors.blueAccent.shade400,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => getaddedUsers(),
          child: setUpLoading()),
    );
  }

  Widget setUpLoading() {
    if (_addedusers.length == 0) {
      return GestureDetector(
        onTap: () {
          getaddedUsers();
        },
        child: Center(
            child: Text(
          "You Don't added Anyone.",
          style: GoogleFonts.lato(fontSize: 20),
        )),
      );
    } else {
      return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: _addedusers.length,
          itemBuilder: (BuildContext context, int index) {
            ChatModel chatModel = _addedusers[index];
            return Padding(
                padding: EdgeInsets.only(
                  left: 1,
                  right: 1,
                ),
                child: buildchats(chatModel));
          });
    }
  }
}
