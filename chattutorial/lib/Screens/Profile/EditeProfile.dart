import 'dart:io';
import 'dart:typed_data';

import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/userModel.dart';
import 'package:chattutorial/Screens/Profile/EditeName&About&Location.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class EditeProfile extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final UserModel userModel;
  const EditeProfile(
      {Key? key,
      required this.currentUserId,
      required this.userModel,
      required this.visitedUserId})
      : super(key: key);

  @override
  State<EditeProfile> createState() => _EditeProfileState();
}

class _EditeProfileState extends State<EditeProfile> {
  late String _name;
  late String _bio;
  final _formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  bool _isLoading = false;
  late String url = '';
  late String coverUrl = '';
  ImagePicker image = ImagePicker();
  Uint8List? imageBytes;
  File? file;
  File? coverPicture;
  // Pick Profile Image
  pickProfileImage() async {
    final XFile? img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  // Pick Cover picture
  pickCoverPicture() async {
    final XFile? imgcover = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      coverPicture = File(imgcover!.path);
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

// UploadImageProfile
  uploadImage() async {
    if (file != null) {
      setState(() {
        _isLoading = true;
      });
      var imageFile = FirebaseStorage.instance
          .ref()
          .child('profilePicture')
          .child(
              'profilePicture/users/userProfile_${widget.currentUserId}.jpg');
      UploadTask task = imageFile.putFile(file!);
      TaskSnapshot taskSnapshot = await task;
      // for downloading
      url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      _fireStore.collection('users').doc(auth.currentUser!.uid).update({
        'profilePicture': url,
      });
      Navigator.pop(context);
      return true;
    } else {
      return null;
    }
  }

// UploadCoverPicture
  uploadCoverImage() async {
    if (coverPicture != null) {
      setState(() {
        _isLoading = true;
      });
      var imageFile = FirebaseStorage.instance
          .ref()
          .child('coverPicture')
          .child('coverPicture/users/userProfile_${widget.currentUserId}.jpg');
      UploadTask task = imageFile.putFile(coverPicture!);
      TaskSnapshot taskSnapshot = await task;
      // for downloading
      url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      _fireStore.collection('users').doc(auth.currentUser!.uid).update({
        'coverPicture': url,
      });
      Navigator.pop(context);
      return true;
    } else {
      return null;
    }
  }

  saveProfile() {
    if (coverPicture != null && file != null) {
      uploadCoverImage();
      uploadImage();
    } else if (coverPicture != null) {
      uploadCoverImage();
    } else if (file != null) {
      uploadImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.userModel.name;
    _bio = widget.userModel.bio;
    coverPicture = coverPicture;
    file = file;
  }

  var user;
  var key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edite Your Profile',
            style: GoogleFonts.lato(fontSize: 20, color: Colors.black)),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          CupertinoButton(
              child: Text(
                'Save',
                style: GoogleFonts.alef(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: textBlueColor),
              ),
              onPressed: () {
                _isLoading ? null : saveProfile();
              })
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: usersRef.doc(widget.currentUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircleProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Have Something Error!',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(127, 225, 225, 225),
                          image: userModel.coverPicture.isEmpty
                              ? null
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: coverPicture == null
                                      ? NetworkImage(userModel.coverPicture)
                                      : FileImage(File(coverPicture!.path))
                                          as ImageProvider),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6))),
                    ),
                    GestureDetector(
                      onTap: () {
                        pickCoverPicture();
                      },
                      child: Container(
                          height: 150,
                          color: Color.fromARGB(137, 70, 70, 70),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.camera,
                                  size: 50,
                                  color: Colors.white,
                                )
                              ])),
                    )
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -55.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Stack(
                        children: [
                          userModel.profilePicture.isNotEmpty
                              ? CircleAvatar(
                                  backgroundColor: profileBGcolor,
                                  radius: 60,
                                  backgroundImage: file == null
                                      ? NetworkImage(userModel.profilePicture)
                                      : FileImage(File(file!.path))
                                          as ImageProvider)
                              : CircleAvatar(
                                  backgroundColor: profileBGcolor,
                                  radius: 60,
                                  backgroundImage: file == null
                                      ? AssetImage('assets/images/person.png')
                                      : FileImage(File(file!.path))
                                          as ImageProvider),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  userModel.isAnonymous
                                      ? anonymousUserToast()
                                      : pickProfileImage();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: textBlueColor,
                                  ),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(child: _isLoading ? CircleProgressIndicator() : null),
                Text(
                  'Display Name',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var user;
                    var key;
                    _isLoading
                        ? null
                        : Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: EditeName(
                                  currentUserId: widget.currentUserId,
                                  visitedUserId: widget.userModel.id,
                                  user: userModel,
                                  key: key,
                                )));
                  },
                  child: Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                          child: TextFormField(
                            initialValue: _name,
                            style: GoogleFonts.lato(),
                            onChanged: (value) {
                              _name = value;
                            },
                            validator: (input) => input!.trim().isEmpty
                                ? 'please enter valid DisplayName'
                                : null,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              enabled: false,
                              hintText: 'Enter ',
                              hintStyle: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Bio',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _isLoading
                        ? null
                        : Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: EditeAbout(
                                  currentUserId: widget.currentUserId,
                                  visitedUserId: widget.userModel.id,
                                  user: userModel,
                                  key: key,
                                )));
                  },
                  child: Card(
                    elevation: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                          child: TextFormField(
                            initialValue: _bio,
                            style: GoogleFonts.lato(),
                            onChanged: (value) {
                              _bio = value;
                            },
                            validator: (input) => input!.trim().isEmpty
                                ? 'please enter valid bio'
                                : null,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabled: false,
                              hintText: 'Write a bio',
                              hintStyle: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
