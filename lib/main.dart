import 'package:dogeeexd/AppTheme.dart';
import 'package:dogeeexd/screens/aboutme_screen.dart';
import 'package:dogeeexd/screens/landing_screen.dart';
import 'package:dogeeexd/screens/main_screen.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // initialize Firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedUser()),
      ],
      child: MaterialApp(
        title: 'DogeeeXD',
        theme: AppTheme.lightTheme,
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
            return LandingScreen();
          },
        ),
      ),
    );
  }
}
