import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String profilePicture;
  String coverPicture;
  String email;
  String bio;
  String verification;
  String gender;
  bool admin;
  Timestamp joinedAt;
  bool isAnonymous;
  bool isVerified;

  UserModel({
    required this.coverPicture,
    required this.joinedAt,
    required this.admin,
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.email,
    required this.bio,
    required this.verification,
    required this.gender,
    required this.isAnonymous,
     required this.isVerified,

  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      profilePicture: doc['profilePicture'],
      bio: doc['bio'],
      gender: doc['gender'],
      verification: doc['verification'],
      joinedAt: doc['joinedAt'],
      admin: doc['admin'],
      isAnonymous: doc['isAnonymousUser'],
      isVerified: doc['isVerified'],
      coverPicture: doc['coverPicture']
    );
  }
}
