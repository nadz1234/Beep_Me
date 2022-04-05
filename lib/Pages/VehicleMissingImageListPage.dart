import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Pages/VehicleImageOptionsPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:beep_me_ix/Pages/SelectSpecPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MissingImageListPage extends StatefulWidget {
  int numVehicles;
  MissingImageListPage(this.numVehicles);

  @override
  State<MissingImageListPage> createState() => _MissingImageListPageState();
}

class _MissingImageListPageState extends State<MissingImageListPage> {
  String data = '';
  var vehicleListLength;
  int? client = 0;
  int numVeh = 0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? memberId = pref.getString('user_memberID');
    String? client = pref.getString('ImpersonateClientValue');
    int? memId = int.parse(memberId!);

    Uri apiUrl =
        Uri.parse("https://stock.service.qa.ix.co.za/api/v1.0/missingimages");
    String? token = pref.getString('bearer_token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.post(apiUrl,
        body: {"DealerID": client.toString()}, headers: headers);

    if (res.statusCode == 200) {
      data = res.body;
      setState(() {
        vehicleListLength = jsonDecode(data)['result'];
        print(vehicleListLength.length);
      });
    } else
      throw Exception("Unable to get vehicle list");
  }

  Future getSharedPrefValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      client = int.parse(pref.getString("ImpersonateClientValue").toString());
    });
    return '';
  }

  @override
  Widget build(BuildContext context) {
    numVeh = widget.numVehicles;
    getSharedPrefValues();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Missing Vehicle Photos'),
        backgroundColor: componentColor,
      ),
      body: ListView(children: <Widget>[
        Container(
          height: 100,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'These vehicles have less than $numVeh photos, being the minimum prescribed for your business. Click on the vehicle to add photos.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
        ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: vehicleListLength == null ? 0 : vehicleListLength.length,
            itemBuilder: (BuildContext context, int index) {
              String img = jsonDecode(data)['result'][index]['image'];

              var vehicleSpecId =
                  jsonDecode(data)['result'][index]['vehicleStockID'];

              var imgCount = jsonDecode(data)['result'][index]['imageCount'];
              var imgRequired =
                  jsonDecode(data)['result'][index]['imageRequired'];
              var totalimages = imgRequired + imgCount;

              int numberPhotosLeft = 0;
              numberPhotosLeft = totalimages - imgCount;

              return Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (VehicleImageOptions(
                                    vehicleSpecId,
                                    totalimages,
                                    imgRequired,
                                    imgCount,
                                    widget.numVehicles))));
                      },
                      child: Container(
                          child: Row(
                        children: <Widget>[
                          Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 450,
                            alignment: Alignment.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 250,
                                  child: Text(
                                    jsonDecode(data)['result'][index]
                                        ['friendlyName'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: componentColor),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(2, 2, 0, 0),
                                      child: Text('Photos '),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 0, 0),
                                      child: Text(
                                        imgCount.toString() +
                                            ' Need ' +
                                            numberPhotosLeft.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Stock # '),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(3, 0, 0, 0),
                                      child: Text(
                                        vehicleSpecId.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
                    color: cardColor,
                    elevation: 7.0,
                  ),
                ),
              );
            }),
      ]),
    );
  }
}
