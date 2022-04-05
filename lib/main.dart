import 'package:beep_me_ix/Models/bearer_token.dart';
import 'package:beep_me_ix/Pages/IntermediatePage.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/authentication/loginPage.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beep_me_ix/authentication/globals.dart' as globals;
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }

  String? username = "";
  String? password = "";
  String? token = "";
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> showActionAlert({message: String}) async {
    return showDialog<void>(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PushDemo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  getUSerAppInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
      password = pref.getString("password");
      token = pref.getString('bearer_token')!;

      if (username == null || password == null || token == null) {
        token = "";
        username = "";
        password = "";
      }
    });
    return '';
  }

  getTokenNew() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getToken(username!, password!).then((value) {
      // change this to username,password
      if (value.accessToken?.isEmpty ?? true) {
        return;
      } else {
        sharedPreferences.setString(
            "bearer_token", value.accessToken.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getUSerAppInfo();
    if (username!.isNotEmpty && password!.isNotEmpty) {
      getTokenNew();
    }

    if (username == "" || password == "") {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginPage());
    } else {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: IntermediatePage());
    }
  }
}
