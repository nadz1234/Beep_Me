import 'dart:convert';
import 'dart:io';
import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Pages/SelectSpecPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({Key? key}) : super(key: key);

  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  String data = '';
  List vehicleListLength = [];
  int? client = 0;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? clientId = "";
    String? memberId = pref.getString('user_memberID');
    int? memId = int.parse(memberId!);
    clientId = pref.getString('ImpersonateClientValue');

    Uri apiUrl = Uri.parse(
        "https://stockservice.e5.ix.co.za/api/v1.0/autotrader/pending/list/dart/" +
            clientId! +
            "/3");
    String? token = pref.getString('bearer_token');

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token!};

    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      data = res.body;
      setState(() {
        vehicleListLength = jsonDecode(data)['result']['list'];
        //print(vehicleListLength.length);
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
    final query = MediaQuery.of(context);
    getSharedPrefValues();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Vehicle List'),
        backgroundColor: componentColor,
      ),
      body: vehicleListLength.length == 0
          ? Container(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 31, 134, 112)),
                    backgroundColor: Colors.grey,
                  ),
                ])))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:
                  vehicleListLength == null ? 0 : vehicleListLength.length,
              itemBuilder: (BuildContext context, int index) {
                List<String> imgList = jsonDecode(data)['result']['list'][index]
                        ['image']
                    .toString()
                    .split(",");

                var vehicleSpecId =
                    jsonDecode(data)['result']['list'][index]['vehicleStockID'];

                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  (SelectSpecPage(vehicleSpecId, imgList))));
                    },
                    child: Card(
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        child: MediaQuery(
                          data: query.copyWith(textScaleFactor: 1.25),
                          child: Row(
                            children: [
                              Image.network(
                                imgList.first,
                                fit: BoxFit.fill,
                                width: 100,
                                height: 450,
                                alignment: Alignment.center,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 260,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 0, 0),
                                      child: Text(
                                        jsonDecode(data)['result']['list']
                                            [index]['friendlyName'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: componentColor),
                                        overflow: TextOverflow.fade,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 260,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 0, 0),
                                      child: Text(
                                        jsonDecode(data)['result']['list']
                                            [index]['stockCode'],
                                        style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            color: componentColor),
                                        overflow: TextOverflow.fade,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
