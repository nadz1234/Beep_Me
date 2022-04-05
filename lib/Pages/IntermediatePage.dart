import 'package:beep_me_ix/Models/bearer_token.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/authentication/loginPage.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beep_me_ix/authentication/globals.dart' as globals;

class IntermediatePage extends StatefulWidget {
  const IntermediatePage({Key? key}) : super(key: key);

  @override
  _IntermediatePageState createState() => _IntermediatePageState();
}

class _IntermediatePageState extends State<IntermediatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
