import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/widgets/breathing_glowing_button.dart';
import 'package:dogeeexd/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dogeeexd/extensions/hover_extensions.dart';

class EmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BreathingGlowingButton(
                icon: Icons.mail_rounded,
                height: ResponsiveWidget.isSmallScreen(context) ? 70 : 80,
                width: ResponsiveWidget.isSmallScreen(context) ? 70 : 80,
                onTap: () async {
                  if (await canLaunch(
                      'mailto:${snapshot.data.data()['email']}')) {
                    await launch('mailto:${snapshot.data.data()['email']}');
                  } else {
                    throw 'Could not launch url';
                  }
                },
              ).moveUpOnHover;
            }
            return BreathingGlowingButton(
              icon: Icons.mail_rounded,
              height: ResponsiveWidget.isSmallScreen(context) ? 70 : 80,
              width: ResponsiveWidget.isSmallScreen(context) ? 70 : 80,
              onTap: () {},
            ).moveUpOnHover;
          }),
    );
  }
}
