import 'dart:convert';
import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/AccessToken.dart';
import 'package:beep_me_ix/Models/GoogleSignInApi.dart';
import 'package:beep_me_ix/Models/LoginResult.dart';
import 'package:beep_me_ix/Pages/ForgotPassword.dart';
import 'package:beep_me_ix/SecureStorage/user_storage.dart';
import 'package:beep_me_ix/authentication/globals.dart' as globals;
import 'package:beep_me_ix/Models/bearer_token.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  String username = "";
  String password = "";
  late GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  int _tokenTypeID = 0;
  String _tokenValue = '';

  final GoogleSignIn _googleSignInN = GoogleSignIn(scopes: ['email']);

  GoogleSignInAccount? _currentUser;
  String tok = "";

  showSnackError() {
    final snackbar = new SnackBar(
        content: new Text("Error, please contact support"),
        duration: new Duration(seconds: 4),
        backgroundColor: Colors.red);

    _scaffKey.currentState!.showSnackBar(snackbar);
  }

  void _googleLoginPressed(BuildContext context) {
    getGoogleToken().then((token) {
      if (token == null) {
        ///TODO::: Proper Message

        return;
      }
      _postLogin(context, '\$\$FlutterOneLogin_2', token.id, () {
        setState(() {
          _tokenTypeID = 2;
          _tokenValue = token.id;
        });
      });
    });
  }

  void _postLogin(BuildContext context, String username, String password,
      VoidCallback emptyResponse) {
    getToken(username, password).then((val) {
      if (val.accessToken?.isEmpty ?? true) {
        emptyResponse();
        return;
      }

      globals.currentToken = val;
    });
  }

  Future<GoogleSignInAccount?> getGoogleToken() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? result = await _googleSignIn.signIn();
    if (result == null) {
      return null;
    }
    return result;
  }

  /*Future<AccessToken?> getFacebookToken() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      return result.accessToken;
    }
    return null;
  }*/

  Future<BearerToken> getToken(String username, String password) async {
    final jsonData =
        await BaseApi.post('auth.services.ix.co.za', '/token', body: {
      // we can move the base url to another file
      'username': username,
      'password': password,
      'grant_type': 'password',
      'source': 'Smart Manager 2.0',
      'client_id': '099153c2625149bc8ecb3e85e03f0022'
    });
    //response.body);

    BearerToken token = BearerToken.fromJson(jsonData);
    return token;
  }

  Future signInWithGoogle() async {
    await GoogleSignInApi.loginGoogle();
  }

  @override
  void initState() {
    _googleSignInN.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });

    _googleSignInN.signInSilently();

    super.initState();
  }

  Future<void> signIn() async {
    try {
      await _googleSignInN.signIn();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      // print(user!.email.toString());
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffKey,
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment(-1, -1),
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 51, 0, 0),
                              child: Image.asset(
                                'Images/BM_icon_white.png',
                                width: 80,
                                height: 47.0,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                              child: Image.asset(
                                'Images/BM_name_white.png',
                                width: 250,
                                height: 75.0,
                              ),
                            ),
                            //  VerticalText(),
                            //  TextLogin(),
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                  child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: "Enter Username",
                          fillColor: Color.fromARGB(255, 37, 37, 37),
                          filled: true,

                          //fillColor: Colors.green
                        ),
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                        keyboardType: TextInputType.emailAddress,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      obscureText: true,
                      decoration: new InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Enter Password",
                        fillColor: Color.fromARGB(255, 37, 37, 37),
                        filled: true,

                        //fillColor: Colors.green
                      ),
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 10),
                      child: Container(
                          child: Icon(
                        Icons.add_task_outlined,
                        color: Color.fromARGB(255, 31, 134, 112),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 70),
                      child: Container(
                          child: Text(
                        'Remember me',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, right: 50),
                      child: Container(
                        width: 100,
                        child: RaisedButton(
                            color: Color.fromARGB(255, 31, 134, 112),
                            onPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              getToken(username, password).then((value) {
                                // change this to username,password
                                if (value.accessToken?.isEmpty ?? true) {
                                  showSnackError();
                                } else {
                                  UserSecureStorage.setUsername(username);
                                  UserSecureStorage.setPassword(password);
                                  UserSecureStorage.setBearertoken(
                                      value.accessToken.toString());

                                  sharedPreferences.setString(
                                      "username", username);
                                  sharedPreferences.setString(
                                      "password", password);
                                  sharedPreferences.setString("bearer_token",
                                      value.accessToken.toString());

                                  if (username.isEmpty || password.isEmpty) {
                                    showSnackError();
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.lock),
                                Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 150, 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Forgot password ?',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage()));
                              }),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Color.fromARGB(255, 54, 54, 54),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        signIn();
                        signInWithGoogle();
                        _googleLoginPressed(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));

                        /* _googleSignIn.signIn().then((userDetails) {
                          setState(() {
                            _userObj = userDetails!;
                            _userObj.authentication.then((googleValue) {
                              //  print('xxx  ' + googleValue.idToken.toString());
                              tok = googleValue.idToken.toString();
                              sharedPreferences.setString("bearer_token", tok);
                            });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          });
                        });*/
                      },
                      child: const Text(
                        'Login with Google',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
