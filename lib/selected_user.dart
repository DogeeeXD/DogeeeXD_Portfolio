import 'package:flutter/material.dart';

class SelectedUser with ChangeNotifier {
  // String _username = '';
  String _userId = '';

  // String get username {
  //   return this._username;
  // }

  // set username(String user) {
  //   this._username = user;
  //   print('Set username to $user');
  //   notifyListeners();
  // }

  String get userId {
    return this._userId;
  }

  set userId(String userId) {
    this._userId = userId;
    print('Set userId to $userId');
    notifyListeners();
  }
}
