import 'dart:convert';
import 'dart:io';

import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Pages/enlargeImag.dart';
import 'package:beep_me_ix/Pages/home_page.dart';
import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectSpecPage extends StatefulWidget {
  int vehicleSpecId = 0;
  List<String> imageList = [];

  SelectSpecPage(this.vehicleSpecId, this.imageList);

  @override
  _SelectSpecPageState createState() => _SelectSpecPageState();
}

class _SelectSpecPageState extends State<SelectSpecPage> {
  String friendlyName = '';
  double price = 0.00;
  int year = 0;
  String reg = '';
  String color = '';
  int mileage = 0;
  String meadCode = '';
  String stockCode = '';
  String vin = '';
  String pendingSince = '';
  String data = '';
  int queueId = 0;
  var vehicle_length;
  int optionVehicleSelected = 0;
  Color cardBackgroundColor = Colors.white;
  int selectedIndex = 0;
  int radio_val_select = -1;

  void changeColor(Color changeToColor) {
    setState(() {
      cardBackgroundColor = changeToColor;
    });
  }

  @override
  void initState() {
    widget.vehicleSpecId.toString();
    getVehicleSpecData();
    super.initState();
  }

  showMessage(int ind, int que, int vehicleId) {
    int option = ind + 1;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Vehicle Spec Id'),
            content: Text('Are you sure you want to save this vehicle'),
            actions: [
              Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text("Cancel")),
                  FlatButton(
                      onPressed: () {
                        BaseApi().saveSpecToServer(que, option, vehicleId);
                        Navigator.pop(ctx);
                      },
                      child: Text("Save"))
                ],
              )
            ],
          );
        });
  }

  void getVehicleSpecData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Uri apiUrl = Uri.parse(
        "https://stockservice.e5.ix.co.za/api/v1.0/autotrader/spec/" +
            widget.vehicleSpecId.toString());
    String? token = pref.getString('bearer_token');

    final headers = {HttpHeaders.authorizationHeader: "Bearer " + token!};

    Response res = await http.get(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      data = res.body;
      //  setState(() {
      vehicle_length = jsonDecode(data)['result']['specs'];
      //    print(vehicle_length.length);
      // });
    } else
      throw Exception("Unable to get vehicle list");
  }

  setSelectedRadio(var val) {
    setState(() {
      radio_val_select = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var vehicle =
        BaseApi().getDetailedVehicleInfo(widget.vehicleSpecId.toString());

    var veh = vehicle.then((vehicleSPecs) {
      setState(() {
        friendlyName = vehicleSPecs.result.friendlyName;
        queueId = vehicleSPecs.result.queueId;
        price = vehicleSPecs.result.price;
        year = vehicleSPecs.result.year;
        reg = vehicleSPecs.result.reg;
        color = vehicleSPecs.result.colour;
        mileage = vehicleSPecs.result.mileage;
        meadCode = vehicleSPecs.result.meadCode;
        stockCode = vehicleSPecs.result.stockCode;
        vin = vehicleSPecs.result.vin;
        pendingSince = vehicleSPecs.result.pendingSince;
      });
    });
    //   getVehicleSpecData();
    return Scaffold(
      bottomSheet: FlatButton(
        onPressed: () {
          BaseApi().saveSpecToServer(
              optionVehicleSelected, queueId, widget.vehicleSpecId);
        },
        child: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        color: componentColor,
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Select a Spec ID'),
        backgroundColor: componentColor,
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  color: Colors.grey[400],
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 4, 0, 18),
                                  child: Text(
                                    year.toString() + " ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: componentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 0, 18),
                              child: Container(
                                width: 300,
                                child: Text(
                                  friendlyName,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: componentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 0, 18),
                          child: Text(
                            "R " + price.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: componentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        /*Row(
                          children: <Widget>[*/
                        GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.imageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => (EnlargeImage(
                                              widget.imageList[index])))),
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridTile(
                                      child: Hero(
                                    tag: 'vehimg',
                                    child: Image.network(
                                      widget.imageList[index],
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  )),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Stock #" + stockCode + "  |",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      //  fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Mileage #" + mileage.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    //  fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "Reg " + reg.toString() + "  |",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      //  fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Vin " + vin.toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    //    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Color " + color.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Pending since " + pendingSince,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  //  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Please select and save correct Spec ID (variant)-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Scrollbar(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: vehicle_length == null
                                      ? 0
                                      : vehicle_length.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int optionVehicle = index + 1;

                                    return GestureDetector(
                                      onTap: (() {
                                        setSelectedRadio(index + 1);
                                        // changeColor(Colors.red);
                                        setState(() {
                                          optionVehicleSelected = index + 1;
                                        });
                                        /*showMessage(
                                            index, queueId, widget.vehicleSpecId);*/
                                      }),
                                      child: Card(
                                        elevation: 5.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          'Option : ' +
                                                              optionVehicle
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          'Spec ID : ' +
                                                              jsonDecode(data)['result']
                                                                              [
                                                                              'specs']
                                                                          [
                                                                          index]
                                                                      ['specID']
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                3, 4, 0, 0),
                                                        child: Text(
                                                          jsonDecode(data)['result']
                                                                          [
                                                                          'specs']
                                                                      [index]
                                                                  ['dateFrom'] +
                                                              " to " +
                                                              jsonDecode(data)[
                                                                          'result']
                                                                      ['specs'][
                                                                  index]['dateTo'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  3, 4, 20, 0),
                                                          child: Text(
                                                            jsonDecode(data)[
                                                                        'result']
                                                                    [
                                                                    'specs'][index]
                                                                [
                                                                'friendlyName'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color:
                                                                  componentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                3, 4, 125, 0),
                                                        child: Text(
                                                          "(" +
                                                              jsonDecode(data)[
                                                                          'result']
                                                                      [
                                                                      'specs'][index]
                                                                  [
                                                                  'transmssion'] +
                                                              ")",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color:
                                                                componentColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(50, 0, 0, 0),
                                                    child: Radio(
                                                        value: index + 1,
                                                        groupValue:
                                                            radio_val_select,
                                                        onChanged: (val) {}),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
