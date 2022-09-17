import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String uuidchat;
  String senderId;
  String receiverId;
  String message;
  String image;
  bool isSendByMy;
  Timestamp timestamp;
  MessageModel({
    required this.image,
    required this.uuidchat,
    required this.isSendByMy,
    required this.message,
    required this.receiverId,
    required this.timestamp,
    required this.senderId,
  });

  factory MessageModel.fromDoc(DocumentSnapshot doc) {
    return MessageModel(
        uuidchat: doc['uuidchat'],
        isSendByMy: doc['SendByMy'],
        message: doc['TextMessage'],
        receiverId: doc['RecevierId'],
        senderId: doc['SenderId'],
        timestamp: doc['Timestamp'],
        image: doc['Image']);
  }
}
