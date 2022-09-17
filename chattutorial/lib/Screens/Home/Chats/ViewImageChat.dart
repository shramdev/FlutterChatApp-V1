import 'package:chattutorial/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewImage extends StatefulWidget {
  final String image;
  final bool isloading;
  final Timestamp timeago;
  const ViewImage(
      {Key? key,
      required this.image,
      required this.isloading,
      required this.timeago})
      : super(key: key);
  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          timeago.format(widget.timeago.toDate()),
          style: GoogleFonts.lato(fontSize: 15),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
          child: widget.isloading
              ? CircleProgressIndicator()
              : PhotoView(
                  imageProvider: NetworkImage(widget.image),
                )),
    );
  }
}
