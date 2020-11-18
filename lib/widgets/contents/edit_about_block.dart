import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAboutBlock extends StatefulWidget {
  @override
  _EditAboutBlockState createState() => _EditAboutBlockState();
}

class _EditAboutBlockState extends State<EditAboutBlock> {
  final _formKey = GlobalKey<FormState>();

  String _aboutMe = '';
  TextEditingController _textEditingController = TextEditingController();

  void _submitForm() async {
    _formKey.currentState.save();
    await ContentService().editAboutBlock(_aboutMe);
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
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
                                  _textEditingController.text =
                                      snapshot.data.data()['aboutMe'];
                                }
                                return Form(
                                  key: _formKey,
                                  child: CustomTextField(
                                      labelText: 'About',
                                      controller: _textEditingController,
                                      onSaved: (value) {
                                        _aboutMe = value;
                                      }),
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
                                child: Text('Add'),
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
        });
  }
}
