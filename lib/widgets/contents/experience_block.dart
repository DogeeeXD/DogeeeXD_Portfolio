import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/contents/edit_experience_block_form.dart';
import 'package:dogeeexd/widgets/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExperienceBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;
    final currentUser = FirebaseAuth.instance.currentUser;

    DateFormat formatter = DateFormat('MMM yyyy');

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('experiences')
          .orderBy('endDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                          accentColor: Color(0xFF373A49),
                        ),
                        child: ExpansionTile(
                          backgroundColor: Colors.transparent,
                          expandedAlignment: Alignment.centerLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: EdgeInsets.all(15),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                items[index]['jobTitle'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SelectableText(items[index]['company']),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SelectableText(
                                    formatter.format(DateTime.parse(items[index]
                                            ['startDate']
                                        .toDate()
                                        .toString())),
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  SelectableText('-'),
                                  SelectableText(
                                    formatter.format(DateTime.parse(items[index]
                                            ['endDate']
                                        .toDate()
                                        .toString())),
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SelectableText(
                                items[index]['workLocation'],
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            SelectableText(
                              items[index]['description'],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: null,
                      child: StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasData &&
                              userId == currentUser.uid &&
                              currentUser.emailVerified) {
                            return Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete_rounded),
                                  color: Theme.of(context).errorColor,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text('Are you sure?'),
                                        content: Text(
                                            'Delete ${items[index]['jobTitle']} at ${items[index]['company']}?'),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: FlatButton(
                                              child: Text('Confirm'),
                                              onPressed: () {
                                                ContentService()
                                                    .deleteExperience(
                                                        items[index].id);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit_rounded),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      child: EditExperienceBlockForm(
                                        docId: items[index].id,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}
