import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/CurrentImage.dart';
import 'package:beep_me_ix/Pages/VehicleMissingImageListPage.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/Widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drag_and_drop_gridview/drag.dart';
import 'package:drag_and_drop_gridview/gridorbiter.dart';
import 'package:flutter/services.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import '../data/baseApi.dart';

class OrderImagePriority extends StatefulWidget {
  int vehicleId;
  int numVehicles;

  OrderImagePriority(this.vehicleId, this.numVehicles);

  @override
  State<OrderImagePriority> createState() => _OrderImagePriorityState();
}

class _OrderImagePriorityState extends State<OrderImagePriority> {
  int variableSet = 0, variableSetHeader = 0;
  double? width;
  double? height;
  ScrollController? _scrollController;
  String? token = "";
  late EasyRefreshController _controller;
  int _count = 20;
  int vehId = 0;
  int? client = 0;

  String Api = 'https://stock.service.qa.ix.co.za/';
  String qaApi = 'https://stock.service.qa.ix.co.za/';
  List<CurrentVehImg> _currentDbImage = [];

  getCurrentImages(int vehicleId, int client1) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(
        qaApi + "api/v1.0/missingimages/CurrentImages/" + vehicleId.toString());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.post(apiUrl,
        body: {"DealerID": client1.toString()}, headers: headers);

    if (res.statusCode == 200) {
      final resultImg = currentVehicleImgFromJson(res.body);
      _currentDbImage = resultImg.result;

      return true;
    } else {
      throw 'unable to load vehicles';
    }
  }

  Future getSharedPrefValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      client = int.parse(pref.getString("ImpersonateClientValue").toString());
    });
    return '';
  }

  @override
  void initState() {
    getCurrentImages(widget.vehicleId, client!);
    _controller = EasyRefreshController();
    super.initState();
  }

  showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Priority'),
            content: Text('Images have been updated.'),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MissingImageListPage(
                                    widget.numVehicles))));
                      },
                      child: Text('Okay')),
                ],
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    refreshPageState();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    refreshPageState();
    getSharedPrefValues();
    // dispose();
    //   getCurrentImages(7459986);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: componentColor,
        title: Text('Update Priority'),
      ),
      body: Container(
        child: DragAndDropGridView(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 4.5,
          ),
          padding: EdgeInsets.all(20),
          itemBuilder: (context, index) => Card(
            elevation: 2,
            child: LayoutBuilder(builder: (context, costrains) {
              if (variableSet == 0) {
                height = costrains.maxHeight;
                width = costrains.maxWidth;
                variableSet++;
              }

              return Stack(children: <Widget>[
                GridTile(
                  child: Image.network(
                    _currentDbImage[index].blobUrl,
                    fit: BoxFit.cover,
                    height: height,
                    width: width,
                  ),
                ),
                /* Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _currentDbImage.removeAt(index);
                    },
                    child: Icon(Icons.delete,
                        color: Color.fromARGB(255, 228, 36, 23)),
                  ),
                ),*/
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 2, 0, 0),
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]);
            }),
          ),
          itemCount: _currentDbImage.length,
          onWillAccept: (oldIndex, newIndex) => true,
          onReorder: (oldIndex, newIndex) {
            // You can also implement on your own logic on reorderable

            int indexOfFirstItem =
                _currentDbImage.indexOf(_currentDbImage[oldIndex]);
            int indexOfSecondItem =
                _currentDbImage.indexOf(_currentDbImage[newIndex]);

            if (indexOfFirstItem > indexOfSecondItem) {
              for (int i = _currentDbImage.indexOf(_currentDbImage[oldIndex]);
                  i > _currentDbImage.indexOf(_currentDbImage[newIndex]);
                  i--) {
                var tmp = _currentDbImage[i - 1];
                _currentDbImage[i - 1] = _currentDbImage[i];
                _currentDbImage[i] = tmp;
              }
            } else {
              for (int i = _currentDbImage.indexOf(_currentDbImage[oldIndex]);
                  i < _currentDbImage.indexOf(_currentDbImage[newIndex]);
                  i++) {
                var tmp = _currentDbImage[i + 1];
                _currentDbImage[i + 1] = _currentDbImage[i];
                _currentDbImage[i] = tmp;
              }
            }
            //    setState(() {});
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 13, 139, 76),
        label: const Text('Save Images',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            )),
        onPressed: () async {
          var priority = -1;
          List vehiclesForpriority = [];

          int numOfImages = _currentDbImage.length;
          if (_currentDbImage.isNotEmpty) {
            for (int i = 0; i < _currentDbImage.length; i++) {
              priority++;
              numOfImages--;
              DialogBuilder(context).showLoadingIndicator('updating priority ');
              Uri apiUrl = Uri.parse(qaApi + "api/v1.0/stock/priority");

              Map<String, String> headers = {
                HttpHeaders.authorizationHeader: "Bearer " + token!,
                'content-Type': 'application/json'
              };

              Map<String, dynamic> bodyRes = {
                "VehicleStockID": widget.vehicleId,
                "imageID": _currentDbImage[i].blobUsedVehicleId,
                "newPriority": priority,
              };
              vehiclesForpriority.add(bodyRes);

              var jsonBod = jsonEncode(vehiclesForpriority);

              Response res =
                  await http.post(apiUrl, body: jsonBod, headers: headers);

              if (res.statusCode == 200) {
              } else {
                throw 'unable to load vehicles';
              }
              jsonBod = '';
              DialogBuilder(context).hideOpenDialog();
              if (numOfImages < 1) {
                showAlertDialog();
              }
            }
          } else {}
        },
      ),
    );
  }
}
