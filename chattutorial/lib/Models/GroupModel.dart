import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String currentUserId;
  String visitedUserId;
  String adminUserId;
  Timestamp lastMessagetimestamp;
  Timestamp joinedUserat;
  String lastMessagetext;
  Timestamp lastSeen;
  bool isDarkMode;
  ChatModel({
    required this.joinedUserat,
    required this.visitedUserId,
    required this.adminUserId,
    required this.currentUserId,
    required this.lastMessagetimestamp,
    required this.lastMessagetext,
    required this.lastSeen,
    required this.isDarkMode,
  });

  factory ChatModel.fromDoc(DocumentSnapshot doc) {
    return ChatModel(
      visitedUserId: doc['visitedUserId'],
      adminUserId: doc['adminUserId'],
      joinedUserat: doc['joined User at '],
      lastMessagetext: doc['lastMessage text'],
      lastMessagetimestamp: doc['lastMessage Timestamp'],
      lastSeen: doc['lastSeen'],
      isDarkMode: doc['isDarkMode'],
      currentUserId: doc['currentUserId'],
    );
  }
}
