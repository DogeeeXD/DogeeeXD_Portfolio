import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/widgets/contents/about_block.dart';
import 'package:dogeeexd/widgets/contents/add_experience_block.dart';
import 'package:dogeeexd/widgets/contents/edit_about_block.dart';
import 'package:dogeeexd/widgets/contents/experience_block.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AboutMeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _titleTextStyle = Theme.of(context).textTheme.bodyText1;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(30),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                'About',
                style: _titleTextStyle,
              ),
              EditAboutBlock(),
            ],
          ),
          AboutBlock(),
          Row(
            children: [
              Text(
                'Experiences',
                style: _titleTextStyle,
              ),
              AddExperienceBlock(),
            ],
          ),
          ExperienceBlock(),
        ],
      ),
    );
  }
}