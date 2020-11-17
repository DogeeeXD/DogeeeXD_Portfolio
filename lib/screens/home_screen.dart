import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/widgets/contents/edit_home.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;

    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditHome(),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String greetings = snapshot.data.data()['greetings'];
                  String homeTitle = snapshot.data.data()['homeTitle'];
                  String content = snapshot.data.data()['content'];

                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '$greetings\n\n',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF373A49),
                      ),
                      children: [
                        TextSpan(
                          text: '$homeTitle ',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: content,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Color(0xFF373A49),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
