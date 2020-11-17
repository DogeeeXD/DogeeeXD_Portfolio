// Landing Screen
// The first screen visitors see
// Show a list/grid of user portfolios
// Every item has onHover floating effects
// Include Login/SignUp button

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dogeeexd/screens/aboutme_screen.dart';
import 'package:dogeeexd/screens/auth_screen.dart';
import 'package:dogeeexd/screens/home_screen.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/widgets/breathing_background.dart';
import 'package:dogeeexd/widgets/email_button.dart';
import 'package:dogeeexd/widgets/responsive_widget.dart';
import 'package:dogeeexd/widgets/wave_curve.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageList = [
    {
      'screen': HomeScreen(),
      'name': 'Home',
    },
    {
      'screen': AboutMeScreen(),
      'name': 'About Me',
    },
    // {
    //   'screen': ProjectsScreen(),
    //   'name': 'Projects',
    // },
    // {
    //   'screen': FunScreen(),
    //   'name': 'Fun',
    // },
  ];

  final _pageController = PageController();

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<SelectedUser>(context).userId;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: ResponsiveWidget.isSmallScreen(context)
          ? ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Drawer(
                child: ListView.builder(
                    itemCount: _pageList.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(
                          _pageList[index]['name'],
                          style: _selectedPage == index
                              ? TextStyle(color: Theme.of(context).primaryColor)
                              : null,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                          setState(() {
                            _selectedPage = index;
                          });
                        },
                      );
                    }),
              ),
            )
          : null,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(30.0),
                child: GestureDetector(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.data()['username']);
                        }
                        return Text('');
                      }),
                  // onLongPress: () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AuthScreen();
                  //       });
                  // },
                ),
              ),
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.all(30.0),
                child: GestureDetector(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.data()['username']);
                        }
                        return Text('');
                      }),
                  // onLongPress: () {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         return AuthScreen();
                  //       });
                  // },
                ),
              ),
              actions: [
                ...List.generate(_pageList.length, (index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: FlatButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                        setState(() {
                          _selectedPage = index;
                        });
                      },
                      child: Text(
                        _pageList[index]['name'],
                        style: _selectedPage == index
                            ? TextStyle(color: Theme.of(context).primaryColor)
                            : null,
                      ),
                    ),
                  );
                }),
                StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FlatButton(
                          child: Text(
                            'Logout',
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                        );
                      }
                      return Container();
                    }),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
      floatingActionButton: EmailButton(),
      body: Stack(
        children: [
          BreathingBackground(),
          WaveCurve(),
          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 80),
            child: PageView(
              scrollDirection: ResponsiveWidget.isSmallScreen(context)
                  ? Axis.vertical
                  : Axis.horizontal,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ...List.generate(
                    _pageList.length, (index) => _pageList[index]['screen'])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
