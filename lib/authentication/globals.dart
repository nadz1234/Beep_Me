// TODO Implement this library.

import 'package:beep_me_ix/Models/bearer_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

BearerToken? currentToken;

class Globe {
  static SharedPreferences? localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
