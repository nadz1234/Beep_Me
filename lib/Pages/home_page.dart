import 'dart:convert';
import 'dart:io';

import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/User.dart';
import 'package:beep_me_ix/Pages/ImagePage.dart';
import 'package:beep_me_ix/Pages/SelectSpecPage.dart';
import 'package:beep_me_ix/Pages/VehicleListPage.dart';
import 'package:beep_me_ix/Pages/VehicleMissingImageListPage.dart';
import 'package:beep_me_ix/Pages/barcodeScanner.dart';
import 'package:beep_me_ix/Pages/user_page.dart';
import 'package:beep_me_ix/SecureStorage/user_storage.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beep_me_ix/authentication/globals.dart' as globals;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserSecureStorage secureStorage = UserSecureStorage();
  late EasyRefreshController _controller;
  String? fcmToken = '';
  String? user_token = '';
  String? token = '';
  int? memId = 0;
  String dataPending = '';
  int pendingVehicle = 0;
  int pendingImagesREeq = 0;
  int countVehicle = 0;
  int? client = 0;
  int _count = 20;
  // late FirebaseMessaging firebaseMessaging;

  getPendingVehicleNumber(int ClientId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(
        "https://stockservice.e5.ix.co.za/api/v1.0/autotrader/pending/" +
            ClientId.toString());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      //'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      dataPending = res.body;
      pendingVehicle =
          jsonDecode(dataPending)['result']['pendingVehicles'] ?? 0;

      setState(() {});
    } else {
      throw 'unable to load vehicles';
    }
  }

  getMissingPhotoNumber(int ClientId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(
        "https://stock.service.qa.ix.co.za/api/v1.0/missingimages/count");

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      'content-Type': 'application/json'
    };

    Map<String, dynamic> bodyRes = {
      "DealerID": ClientId.toString(),
    };

    var jsonBod = jsonEncode(bodyRes);

    Response res = await http.post(apiUrl, body: jsonBod, headers: headers);

    if (res.statusCode == 200) {
      dataPending = res.body;
      if (dataPending.isNotEmpty) {
        setState(() {
          if (jsonDecode(dataPending)['result']['vehicleCount'] == 0) {
            countVehicle = 0;
          }

          if (jsonDecode(dataPending)['result']['imagesRequired'] == 0) {
            pendingImagesREeq = 0;
          }

          countVehicle = jsonDecode(dataPending)['result']['vehicleCount'] ?? 0;
          pendingImagesREeq =
              jsonDecode(dataPending)['result']['imagesRequired'] ?? 0;
        });
      }

      print('unable to load vehicles');
    }
  }

  int? pendingVehicleNumber = 0;
  setUserPreference(
      String? token,
      String? name,
      String? image,
      String? client,
      int? clientID,
      int? memberID,
      bool? impersonating,
      bool? administrator) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //sharedPreferences.setString("bearer_token", token!);
    UserSecureStorage.setUserImage(image!);
    UserSecureStorage.setUserClient(client!);
    UserSecureStorage.setUserClientId(clientID.toString());
    UserSecureStorage.setUserMemberId(memberID.toString());
    UserSecureStorage.setUserImpersonating(impersonating.toString());
    UserSecureStorage.setUserAdministrator(administrator.toString());
    UserSecureStorage.setUserFcmToken(fcmToken.toString());

    sharedPreferences.setString("user_name", name!);
    sharedPreferences.setString("user_image", image);
    sharedPreferences.setString("user_client", client);
    sharedPreferences.setString("user_clientID", clientID.toString());
    sharedPreferences.setString("user_memberID", memberID.toString());
    sharedPreferences.setString("user_isImpersonating", memberID.toString());
    sharedPreferences.setString(
        "user_isAdministrator", administrator.toString());
  }

  refreshPageState() async {
    await Future.delayed(Duration(seconds: 2), () {
      // print('onRefresh');
      setState(() {
        _count = 5;
      });
      _controller.resetLoadState();
    });
  }

  getTokenForMessage() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value;
      });
    });
    //fcmToken = (await firebaseMessaging.getToken())!;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Vehicles"),
      content: Text("No vehicles currently require spec IDs."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogPhoto(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Vehicles"),
      content: Text("No vehicles currently require photos."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future init() async {
    final userToken = await UserSecureStorage.getBearertoken();

    setState(() {
      user_token = userToken;
    });
  }

  Future getSharedPrefValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_token = pref.getString('bearer_token') ?? "";
      client = int.parse(pref.getString("ImpersonateClientValue").toString());
    });
    return '';
  }

  @override
  void initState() {
    getTokenForMessage();
  }

  @override
  Widget build(BuildContext context) {
    //  refreshPageState();
    getSharedPrefValues();
    getTokenForMessage();
    init();
    if (client != 0) {
      setState(() {
        getPendingVehicleNumber(client!);
        getMissingPhotoNumber(client!);
      });
    }

    BaseApi().registerDeviceFcmToken(memId.toString(), fcmToken!);

    var bobo = BaseApi().getUserInformation();
    var we = bobo.then((value) {
      setState(() {
        memId = value.result!.memberId;
      });

      setUserPreference(
          globals.currentToken?.accessToken,
          value.result!.name,
          value.result!.image,
          value.result!.client,
          value.result!.clientId,
          memId,
          value.result!.impersonating,
          value.result!.administrator);
    });
//94642

    //getSharedPrefValues();

    /* var vehicleNumber = vehicle.then((value) {
      pendingVehicleNumber = value.result.pendingVehicles;
    });*/

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: componentColor,
        actions: [
          Row(
            children: [
              FlatButton.icon(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: Text(
                  '',
                ),
                onPressed: () async {
                  //  FirestoreService().postUserData();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => (UserPage())));
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Card(
                    elevation: 1.0,
                    color: Colors.transparent,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 1, 0),
                            child: Image.asset(
                              'Images/Bobo.png',
                              width: 370,
                              height: 150.0,
                            ),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      if (pendingVehicle == 0) {
                        showAlertDialog(context);
                      } else {
                        /*    Navigator.push(context,
                         MaterialPageRoute(builder: (context) => NewOrderPage()));*/
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if (pendingVehicle == 0) {
                          showAlertDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VehicleListPage()));
                        }
                      },
                      child: Card(
                        color: cardColor,
                        elevation: 7.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),

                        //child: ListTile(

                        child: Container(
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.bookmark_add_rounded),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Spec IDs Required",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: componentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        pendingVehicle.toString(),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "You use MM codes. Auto Trader sometimes has multiple spec IDs per MM code. Please select spec IDs so that these adverts can be activated for you.",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      if (countVehicle == 0) {
                        showAlertDialogPhoto(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MissingImageListPage(pendingImagesREeq)));
                      }
                    },
                    child: Card(
                      color: cardColor,
                      elevation: 7.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),

                      //child: ListTile(
                      //    onTap: (){},
                      child: Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.camera_alt_outlined),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Missing Vehicle Photos",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: componentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      countVehicle.toString(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "These vehicles have less than $pendingImagesREeq photo/s, which is the minimum prescribed by you for your business.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          )),
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
