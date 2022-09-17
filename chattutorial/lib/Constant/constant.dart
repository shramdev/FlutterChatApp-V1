import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Auth
final _fireStore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
// Colors
const Color profileBGcolor = Color(0xFFECECEC);
const Color buttonscolor = Color.fromARGB(255, 255, 145, 35);
const Color appBarcolor = Color.fromARGB(255, 255, 128, 0);
const Color errorColor = Color.fromARGB(255, 213, 47, 47);
const Color textBlueColor = Color.fromARGB(255, 61, 131, 251);
// Refrences
final usersRef = _fireStore.collection('users');
final followersRef = _fireStore.collection('followers');
final followingRef = _fireStore.collection('following');
final chatsRef = _fireStore.collection('chats');
final addchatsRef = _fireStore.collection('addchats');
final activityRef = _fireStore.collection('activites');
final publicChatsRef=_fireStore.collection('publicChats');