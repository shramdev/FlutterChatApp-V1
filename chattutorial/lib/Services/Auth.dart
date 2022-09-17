import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(
    String name,
    String email,
    String password,
    String gender,
    bool admin,
  ) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User signedInUser = authResult.user!;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'id': _auth.currentUser!.uid,
          'password': password,
          'name': name,
          'email': email,
          'profilePicture':
              'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png',
          'verification': '',
          'bio': '',
          'gender': gender,
          'joinedAt': Timestamp.now(),
          'admin': admin,
          'isAnonymousUser': false,
          'isVerified': true,
          'coverPicture': '',
        });
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static void logout() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> signAnon() async {
    try {
      UserCredential authResult = await _auth.signInAnonymously();
      User signedInUser = authResult.user!;
      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'id': _auth.currentUser!.uid,
          'password': 'Anonymous',
          'name': '',
          'email': 'Anonymous',
          'profilePicture':
              'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png',
          'verification': '',
          'bio': '',
          'gender': 'Anonymous',
          'joinedAt': Timestamp.now(),
          'admin': false,
          'isAnonymousUser': true,
          'isVerified': true,
          'Town or City': '',
          'Country': '',
        });
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
