import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../Constant/constant.dart';
import '../../Models/usermodel.dart';
import '../../Services/DatabaseServices.dart';
import '../../Widgets/widget.dart';
import '../Profile/profile.dart';

class SearchSC extends StatefulWidget {
  final String currentUserId;

  const SearchSC({
    required Key key,
    required this.currentUserId,
  }) : super(key: key);
  @override
  _SearchSCState createState() => _SearchSCState();
}

class _SearchSCState extends State<SearchSC> {
  Future<QuerySnapshot>? _users;
  TextEditingController _searchController = TextEditingController();
  var key;

  buildUserTile(UserModel user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            child: ListTile(
              leading: user.profilePicture.isEmpty
                  ? CircleAvatar(
                      backgroundColor: textBlueColor,
                      radius: 23,
                      child: InkWell(
                        child: CircleAvatar(
                            backgroundColor: profileBGcolor,
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/person.png')),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: buttonscolor,
                      radius: 23,
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundColor: profileBGcolor,
                          radius: 22,
                          backgroundImage: NetworkImage(user.profilePicture),
                        ),
                      ),
                    ),
              title: Row(
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.alef(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  user.verification.isNotEmpty
                      ? Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 16,
                          color: Colors.blueAccent,
                        )
                      : SizedBox()
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ProfileScreen(
                          currentUserId: widget.currentUserId,
                          visitedUserId: user.id,
                          userModel: key,
                          key: key,
                        )));
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: CupertinoSearchTextField(
                itemColor: textBlueColor,
                style: TextStyle(color: Colors.black),
                controller: _searchController,
                borderRadius: BorderRadius.circular(10),
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    setState(() {
                      _users = DatabaseServices.searchUsers(input);
                    });
                  }
                }),
          )),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.search,
                    size: 200,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      listcacheUI(),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 12, top: 5),
                              child: Text(
                                  'Searching For "${_searchController.text}"',
                                  style: GoogleFonts.krub(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ))),
                        ],
                      )
                    ],
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No users found!',
                            style: GoogleFonts.alef(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            )),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircleProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data.docs[index]);
                      return Column(
                        children: [
                          snapshot.data.docs != 2
                              ? Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 5),
                                        child: Text('Your Result',
                                            style: GoogleFonts.krub(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ))),
                                  ],
                                )
                              : SizedBox(),
                          buildUserTile(user),
                        ],
                      );
                    });
              }),
    );
  }
}
