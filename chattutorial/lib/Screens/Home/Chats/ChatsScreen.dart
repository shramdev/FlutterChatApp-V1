import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chattutorial/Constant/constant.dart';
import 'package:chattutorial/Models/ActivityModel.dart';
import 'package:chattutorial/Models/Message.dart';
import 'package:chattutorial/Screens/Home/Chats/ChatWidget.dart';
import 'package:chattutorial/Screens/Home/home.dart';
import 'package:chattutorial/Screens/Profile/profile.dart';
import 'package:chattutorial/Services/DatabaseServices.dart';
import 'package:chattutorial/Widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;
  final String profilePicture;
  final String name;
  final String verification;
  final Timestamp lastSeen;
  final bool isDarkMode;
  final bool isAnonymous;
  final user;
  final ActivityModel activityModel;
  const ChatScreen(
      {Key? key,
      required this.currentUserId,
      required this.visitedUserId,
      required this.profilePicture,
      required this.lastSeen,
      required this.name,
      required this.verification,
      required this.isDarkMode,
      required this.activityModel,
      this.user,
      required this.isAnonymous})
      : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var key;
  List<MessageModel> _messages = [];
  bool _isSending = false;
  bool _isPending = false;
  final messageController = TextEditingController();
  ImagePicker image = ImagePicker();
  File? file;

  // Pick Image
  pickImage() async {
    final XFile? img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
    uploadChatImage();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

// UploadImageChat
  uploadChatImage() async {
    String uniquePhotoId = const Uuid().v1();
    File image = await compressImage(uniquePhotoId, file!);
    UploadTask uploadTask = storageRef
        .child('chatImages/images/image_$uniquePhotoId.jpg')
        .putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      _isSending = true;
      var chatId = const Uuid().v4();

      // CurrentUserId
      addchatsRef
          .doc(widget.currentUserId)
          .collection('Add')
          .doc(widget.visitedUserId)
          .update({
        'lastMessage Timestamp': Timestamp.now(),
        'lastMessage text': 'Send a photo',
      });
      // VisitedUserId

      addchatsRef
          .doc(widget.visitedUserId)
          .collection('Add')
          .doc(widget.currentUserId)
          .update({
        'lastMessage Timestamp': Timestamp.now(),
        'lastMessage text': 'Send a photo',
      });

      // SendMessage

// SetUp CurrentUserId
      chatsRef
          .doc(widget.currentUserId)
          .collection('Chat with')
          .doc(widget.visitedUserId)
          .collection('Messages')
          .doc(chatId)
          .set({
        'TextMessage': '',
        'SenderId': widget.currentUserId,
        'RecevierId': widget.visitedUserId,
        'Timestamp': Timestamp.now(),
        'SendByMy': true,
        'Image': downloadUrl,
        'isHide': false,
        'uuidchat': chatId
      }).then((value) {
        // SetUp VisitedUserId

        chatsRef
            .doc(widget.visitedUserId)
            .collection('Chat with')
            .doc(widget.currentUserId)
            .collection('Messages')
            .doc(chatId)
            .set({
          'TextMessage': '',
          'SenderId': widget.currentUserId,
          'RecevierId': widget.visitedUserId,
          'Timestamp': Timestamp.now(),
          'SendByMy': false,
          'Image': downloadUrl,
          'isHide': false,
          'uuidchat': chatId
        });
        setState(() {
          _isSending = false;
        });
      });
    });
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, '$path/img_$photoId.jpg',
        quality: 85);

    return compressedImage!;
  }

  bool _isDarkmode = false;
  setupIsDarkMode() async {
    bool isDarkModeUser = await DatabaseServices.isDarkMode(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isDarkmode = isDarkModeUser;
    });
  }

  offDarkMode(BuildContext context) {
    setState(() {
      addchatsRef
          .doc(widget.currentUserId)
          .collection('Add')
          .doc(widget.visitedUserId)
          .update({'isDarkMode': false}).then((value) => {
                AnimatedSnackBar.material(
                  'DarkMode is Off',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition
                      .bottom, // Position of snackbar on mobile devices
                  desktopSnackBarPosition: DesktopSnackBarPosition
                      .topRight, // Position of snackbar on desktop devices
                ).show(context)
              });
    });
    return true;
  }

  onDarkMod(BuildContext context) {
    setState(() {
      addchatsRef
          .doc(widget.currentUserId)
          .collection('Add')
          .doc(widget.visitedUserId)
          .update({'isDarkMode': true}).then((value) => {
                AnimatedSnackBar.material(
                  'DarkMode is On',
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition
                      .bottom, // Position of snackbar on mobile devices
                  desktopSnackBarPosition: DesktopSnackBarPosition
                      .topRight, // Position of snackbar on desktop devices
                ).show(context)
              });
    });

    return true;
  }

  chaneThemeMethod() {
    if (widget.isDarkMode == false) {
      setState(() {
        onDarkMod(context);
        _isDarkmode = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreenChats(
                  activityModel: widget.activityModel,
                  currentUserId: widget.currentUserId,
                  userModel: widget.user,
                  visitedUserId: widget.verification,
                  key: key,
                )),
      );
    } else if (widget.isDarkMode == true) {
      setState(() {
        offDarkMode(context);
        _isDarkmode = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreenChats(
                    activityModel: widget.activityModel,
                    currentUserId: widget.currentUserId,
                    userModel: widget.user,
                    visitedUserId: widget.verification,
                    key: key,
                  )),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupIsDarkMode();
    _isDarkmode = _isDarkmode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Color.fromARGB(255, 61, 61, 61) : Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text(
                                  'For change the theme clik Confirm button and wiil be automaticly restart the page'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancle'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              chaneThemeMethod();
                            },
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ProfileScreen(
                        userModel: key,
                        currentUserId: widget.currentUserId,
                        visitedUserId: widget.visitedUserId,
                        key: key,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: widget.isAnonymous
                  ? CircleAvatar(
                      backgroundColor: profileBGcolor,
                      backgroundImage: AssetImage('assets/images/anonlogo.png'),
                    )
                  : CircleAvatar(
                      backgroundColor: profileBGcolor,
                      backgroundImage: NetworkImage(widget.profilePicture),
                    ),
            ),
          ),
        ],
        elevation: 0.1,
        backgroundColor:
            widget.isDarkMode ? Color.fromARGB(255, 64, 64, 64) : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: widget.isDarkMode
                ? Color.fromARGB(255, 209, 209, 209)
                : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ProfileScreen(
                      userModel: key,
                      currentUserId: widget.currentUserId,
                      visitedUserId: widget.visitedUserId,
                      key: key,
                    )));
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.lato(
                        color: widget.isDarkMode
                            ? Color.fromARGB(255, 209, 209, 209)
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  ),
                  widget.verification.isNotEmpty
                      ? const Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 13.5,
                          color: Colors.blueAccent,
                        )
                      : const SizedBox()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 5),
                child: Text(
                  'Last opened ${timeago.format(widget.lastSeen.toDate())} ',
                  style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 149, 148, 148),
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatsRef
                  .doc(widget.currentUserId)
                  .collection('Chat with')
                  .doc(widget.visitedUserId)
                  .collection('Messages')
                  .orderBy('Timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: false,
                      reverse: true,
                      primary: true,
                      // physics: BouncingScrollPhysics(
                      //     parent: AlwaysScrollableScrollPhysics()),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        bool isMy = snapshot.data.docs[index]['SenderId'] ==
                            widget.currentUserId;
                        return ChatWidget(
                          isDarkMode: widget.isDarkMode,
                          textMessage: snapshot.data.docs[index]['TextMessage'],
                          loading: _isSending,
                          image: snapshot.data.docs[index]['Image'],
                          timestamp: snapshot.data.docs[index]['Timestamp'],
                          isSendByMy: isMy,
                          recevierId: snapshot.data.docs[index]['RecevierId'],
                          senderId: snapshot.data.docs[index]['SenderId'],
                          isSending: _isSending,
                          profilePicture: widget.profilePicture,
                          name: widget.name,
                          currentUserId: widget.currentUserId,
                          visitedUserId: widget.visitedUserId,
                          chatid: snapshot.data.docs[index]['uuidchat'],
                        );
                      });
                }
                return Center(
                  child: CircleProgressIndicator(),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 175, 175, 175).withOpacity(.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 40, 33, 33),
                ),
                controller: messageController,
                onSubmitted: (value) => sendMessage(),
                cursorColor: widget.isDarkMode
                    ? Colors.white
                    : Color.fromARGB(255, 40, 33, 33),
                decoration: new InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          pickImage();
                        },
                        icon: Icon(
                          CupertinoIcons.folder,
                          color: widget.isDarkMode
                              ? Colors.white
                              : Color.fromARGB(255, 40, 33, 33),
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
                      color: widget.isDarkMode
                          ? Colors.white
                          : Color.fromARGB(255, 40, 33, 33),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage() {
    setState(() {
      _isSending = true;
    });
    var chatId = const Uuid().v4();

    String message = messageController.text;
    if (message.isEmpty) {
      print('TextFiled isEmpty');
    } else if (message.isNotEmpty) {
      // CurrentUserId
      addchatsRef
          .doc(widget.currentUserId)
          .collection('Add')
          .doc(widget.visitedUserId)
          .update({
        'lastMessage Timestamp': Timestamp.now(),
        'lastMessage text': message,
      });
      // VisitedUserId
      addchatsRef
          .doc(widget.visitedUserId)
          .collection('Add')
          .doc(widget.currentUserId)
          .update({
        'lastMessage Timestamp': Timestamp.now(),
        'lastMessage text': message,
      });

      // SendMessage

// SetUp CurrentUserId
      chatsRef
          .doc(widget.currentUserId)
          .collection('Chat with')
          .doc(widget.visitedUserId)
          .collection('Messages')
          .doc(chatId)
          .set({
        'TextMessage': message,
        'SenderId': widget.currentUserId,
        'RecevierId': widget.visitedUserId,
        'Timestamp': Timestamp.now(),
        'SendByMy': true,
        'Image': '',
        'isHide': false,
        'uuidchat': chatId
      }).then((value) {
        // SetUp VisitedUserId

        chatsRef
            .doc(widget.visitedUserId)
            .collection('Chat with')
            .doc(widget.currentUserId)
            .collection('Messages')
            .doc(chatId)
            .set({
          'TextMessage': message,
          'SenderId': widget.currentUserId,
          'RecevierId': widget.visitedUserId,
          'Timestamp': Timestamp.now(),
          'SendByMy': false,
          'Image': '',
          'isHide': false,
          'uuidchat': chatId
        });
        setState(() {
          messageController.clear();
          _isSending = false;
        });
      });
    }
  }
}
