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
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(err),
      //     backgroundColor: Theme.of(context).errorColor,
      //   ),
      // );
    });
  }
}
