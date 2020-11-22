import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentService {
  editHome(String greetings, String homeTitle, String content) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'greetings': greetings,
      'homeTitle': homeTitle,
      'content': content,
    });
  }

  editAboutBlock(String aboutMe) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'aboutMe': aboutMe});
  }

  addExperience({
    String jobTitle,
    String company,
    DateTime startDate,
    DateTime endDate,
    String location,
    String description,
    String docId,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    var dataMap;

    dataMap = {
      'jobTitle': jobTitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'workLocation': location,
      'description': description,
    };

    if (docId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('experiences')
          .doc(docId)
          .set(dataMap, SetOptions(merge: true))
          .catchError((err) {
        print(err);
      });
    } else if (docId == null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('experiences')
          .doc()
          .set(dataMap)
          .catchError((err) {
        print(err);
      });
    }
  }

  deleteExperience(String docId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('experiences')
        .doc(docId)
        .delete()
        .catchError((err) {
      print(err);
    });
  }
}
