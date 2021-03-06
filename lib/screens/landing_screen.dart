import 'package:dogeeexd/screens/auth_screen.dart';
import 'package:dogeeexd/screens/main_screen.dart';
import 'package:dogeeexd/selected_user.dart';
import 'package:dogeeexd/services/search_service.dart';
import 'package:dogeeexd/theme_provider.dart';
import 'package:dogeeexd/widgets/breathing_background.dart';

import 'package:dogeeexd/widgets/user_card.dart';
import 'package:dogeeexd/widgets/verify_login.dart';
import 'package:dogeeexd/widgets/wave_curve.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogeeexd/extensions/hover_extensions.dart';

class LandingScreen extends StatefulWidget {
  final ThemeProvider currentTheme;

  LandingScreen(this.currentTheme);
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _filter = TextEditingController();
  bool _hasUser = false;
  String _userId;
  bool _isDarkMode = false;
  final _auth = FirebaseAuth.instance;

  Widget _buildUserCard() {
    if (_hasUser == false && _filter.text.isNotEmpty) {
      return Container(
          constraints: BoxConstraints(
            maxWidth: 800,
          ),
          child: Text('The username does not exists.'));
    } else if (_hasUser == true) {
      return UserCard(
        userId: _userId,
      );
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: 800,
      ),
    );
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          BreathingBackground(),
          WaveCurve(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create your own portfolio',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && _auth.currentUser.emailVerified) {
                        return Container(
                          width: 250,
                          child: RaisedButton(
                            child: Text('Go to your portfolio'),
                            onPressed: () {
                              //print(snapshot.data.uid);
                              // Set selectedUser
                              Provider.of<SelectedUser>(context, listen: false)
                                  .userId = snapshot.data.uid;

                              // Push to MainScreen
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                            },
                          ),
                        );
                      }
                      return Container(
                        width: 200,
                        child: RaisedButton(
                          child: Text('Start'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AuthScreen();
                              },
                              barrierDismissible: false,
                            ).then((value) {
                              // Rebuild LandingScreen so UI changes can be applied
                              setState(() {});
                            });
                          },
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Or'),
              ),
              Text('Enter username to search for existing portfolio'),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    maxHeight: 100,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      prefixIcon: Icon(Icons.search_rounded),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).errorColor,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).errorColor,
                          width: 1,
                        ),
                      ),
                    ),
                    controller: _filter,
                    onChanged: (value) async {
                      // pass _searchText to search and return a user card
                      await SearchService().searchUser(value).then((data) {
                        print(data);
                        _userId = data;
                        setState(() {
                          _hasUser = true;
                        });
                      }).catchError((err) {
                        print(err);
                        setState(() {
                          _hasUser = false;
                        });
                      });
                    },
                    onSubmitted: (value) async {
                      // pass _searchText to search and return a user card
                      await SearchService().searchUser(value).then((data) {
                        print(data);
                        _userId = data;
                        setState(() {
                          _hasUser = true;
                        });
                      }).catchError((err) {
                        print(err);
                        setState(() {
                          _hasUser = false;
                        });
                      });
                    },
                  ),
                ),
              ),
              // Switch(
              //   value: _isDarkMode,
              //   onChanged: (value) {
              //     setState(() {
              //       _isDarkMode = value;
              //       widget.currentTheme.setTheme(_isDarkMode);
              //       //Provider.of<ThemeProvider>(context).setTheme(_isDarkMode);
              //     });
              //   },
              // ),
              _buildUserCard(),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Creator's portfolio:"),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber[200],
                              blurRadius: 5,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text('DogeeeXD'),
                            //Text(userData['email']),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Set selectedUser
                        Provider.of<SelectedUser>(context, listen: false)
                            .userId = 'ALfxttpEMzY40Q9qWJFozVX9yd32';

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MainScreen()));
                      },
                    ).moveUpOnHover,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
