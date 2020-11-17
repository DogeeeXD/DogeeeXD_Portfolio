import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String aboutMe = snapshot.data.data()['aboutMe'];

          return Text(aboutMe ?? '');
        }

        return Container();
      },
    );
  }
}
