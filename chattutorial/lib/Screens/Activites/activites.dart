import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/ActivityModel.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Home/Chats/ChatsScreen.dart';
import 'package:chattutorial/Screens/Profile/profile.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivitesScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final ActivityModel activityModel;
  const ActivitesScreen(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.activityModel})
      : super(key: key);

  @override
  State<ActivitesScreen> createState() => _ActivitesScreenState();
}

class _ActivitesScreenState extends State<ActivitesScreen> {
  List<ActivityModel> _activities = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  var key;
  setupActivities() async {
    List<ActivityModel> activities =
        await DatabaseServices.getActivities(auth.currentUser!.uid);
    if (mounted) {
      setState(() {
        _activities = activities.toList();
      });
    }
    print(_activities.length);
  }

  buildActivity(ActivityModel activityModel) {
    return StreamBuilder(
        stream: usersRef.doc(activityModel.byUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return listcacheUI();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 1),
                child: ListTile(
                  leading: user.profilePicture.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ProfileScreen(
                                      userModel: user,
                                      currentUserId: widget.visitedUserId,
                                      visitedUserId: activityModel.byUserId,
                                      key: key,
                                    )));
                          },
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: profileBGcolor,
                              backgroundImage:
                                  AssetImage('assets/images/person.png')),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ProfileScreen(
                                      userModel: user,
                                      currentUserId: widget.currentUserId,
                                      visitedUserId: activityModel.byUserId,
                                      key: key,
                                    )));
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: profileBGcolor,
                            backgroundImage: NetworkImage(user.profilePicture),
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
                                    userModel: user,
                                    currentUserId: widget.currentUserId,
                                    visitedUserId: activityModel.byUserId,
                                    key: key,
                                  )));
                        },
                        child: Text(
                          '${user.name}',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ),
                      user.verification.isNotEmpty
                          ? Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              size: 12.5,
                              color: Colors.blueAccent,
                            )
                          : SizedBox(),
                      Text(
                        ' Started follow you',
                        style: GoogleFonts.lato(),
                      ),
                      Text(
                        '·',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      'You can now send the message with \n ${user.name}',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    timeago.format(activityModel.timestamp.toDate()),
                    style: GoogleFonts.lato(fontSize: 12.5, color: Colors.grey),
                  ),
                  Divider()
                ],
              ),
            ]);
          }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        automaticallyImplyLeading: true,
        title: Text(
          'Activity',
          style: GoogleFonts.krub(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => setupActivities(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: _activities.length,
              itemBuilder: (BuildContext context, int index) {
                ActivityModel activity = _activities[index];
                return buildActivity(activity);
              }),
        ),
      ),
    );
  }
}
