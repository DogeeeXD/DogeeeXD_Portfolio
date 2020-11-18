import 'package:dogeeexd/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  bool checkEmail = false;
  bool emailSent = false;
  final _authService = AuthService();
  //String _errMessage;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    //final _authService = AuthService();

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authService.loginUser(context, email, password).catchError((err) {
          print(err);
          setState(() {
            _isLoading = false;
            //_errMessage = err.toString();
          });
          showDialog(
            context: context,
            child: AlertDialog(
              title: Text('An error occured'),
              content: Text(err),
            ),
          );
        }).whenComplete(() {
          _authService.checkEmailVerified().listen((event) {
            //print('event: $event');
            if (event == true) {
              setState(() {
                _isLoading = false;
                checkEmail = false;
                Navigator.pop(context);
              });
            } else if (event == false) {
              setState(() {
                checkEmail = true;
              });
            }
          });
        });
      } else {
        _authService
            .createUser(context, email, password, username)
            .whenComplete(() {
          _authService.checkEmailVerified().listen((event) {
            //print('event: $event');
            if (event == true) {
              setState(() {
                _isLoading = false;
                checkEmail = false;
                Navigator.pop(context);
              });
            } else if (event == false) {
              setState(() {
                checkEmail = true;
              });
            }
          });
        });
      }
    } catch (err) {
      print(err.toString());
      // setState(() {
      //   _isLoading = false;
      //   _errMessage = err.toString();
      // });
      // showDialog(
      //   context: context,
      //   child: AlertDialog(
      //     title: Text('An error occured'),
      //     content: Text(_errMessage),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkEmail
        ? Dialog(
            backgroundColor: Color(0xFFf5f6fa),
            child: Container(
              width: 800,
              height: 500,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Waiting for email verification.'),
                  emailSent
                      ? Text('Email is sent.')
                      : RaisedButton(
                          child: Text('Resend verification email.'),
                          onPressed: () {
                            _authService.sendVerificationEmail();
                            setState(() {
                              emailSent = true;
                            });
                          },
                        ),
                ],
              ),
            ),
          )
        : Dialog(
            backgroundColor: Color(0xFFf5f6fa),
            child: Container(
              width: 800,
              height: 500,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AuthForm(
                        _isLoading,
                        _submitAuthForm,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(Icons.cancel_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class AuthForm extends StatefulWidget {
  AuthForm(
    this.isLoading,
    this.submitFn,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController(text: '');

  final _emailController = TextEditingController(text: '');

  final _passwordController = TextEditingController(text: '');

  var _isLogin = true;

  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    // Closes soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword,
        _userName.trim(),
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _maxWidth = 500.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? 'Login' : 'Sign-up',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isLogin)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelText: 'Username',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
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
                      controller: _usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      prefixIcon: Icon(Icons.mail_rounded),
                      labelText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
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
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      prefixIcon: Icon(Icons.lock_rounded),
                      labelText: 'Password',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
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
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                ),
                if (_isLogin)
                  InkWell(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Theme.of(context).highlightColor),
                    ),
                    onTap: () {
                      String _email;
                      bool _emailSent;
                      // Go to reset password
                      showDialog(
                        context: context,
                        child: Dialog(
                          backgroundColor: Color(0xFFf5f6fa),
                          child: Container(
                            width: 800,
                            height: 500,
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: _maxWidth),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Enter your email so we can send a password reset link.'),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        prefixIcon: Icon(Icons.mail_rounded),
                                        labelText: 'Email',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).accentColor,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).errorColor,
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).errorColor,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _email = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: RaisedButton(
                                      child: Text('Send reset link'),
                                      onPressed: () async {
                                        await AuthService()
                                            .resetPassword(_email);
                                        setState(() {
                                          _emailSent = true;
                                        });
                                      },
                                    ),
                                  ),
                                  _emailSent
                                      ? Text(
                                          'Reset link sent. Please check your email.')
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (widget.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (!widget.isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign-up'),
                      onPressed: _trySubmit,
                    ),
                  ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text('- OR -'),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(_isLogin ? 'Login with' : 'Sign-up with'),
                // SizedBox(
                //   height: 15,
                // ),
                // RawMaterialButton(
                //   onPressed: () {},
                //   elevation: 3.0,
                //   fillColor: Colors.white,
                //   child: Image(
                //     width: 30,
                //     height: 30,
                //     fit: BoxFit.contain,
                //     image: AssetImage('assets/icons/google_logo.png'),
                //   ),
                //   padding: EdgeInsets.all(8.0),
                //   shape: CircleBorder(),
                // ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin ? r"Don't have an account?  " : ''),
                    InkWell(
                      child: Text(
                        _isLogin ? 'Sign-up' : 'I already have an account',
                        style:
                            TextStyle(color: Theme.of(context).highlightColor),
                      ),
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
