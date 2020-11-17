import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExperienceBlock extends StatefulWidget {
  @override
  _AddExperienceBlockState createState() => _AddExperienceBlockState();
}

class _AddExperienceBlockState extends State<AddExperienceBlock> {
  final _formKey = GlobalKey<FormState>();

  String _jobTitle;
  String _company;
  String _workDate;
  String _location;
  String _description;

  void _submitForm() async {
    _formKey.currentState.save();
    await ContentService().addExperience(
      jobTitle: _jobTitle,
      company: _company,
      workDate: _workDate,
      location: _location,
      description: _description,
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData && userId == currentUser.uid) {
          return IconButton(
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              showDialog(
                  context: context,
                  child: SimpleDialog(
                    title: Text('Add experience'),
                    children: [
                      Container(
                        width: 500,
                        padding: EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              CustomTextField(
                                  labelText: 'Job Title',
                                  onSaved: (value) {
                                    _jobTitle = value;
                                  }),
                              CustomTextField(
                                  labelText: 'Company',
                                  onSaved: (value) {
                                    _company = value;
                                  }),
                              CustomTextField(
                                  labelText: 'Work Date',
                                  onSaved: (value) {
                                    _workDate = value;
                                  }),
                              CustomTextField(
                                  labelText: 'Location',
                                  onSaved: (value) {
                                    _location = value;
                                  }),
                              CustomTextField(
                                  labelText: 'Description',
                                  onSaved: (value) {
                                    _description = value;
                                  }),
                            ]),
                          ),
                        ),
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
      },
    );
  }
}
