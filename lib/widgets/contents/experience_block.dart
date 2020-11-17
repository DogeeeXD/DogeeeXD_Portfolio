import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExperienceBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('experiences')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(items[index]['jobTitle']),
                  Text(items[index]['workDate']),
                  Text(items[index]['company']),
                  Text(items[index]['workLocation']),
                  Text(items[index]['description']),
                ],
              );
            },
          );
          //return Text(aboutMe ?? '');
        }

        return Container();
      },
    );
  }
}
