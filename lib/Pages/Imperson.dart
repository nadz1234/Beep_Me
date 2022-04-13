import 'dart:convert';
import 'dart:io';

import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/ApiResult.dart';
import 'package:beep_me_ix/Models/Impersonate.dart';
import 'package:beep_me_ix/Pages/IntermediatePage.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/Pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Imperson extends StatefulWidget {
  const Imperson({Key? key}) : super(key: key);

  @override
  _ImpersonState createState() => _ImpersonState();
}

class _ImpersonState extends State<Imperson> {
  TextEditingController txtQuery = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();

  String searchString = '';
  List<ListImpersonElement> imp = [];
  List<ListImpersonElement> searchimp = [];

  @override
  void initState() {
    imp = searchimp;
    getData();
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<ListImpersonElement> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = imp;
    } else {
      results = imp
          .where((user) =>
              user.text.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchimp = results;
    });
  }

  showAlertDialog(String clientName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Impersonate'),
            content: Text('You have impersonated $clientName'),
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

  Future<bool> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? memberId = pref.getString('user_memberID');
    int? memId = int.parse(memberId!);

    Uri apiUrl = Uri.parse(
        "https://coreapi.e5.ix.co.za/api/v1.0/client/impersonate/dart/" +
            memId.toString());
    String? token = pref.getString('bearer_token');

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token!};

    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      final result = impersonateFromJson(res.body);
      imp = result.result.list;
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: componentColor,
        title: Text("Impersonate"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => (UserPage())));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Color.fromARGB(255, 14, 226, 191)),
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  prefixIconColor: Color.fromARGB(255, 14, 226, 191),
                  labelText: 'Search',
                  suffixIconColor: Color.fromARGB(255, 14, 226, 191),
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 14, 226, 191)),
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
              child: searchimp.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        final impersonates = searchimp[index];

                        return InkWell(
                          child: ListTile(
                            title: Text(
                              impersonates.text,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 226, 191),
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              String client = '';
                              String ClientValue = '0';
                              client = impersonates.text;
                              ClientValue = impersonates.value;
                              // showAlertDialog(client);
                              pref.setString("ImpersonateClientName", client);
                              pref.setString("ImpersonateClientValue",
                                  ClientValue.toString());
                              showAlertDialog(client);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: componentColor),
                      itemCount: searchimp.length)
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final impersonates = imp[index];

                        return InkWell(
                          child: ListTile(
                            title: Text(
                              impersonates.text,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 14, 226, 191),
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              String client = '';
                              String ClientValue = '0';
                              client = impersonates.text;
                              ClientValue = impersonates.value;
                              // showAlertDialog(client);
                              setState(() {
                                pref.setString("ImpersonateClientName", client);
                                pref.setString("ImpersonateClientValue",
                                    ClientValue.toString());
                              });

                              showAlertDialog(client);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(color: componentColor),
                      itemCount: imp.length)),
        ],
      ),
    );
  }
}
