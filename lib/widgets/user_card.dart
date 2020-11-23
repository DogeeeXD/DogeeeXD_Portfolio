import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/screens/main_screen.dart';
import 'package:dogeeexd/selected_user.dart';

import 'package:flutter/material.dart';
import 'package:dogeeexd/extensions/hover_extensions.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final Color shadowColor;

  UserCard({@required this.userId, this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 800,
      ),
      padding: const EdgeInsets.all(15),
      child: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userData = snapshot.data;
              return InkWell(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor ?? Theme.of(context).primaryColor,
                        blurRadius: 5,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(userData['username']),
                      //Text(userData['email']),
                    ],
                  ),
                ),
                onTap: () {
                  // Set selectedUser
                  Provider.of<SelectedUser>(context, listen: false).userId =
                      userId;

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ).moveUpOnHover;
            }
            return Container();
          }),
    );
  }
}
