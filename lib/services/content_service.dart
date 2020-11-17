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
    String workDate,
    String location,
    String description,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    var dataMap;

    dataMap = {
      'jobTitle': jobTitle,
      'company': company,
      'workDate': workDate,
      'workLocation': location,
      'description': description,
    };

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
