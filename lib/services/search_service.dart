import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  Future searchUser(String username) async {
    String userId;
    // search username and return userId
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((value) {
      if (value.size == 0) {
        //print('Is empty');
        throw 'User not found';
      } else {
        //print(value.docs[0].id);
        userId = value.docs[0].id;
      }
    });

    return userId;
  }
}
