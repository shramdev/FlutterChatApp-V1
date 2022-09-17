import 'package:chattutorial/Constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

CircleProgressIndicator() {
  return CircularProgressIndicator(
    strokeWidth: 3.5,
    backgroundColor: textBlueColor,
    valueColor: AlwaysStoppedAnimation(
      Colors.white,
    ),
  );
}

listcacheUI() {
  return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: profileBGcolor,
      ),
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: profileBGcolor,
        ),
      ));
}

suggestionlistcacheUI(context) {
  double width = MediaQuery.of(context).size.width;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: profileBGcolor,
        ),
        Container(
          height: 100,
          width: width / 1.5,
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 225, 225),
              borderRadius: BorderRadius.circular(15)),
        ),
      ],
    ),
  );
}

anonymousUserToast() {
  return Fluttertoast.showToast(
      msg: 'You are the Anonymous user', backgroundColor: appBarcolor);
}
