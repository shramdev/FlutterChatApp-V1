import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String id;
  Timestamp timestamp;
  bool follow;
  String byUserId;

  ActivityModel({
    required this.id,
    required this.timestamp,
    required this.byUserId,
    required this.follow,
  });

  factory ActivityModel.fromDoc(DocumentSnapshot doc) {
    return ActivityModel(
      id: doc.id,
      timestamp: doc['Timestamp'],
      byUserId: doc['byUserId'],
      follow: doc['follow'],
    );
  }
}
