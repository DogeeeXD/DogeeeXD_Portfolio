import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/content_service.dart';
import 'package:dogeeexd/widgets/contents/edit_experience_block_form.dart';
import 'package:dogeeexd/widgets/custom_textfield.dart';
import 'package:dogeeexd/widgets/dateTimeRangePicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExperienceBlock extends StatefulWidget {
  @override
  _AddExperienceBlockState createState() => _AddExperienceBlockState();
}

class _AddExperienceBlockState extends State<AddExperienceBlock> {
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
            icon: Icon(Icons.add_rounded),
            onPressed: () {
              showDialog(
                context: context,
                child: EditExperienceBlockForm(),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
