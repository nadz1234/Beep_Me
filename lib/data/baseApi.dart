import 'dart:io';

import 'package:beep_me_ix/Models/ApiResult.dart';
import 'package:beep_me_ix/Models/CurrentImage.dart';
import 'package:beep_me_ix/Models/PendingVehicleCount.dart';
import 'package:beep_me_ix/Models/User.dart';
import 'package:beep_me_ix/Models/VehicleMissingImgInfo.dart';
import 'package:beep_me_ix/Models/VehicleSpecDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beep_me_ix/authentication/globals.dart' as globals;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  String coreApi = 'https://coreapi.e5.ix.co.za/';
  String stockApi = 'https://stockservice.e5.ix.co.za/';
  String qaApi = 'https://stock.service.qa.ix.co.za/';

  static Future<Map<String, dynamic>?> post(String host, String method,
      {Object? body, bool secure = true}) async {
    final response = await http.post(
        secure ? Uri.https(host, method) : Uri.http(host, method),
        headers: {'contentType': 'application/x-www-form-urlencoded'},
        body: body);
    final jsonData = json.decode(response.body);
    return jsonData;
  }

//94642
  Future<Member> getUserInformation() async {
    Uri apiUrl = Uri.parse(coreApi + "api/v1.0/active/member/info/en");
    String? token = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token};
    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      var bob = Member.fromMap(jsonDecode(res.body));

      return bob;
    } else {
      throw 'unable to load users';
    }
  }

  /*Future<PendingVehicleCount> getNumberSpecIds() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? clientImpersonateId = '0';

    if (pref.getString('ImpersonateClientValue') != null) {
      clientImpersonateId = pref.getString('ImpersonateClientValue');
    } else {
      clientImpersonateId = '0';
    }

    Uri apiUrl = Uri.parse(stockApi + "api/v1.0/autotrader/pending/435");
    String? token = "";

    token = pref.getString('bearer_token')!;

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token};
    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      var bob = PendingVehicleCount.fromMap(jsonDecode(res.body));

      return bob;
    } else {
      throw 'unable to load users';
    }
  }*/

//13437 - gys pitzer motors silver lakes
  /*Future<Member> getPendingVehicleInfo() async {
    String? token = "";
    String? clientId = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;
    clientId = pref.getString('ImpersonateClientValue');
    Uri apiUrl = Uri.parse(
        stockApi + "api/v1.0/autotrader/pending/list/dart/" + "435" + "/3");

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token};
    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      return Member.fromMap(jsonDecode(res.body));
    } else {
      throw 'unable to load users';
    }
  }*/

  Future<Spec> getDetailedVehicleInfo(String vehicleId) async {
    String? token = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(stockApi + "api/v1.0/autotrader/spec/" + vehicleId);

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token};
    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      return Spec.fromJson(jsonDecode(res.body));
    } else {
      throw 'unable to load vehicles';
    }
  }

  Future<Spec> getDetailedVehicleInfoImages(String vehicleId) async {
    String? token = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(qaApi + "api/v1.0/missingimages/specs/" + vehicleId);

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.post(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      return Spec.fromJson(jsonDecode(res.body));
    } else {
      throw 'unable to load vehicles';
    }
  }

  Future<Map<String, dynamic>?> imperson() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? memberId = pref.getString('user_memberID');
    int? memId = int.parse(memberId!);

    Uri apiUrl = Uri.parse(
        coreApi + "api/v1.0/client/impersonate/dart/" + memId.toString());
    String? token = "";

    token = pref.getString('bearer_token')!;

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token};
    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      return _processResults(jsonDecode(res.body));
    } else {
      throw 'unable to load clients';
    }
  }

  static Future<Map<String, dynamic>?> _processResults(
      final dynamic jsonData) async {
    ApiResult? result = ApiResult.fromJson(jsonData);
    if (result.status != "ok") {
      throw (result.message ?? '[Unknown API Error]');
    }
    if (result.result != null) {
      result.result!['identity'] = result.identity;
      result.result!['total'] = result.total;
    }
    return result.result;
  }

  static Future<Map<String, dynamic>?> getWithToken(String api) async {
    String? token = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    final response = await http.get(Uri.http('', api),
        headers: {'Authorization': 'Bearer ' + (token), 'accept': '*/*'});
    return _processResults(json.decode(response.body));
  }

  void registerDeviceFcmToken(String memId, String fcmToken) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://notificationapi.ix.co.za/api/device'));
    request.body = json.encode({
      "memberDeviceID": 0,
      "platformID": 1,
      "memberID": memId.toString(),
      "token": fcmToken.toString(),
      "isActive": true
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  /*
  *********************************************************************************************************************************************
  These are the actual post methods to database
  *********************************************************************************************************************************************
  */

  saveImagesToServer(int vehicleId, String Imagename, int priorityVal,
      String base64Img) async {
    String token = "";
    String user_name = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;
    user_name = pref.getString('user_name')!;

    Uri apiUrl = Uri.parse(qaApi + "api/v1.0/stock/media");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      'content-Type': 'application/json'
    };

    Map<String, dynamic> bodyRes = {
      "MediaTypeID": 1,
      "VehicleStockID": vehicleId,
      "Title": Imagename,
      "Source": "BeepMe",
      "Priority": priorityVal,
      "Orientation": 1,
      "ImageType": 1,
      "Filename": Imagename,
      "Image": base64Img,
      "Username": user_name,
      "imageID": 0,
      "newPriority": 0
    };

    var jsonBod = jsonEncode(bodyRes);

    Response res = await http.post(apiUrl, body: jsonBod, headers: headers);

    if (res.statusCode == 200) {
      // return CurrImage.fromJson(jsonDecode(res.body));
      //  data = res.body;

    } else {
      throw 'unable to load vehicles';
    }
    jsonBod = '';
  }

  saveSpecToServer(int queueID, int itemSelected, int vehicleStockID) async {
    String? token = "";

    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(stockApi +
        "api/v1.0/autotrader/spec" +
        queueID.toString() +
        "/" +
        itemSelected.toString() +
        "/" +
        vehicleStockID.toString());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      'content-Type': 'application/json'
    };

    Response res = await http.post(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      //  data = res.body;

    } else {
      throw 'unable to load vehicles';
    }
  }

  forgotPassword(String username) async {
    String token = "";
    String user_name = "";
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;
    user_name = pref.getString('user_name')!;

    Uri apiUrl = Uri.parse(coreApi + "api/v1.0/active/member/forgot");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      'content-Type': 'application/json'
    };

    Map<String, dynamic> bodyRes = {"username": username};

    var jsonBod = jsonEncode(bodyRes);

    Response res = await http.post(apiUrl, body: jsonBod, headers: headers);

    if (res.statusCode == 200) {
      // return CurrImage.fromJson(jsonDecode(res.body));
      //  data = res.body;

    } else {
      throw 'unable to assist';
    }
    jsonBod = '';
  }
}
