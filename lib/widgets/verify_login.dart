import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyLogin extends StatelessWidget {
  final Widget verifiedWidget;
  final Widget unverifiedWidget;

  VerifyLogin({
    @required this.verifiedWidget,
    @required this.unverifiedWidget,
  });

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && _auth.currentUser.emailVerified) {
          return verifiedWidget;
        }
        return unverifiedWidget;
      },
    );
  }
}
