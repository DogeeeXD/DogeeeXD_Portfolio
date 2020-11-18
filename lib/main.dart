import 'package:dogeeexd/AppTheme.dart';

import 'package:dogeeexd/screens/landing_screen.dart';

import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // initialize Firebase
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  ThemeProvider currentTheme = ThemeProvider();

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('Theme changes');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedUser()),
        //ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'DogeeeXD',
        theme: currentTheme.currentTheme,
        // routes: {
        //   'landing': (context) => LandingScreen(),
        //   'main': (context) => MainScreen(),
        // },
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Something went wrong during initialization.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: Container(child: CircularProgressIndicator()));
            }
            return LandingScreen(currentTheme);
          },
        ),
      ),
    );
  }
}
