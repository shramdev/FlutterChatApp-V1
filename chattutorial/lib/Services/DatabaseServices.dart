import 'package:chattutorial/Models/ActivityModel.dart';
import 'package:chattutorial/Models/ChatModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Constant/constant.dart';

import '../Models/usermodel.dart';

class DatabaseServices {
  // Update User Display Nname
  static void updateUserDisplayName(UserModel user) {
    usersRef.doc(user.id).update({
      'name': user.name,
    });
  }

// Update About User
  static void updateAboutUser(UserModel user) {
    usersRef.doc(user.id).update({
      'bio': user.bio,
    });
  }

// CreateCollection Message
  static void createCollection(
    String currentUserId,
    String visitedUserId,
  ) {
    addchatsRef.doc(currentUserId).collection('Add').doc(visitedUserId).set({
      'visitedUserId': visitedUserId,
      'added User at ': Timestamp.now(),
      'lastMessage Timestamp': Timestamp.now(),
      'lastMessage text': '',
      'lastSeen': Timestamp.now(),
      'isDarkMode': false
    }).then((value) => addchatsRef
            .doc(visitedUserId)
            .collection('Add')
            .doc(currentUserId)
            .set({
          'visitedUserId': currentUserId,
          'added User at ': Timestamp.now(),
          'lastMessage Timestamp': Timestamp.now(),
          'lastMessage text': '',
          'lastSeen': Timestamp.now(),
          'isDarkMode': false
        }));
  }

  static void removeCollection(String currentUserId, String visitedUserId) {
    addchatsRef
        .doc(currentUserId)
        .collection('Add')
        .doc(visitedUserId)
        .delete()
        .then((value) => addchatsRef
            .doc(visitedUserId)
            .collection('Add')
            .doc(currentUserId)
            .delete());
  }

// Get Collection Chats
  static Future<List<ChatModel>> getCollectionChats(
    String userid,
  ) async {
    QuerySnapshot usersSnap = await addchatsRef
        .doc(userid)
        .collection('Add')
        .orderBy('lastMessage Timestamp', descending: true)
        .get();
    List<ChatModel> users =
        usersSnap.docs.map((doc) => ChatModel.fromDoc(doc)).toList();
    return users;
  }

  // isAdding Collection
  static Future<bool> isCollection(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot addingDoc = await addchatsRef
        .doc(visitedUserId)
        .collection('Add')
        .doc(currentUserId)
        .get();
    return addingDoc.exists;
  }

  // SearchUsers
  static Future<QuerySnapshot> searchUsers(
    String name,
  ) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();
    return users;
  }

  // Follow User
  static void followUser(
      String currentUserId, String visitedUserId, String activityID) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({
      'visitedUserId': visitedUserId,
      'followedUser at ': Timestamp.now(),
      'lastMessage Timestamp': Timestamp.now(),
      'lastMessage text': ''
    });
    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .set({
      'visitedUserId': visitedUserId,
      'followedUser at ': Timestamp.now(),
      'lastMessage Timestamp': Timestamp.now(),
    });
    addActivity(visitedUserId, currentUserId, activityID, true);
    createCollection(currentUserId, visitedUserId);
  }

  static void addActivity(String visitedUserId, String currentUserId,
      String activityID, follow) async {
    await activityRef
        .doc(visitedUserId)
        .collection('activity')
        .doc(activityID)
        .set({
      'Timestamp': Timestamp.now(),
      'follow': follow,
      'byUserId': currentUserId,
    });
  }

  static void removeActivity(
    String visitedUserId,
    String currentUserId,
  ) async {
    await activityRef
        .doc(visitedUserId)
        .collection('activity')
        .doc(currentUserId)
        .get();
  }

  static Future<List<ActivityModel>> getActivities(String userId) async {
    QuerySnapshot userActivitySnap = await activityRef
        .doc(userId)
        .collection('activity')
        .orderBy('Timestamp', descending: true)
        .limit(15)
        .get();
    List<ActivityModel> userActivity =
        userActivitySnap.docs.map((doc) => ActivityModel.fromDoc(doc)).toList();
    print(userActivity.length);
    return userActivity;
  }

// Unfollow User
  static void unFollowUser(
    String currentUserId,
    String visitedUserId,
  ) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    removeActivity(visitedUserId, currentUserId);
    removeCollection(currentUserId, visitedUserId);
  }

  // Is Following User
  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }

  // Is DarkMode User
  static Future<bool> isDarkMode(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await addchatsRef
        .doc(currentUserId)
        .collection('Add')
        .doc(visitedUserId)
        .get();
    return followingDoc.exists;
  }

// Followers Number
  static Future<int> followersNumber(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  // Following Number
  static Future<int> followingNumber(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

// Get Chat Count Number
  static Future<int> chatsCountNumber(String userId) async {
    QuerySnapshot chatsSnapshot =
        await publicChatsRef.doc('GlobalChats').collection('UserChats').get();
    return chatsSnapshot.docs.length;
  }
}
