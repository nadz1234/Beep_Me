import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/User.dart';
import 'package:beep_me_ix/Pages/Imperson.dart';
import 'package:beep_me_ix/Pages/IntermediatePage.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/authentication/loginPage.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? name = '';
  String? client = '';
  String? image = '';
  String user_token = "";

  @override
  void initState() {
    super.initState();
    getStoreShared();
  }

  Future<String> getStoreShared() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('user_name');
      client = pref.getString('ImpersonateClientName') ??
          pref.getString('user_client');
      image = pref.getString('user_image');
    });
    return '';
  }

  Future<String> getStoreSharedToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_token = pref.getString('bearer_token')!;
    });
    return '';
  }

  showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Revert'),
            content: Text('You have reverted'),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (IntermediatePage())));
                        /*   Navigator.of(context)
                            .popUntil((route) => route.isFirst);*/
                      },
                      child: Text('OK')),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // getStoreShared();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => (IntermediatePage())));
          },
        ),
        //Text(name!),

        backgroundColor: componentColor,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(name!,
                      style: TextStyle(
                        color: Color.fromARGB(255, 14, 226, 191),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(image!),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  client!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 14, 226, 191),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                RaisedButton(
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => (Imperson())));
                    /*  Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => (Imperson())));*/
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 32, 143, 115),
                            Color.fromARGB(255, 14, 226, 191)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints: const BoxConstraints(
                          maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Impersonate",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("ImpersonateClientName", "");
                    pref.setString("ImpersonateClientValue", "");
                    showAlertDialog();
                    /* Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (IntermediatePage())));*/
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 32, 143, 115),
                            Color.fromARGB(255, 14, 226, 191)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Revert",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => (LoginPage())));
                    // Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 32, 143, 115),
                            Color.fromARGB(255, 14, 226, 191)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints: const BoxConstraints(
                          maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: const Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
