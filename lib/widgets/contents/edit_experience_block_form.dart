import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/custom_textfield.dart';
import 'package:dogeeexd/widgets/dateTimeRangePicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExperienceBlockForm extends StatefulWidget {
  final String docId;

  EditExperienceBlockForm({this.docId});

  @override
  _EditExperienceBlockFormState createState() =>
      _EditExperienceBlockFormState();
}

class _EditExperienceBlockFormState extends State<EditExperienceBlockForm> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  String _jobTitle;
  String _company;
  DateTimeRange _dateTimeRange;
  DateTime _dateTimeStart = DateTime.now();
  DateTime _dateTimeEnd = DateTime.now();
  String _startDate;
  String _endDate;
  String _location;
  String _description;
  DateFormat formatter = DateFormat('dd MMM yyyy');

  void _submitForm() async {
    _formKey.currentState.save();

    if (widget.docId == null) {
      await ContentService().addExperience(
        jobTitle: _jobTitle,
        company: _company,
        startDate: _dateTimeStart,
        endDate: _dateTimeEnd,
        location: _location,
        description: _description,
      );
    } else if (widget.docId != null) {
      await ContentService().addExperience(
        jobTitle: _jobTitle,
        company: _company,
        startDate: _dateTimeStart,
        endDate: _dateTimeEnd,
        location: _location,
        description: _description,
        docId: widget.docId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add experience'),
      children: [
        Container(
          width: 500,
          padding: EdgeInsets.all(15),
          child: FutureBuilder(
            future: widget.docId != null
                ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('experiences')
                    .doc(widget.docId)
                    .get()
                : null,
            builder: (context, snapshot) {
              if (widget.docId != null && snapshot.hasData) {
                // _startDate = formatter.format(DateTime.parse(
                //     snapshot.data['startDate'].toDate().toString()));
                // _endDate = formatter.format(DateTime.parse(
                //     snapshot.data['endDate'].toDate().toString()));

                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      CustomTextField(
                          labelText: 'Job Title',
                          initialValue: snapshot.data['jobTitle'],
                          onSaved: (value) {
                            _jobTitle = value;
                          }),
                      CustomTextField(
                          labelText: 'Company',
                          initialValue: snapshot.data['company'],
                          onSaved: (value) {
                            _company = value;
                          }),
                      Text('Work Date'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text('Start: ' +
                                (_startDate ??
                                    formatter.format(DateTime.parse(snapshot
                                        .data['startDate']
                                        .toDate()
                                        .toString())))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text('End: ' +
                                (_endDate ??
                                    formatter.format(DateTime.parse(snapshot
                                        .data['endDate']
                                        .toDate()
                                        .toString())))),
                          ),
                        ],
                      ),
                      RaisedButton(
                        child: Text('Select Date'),
                        onPressed: () async {
                          _dateTimeRange = await dateTimeRangePicker(context);
                          setState(() {
                            _dateTimeStart = _dateTimeRange.start;
                            _dateTimeEnd = _dateTimeRange.end;
                            _startDate = formatter.format(_dateTimeRange.start);
                            _endDate = formatter.format(_dateTimeRange.end);
                          });
                        },
                      ),
                      CustomTextField(
                          labelText: 'Location',
                          initialValue: snapshot.data['workLocation'],
                          onSaved: (value) {
                            _location = value;
                          }),
                      CustomTextField(
                          labelText: 'Description',
                          initialValue: snapshot.data['description'],
                          onSaved: (value) {
                            _description = value;
                          }),
                    ]),
                  ),
                );
              } else if (widget.docId == null) {
                return Form(
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
                      Text('Work Date'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                                'Start: ' + formatter.format(_dateTimeStart)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child:
                                Text('End: ' + formatter.format(_dateTimeEnd)),
                          ),
                        ],
                      ),
                      RaisedButton(
                        child: Text('Select Date'),
                        onPressed: () async {
                          _dateTimeRange = await dateTimeRangePicker(context);

                          setState(() {
                            _dateTimeStart = _dateTimeRange.start;
                            _dateTimeEnd = _dateTimeRange.end;
                          });

                          print(_dateTimeStart);
                          print(_dateTimeEnd);
                        },
                      ),
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
                );
              }
              return Container();
            },
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
                child: widget.docId == null ? Text('Add') : Text('Save'),
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
    );
  }
}
