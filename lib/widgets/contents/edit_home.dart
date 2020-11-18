import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditHome extends StatefulWidget {
  @override
  _EditHomeState createState() => _EditHomeState();
}

class _EditHomeState extends State<EditHome> {
  final _formKey = GlobalKey<FormState>();

  String _greetings = '';

  String _homeTitle = '';

  String _content = '';

  TextEditingController _greetingsTextEditingController =
      TextEditingController();

  TextEditingController _homeTitleTextEditingController =
      TextEditingController();

  TextEditingController _contentTextEditingController = TextEditingController();

  void _submitForm() async {
    _formKey.currentState.save();
    await ContentService().editHome(
      _greetings,
      _homeTitle,
      _content,
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData &&
            userId == currentUser.uid &&
            currentUser.emailVerified) {
          return IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Text('Edit About'),
                    children: [
                      Container(
                        width: 500,
                        padding: EdgeInsets.all(15),
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser.uid)
                                .get(),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                _greetingsTextEditingController.text =
                                    snapshot.data.data()['greetings'];
                                _homeTitleTextEditingController.text =
                                    snapshot.data.data()['homeTitle'];
                                _contentTextEditingController.text =
                                    snapshot.data.data()['content'];
                              }
                              return Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    CustomTextField(
                                        labelText: 'Greetings',
                                        controller:
                                            _greetingsTextEditingController,
                                        onSaved: (value) {
                                          _greetings = value;
                                        }),
                                    CustomTextField(
                                        labelText: 'Title',
                                        controller:
                                            _homeTitleTextEditingController,
                                        onSaved: (value) {
                                          _homeTitle = value;
                                        }),
                                    CustomTextField(
                                        labelText: 'Extra text',
                                        controller:
                                            _contentTextEditingController,
                                        onSaved: (value) {
                                          _content = value;
                                        }),
                                  ]),
                                ),
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton(
                              child: Text('Discard'),
                              onPressed: () {
                                // Pop
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text('Save'),
                              onPressed: () {
                                // Add firestore doc
                                _submitForm();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            },
          );
        }
        return Container();
      },
    );
  }
}
