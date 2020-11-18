import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthService {
  Future createUser(
    BuildContext context,
    String email,
    String password,
    String username,
  ) async {
    final _auth = FirebaseAuth.instance;
    UserCredential authResult;

    authResult = await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      throw err;
    });

    if (!_auth.currentUser.emailVerified) {
      await _auth.currentUser.sendEmailVerification();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user.uid)
        .set({
      'username': username,
      'email': email,
    }).catchError((err) {
      print(err);
    });
  }

  Future loginUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final _auth = FirebaseAuth.instance;

    await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      throw err;
    });
  }

  Stream<bool> checkEmailVerified() async* {
    var _auth = FirebaseAuth.instance;

    bool isVerified = false;

    while (!_auth.currentUser.emailVerified) {
      isVerified = _auth.currentUser.emailVerified;
      await Future.delayed(Duration(seconds: 1));
      yield isVerified;
      _auth.currentUser.reload();
      // if (isVerified) break;
    }
    isVerified = _auth.currentUser.emailVerified;
    print('verified!');
    yield isVerified;
  }

  sendVerificationEmail() async {
    final _auth = FirebaseAuth.instance;
    await _auth.currentUser.sendEmailVerification();
  }

  resetPassword(String email) async {
    final _auth = FirebaseAuth.instance;
    await _auth.sendPasswordResetEmail(email: email);
  }
}
