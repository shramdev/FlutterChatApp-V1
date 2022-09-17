import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Profile/EditeProfile.dart';
import 'package:chattutorial/Screens/Profile/privacy/privacy.dart';
import 'package:chattutorial/Services/Auth.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/profile_ImagePreview.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;
  const ProfileScreen(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.userModel})
      : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isAddingCollectionsUser = false;
  String uuidChat = Uuid().v1();
  String activityid = Uuid().v4();

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNumber(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNumber(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  createCollection() {
    if (_isAddingCollectionsUser) {
      DatabaseServices.removeCollection(
          widget.currentUserId, widget.visitedUserId);
    } else {
      DatabaseServices.createCollection(
        widget.currentUserId,
        widget.visitedUserId,
      );
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(
      widget.currentUserId,
      widget.visitedUserId,
    );
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(
        widget.currentUserId, widget.visitedUserId, activityid);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  setupIsChatCollection() async {
    bool isAddingThisUser = await DatabaseServices.isCollection(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isAddingCollectionsUser = isAddingThisUser;
    });
  }

  @override
  void initState() {
    super.initState();
    setupIsFollowing();
    setupIsChatCollection();
    getFollowersCount();
    getFollowingCount();
    _followersCount = _followersCount;
    _followingCount = _followingCount;
  }

  var key;
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
        title: Text('Profile', style: GoogleFonts.lato(color: Colors.black)),
      ),
      body: RefreshIndicator(
        onRefresh: () => setupIsFollowing(),
        child: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
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
            return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                userModel.isAnonymous
                    ? SizedBox(
                        height: 60,
                      )
                    : Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(127, 225, 225, 225),
                            image: userModel.coverPicture.isEmpty
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(userModel.coverPicture),
                                  ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6))),
                      ),
                Container(
                  transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              userModel.isAnonymous
                                  ? GestureDetector(
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: AssetImage(
                                            'assets/images/anonlogo.png'),
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        userModel.isAnonymous
                                            ? null
                                            : Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: ProfileImagePreview(
                                                      currentUserId:
                                                          widget.currentUserId,
                                                      visitedUserId:
                                                          widget.visitedUserId,
                                                      profilePicture: userModel
                                                          .profilePicture,
                                                      key: key,
                                                    )));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 57.5,
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundImage: NetworkImage(
                                            userModel.profilePicture,
                                          ),
                                          backgroundColor: profileBGcolor,
                                        ),
                                      )),
                            ],
                          ),
                          widget.currentUserId == widget.visitedUserId
                              ? GestureDetector(
                                  onTap: () async {
                                    userModel.isAnonymous
                                        ? Fluttertoast.showToast(
                                            msg:
                                                'Go to Privacy/Anonymous status/turn off Anonymous status',
                                            backgroundColor: Colors.grey)
                                        : await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditeProfile(
                                                currentUserId:
                                                    widget.currentUserId,
                                                userModel: userModel,
                                                visitedUserId:
                                                    widget.visitedUserId,
                                              ),
                                            ),
                                          );
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: GestureDetector(
                                    onTap: followOrUnFollow,
                                    child: Container(
                                      width: 100,
                                      height: 35,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: _isFollowing
                                            ? Colors.white
                                            : Colors.black,
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _isFollowing ? 'Following' : 'Follow',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: _isFollowing
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Text(
                              '$_followingCount Following',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              width: 1,
                              height: 11,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '$_followersCount Followers',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userModel.isAnonymous?'Anonymous ':userModel.name,
                                style: GoogleFonts.lato(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              userModel.isAnonymous
                              ?SizedBox():
                              userModel.verification.isNotEmpty
                                  ? Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      size: 16,
                                      color: Colors.blueAccent,
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          userModel.isAnonymous
                              ? SizedBox()
                              : Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    userModel.bio.isEmpty
                                        ? ''
                                        : "${userModel.bio}",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 96, 96, 96),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                        ],
                      ),
                      userModel.bio.isNotEmpty
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(),
                      userModel.bio.isNotEmpty ? Divider() : SizedBox(),
                    ],
                  ),
                ),
                widget.currentUserId != widget.visitedUserId
                    ? SizedBox()
                    : Column(
                        children: [
                          Card(
                            child: ListTile(
                              onTap: () {
                                userModel.isAnonymous
                                    ? Fluttertoast.showToast(
                                        msg:
                                            'Go to privacy/Anonymous status/turn off Anonymous status',
                                        backgroundColor: Colors.grey)
                                    : Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: EditeProfile(
                                              currentUserId:
                                                  widget.currentUserId,
                                              visitedUserId:
                                                  widget.visitedUserId,
                                              userModel: userModel,
                                            )));
                              },
                              leading: Icon(
                                FlutterIcons.edit_faw,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Edite Profile',
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: PrivacyScreen(
                                          currentUserId: widget.currentUserId,
                                          visitedUserId: widget.visitedUserId,
                                          userModel: userModel,
                                          key: key,
                                        )));
                              },
                              leading: Icon(
                                FlutterIcons.lock1_ant,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Privacy',
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              subtitle: Text(
                                'Tap to copy',
                                style: GoogleFonts.lato(
                                    color: Colors.grey, fontSize: 13),
                              ),
                              onTap: () {
                                FlutterClipboard.copy(userModel.id);
                                Fluttertoast.showToast(msg: 'Copied');
                              },
                              leading: Icon(
                                FlutterIcons.id_badge_faw,
                                color: Colors.black,
                              ),
                              title: Text(
                                'UserId: ${userModel.id}',
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(
                                FlutterIcons.create_mdi,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Joined on ${userModel.joinedAt.toDate().toString().substring(0, 10)}',
                                style: GoogleFonts.lato(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              onTap: () {
                                AuthService.logout();
                                Navigator.pop(context);
                              },
                              leading: Icon(
                                FlutterIcons.logout_mco,
                                color: Colors.red,
                              ),
                              title: Text(
                                'LogOut',
                                style: GoogleFonts.lato(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
