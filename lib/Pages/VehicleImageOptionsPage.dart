// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:beep_me_ix/Components/colorConstants.dart';
import 'package:beep_me_ix/Models/CurrentImage.dart';
import 'package:beep_me_ix/Models/VehicleMissingImgInfo.dart';
import 'package:beep_me_ix/Pages/VehicleMissingImageListPage.dart';
import 'package:beep_me_ix/Pages/enlargeImag.dart';
import 'package:beep_me_ix/Pages/orderImagePriority.dart';
import 'package:beep_me_ix/Widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:beep_me_ix/data/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drag_and_drop_gridview/drag.dart';
import 'package:drag_and_drop_gridview/gridorbiter.dart';
import 'package:flutter/services.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class VehicleImageOptions extends StatefulWidget {
  var vehicleSpecId = 0;
  var imgReq = 0;
  var totalImg = 0;
  var missingImage = 0;
  var numVehicles = 0;

  VehicleImageOptions(this.vehicleSpecId, this.totalImg, this.imgReq,
      this.missingImage, this.numVehicles);

  @override
  State<VehicleImageOptions> createState() => _VehicleImageOptionsState();
}

class _VehicleImageOptionsState extends State<VehicleImageOptions> {
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
  String inStockDate = '';
  var currentImageCount = 0;
  DateTime loadDate = DateTime.now();
  List<String> CurrentImgUrl = [];
  int imagesneed = 0;
  int? pos;
  String base64string = '';
  ScrollController? _scrollController;
  String? token = "";
  File? imageFile;
  File? captureImage;
  String user_name = "";
  // new stuff
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  List<CurrentVehImg> _currentDbImage = [];
  int? client = 0;

  List<String> b64ImageList = [];
  bool _saveImageVisible = false;

  String Api = 'https://stock.service.qa.ix.co.za/';
  String qaApi = 'https://stock.service.qa.ix.co.za/';

  showAlertDialogMedia() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select'),
            content: Text('Please select method of selecting an image '),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        _pickImage();
                        Navigator.pop(context, false);
                      },
                      child: Text('Gallery')),
                  FlatButton(
                      onPressed: () {
                        _CaptureImage();
                        Navigator.pop(context, false);
                      },
                      child: Text('Camera')),
                ],
              )
            ],
          );
        });
  }

  showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Priority'),
            content: Text('Do you want to re-order the priority? '),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MissingImageListPage(
                                    widget.numVehicles))));
                        //Navigator.of(context).pop();
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (OrderImagePriority(
                                    widget.vehicleSpecId,
                                    widget.numVehicles))));
                      },
                      child: Text('Yes')),
                ],
              )
            ],
          );
        });
  }

  void getDetailedVehicleInfoImages(int vehicleId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;
    user_name = pref.getString('user_name')!;
    Uri apiUrl =
        Uri.parse(Api + "api/v1.0/missingimages/specs/" + vehicleId.toString());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.post(apiUrl, headers: headers);

    if (res.statusCode == 200) {
      data = res.body;
      setState(() {
        friendlyName = jsonDecode(data)['result']['friendlyName'];
        price = jsonDecode(data)['result']['price'];
        year = jsonDecode(data)['result']['year'];
        stockCode = jsonDecode(data)['result']['stockCode'];
        reg = jsonDecode(data)['result']['reg'];
        vin = jsonDecode(data)['result']['vin'];
        inStockDate = jsonDecode(data)['result']['loadDate'];
        var dateloaded = DateTime.parse(inStockDate);
        var dateNow = DateTime.now();
        var difference = dateNow.difference(dateloaded).inDays;
      });
    } else {
      throw 'unable to load vehicles';
    }
  }

  getCurrentImages(int vehicleId, int clientId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('bearer_token')!;

    Uri apiUrl = Uri.parse(
        qaApi + "api/v1.0/missingimages/CurrentImages/" + vehicleId.toString());

    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer " + token!,
      'contentType': 'application/x-www-form-urlencoded'
    };

    Response res = await http.post(apiUrl,
        body: {"DealerID": clientId.toString()}, headers: headers);

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
    // getDetailedVehicleInfoImages(7567627);
    _saveImageVisible = false;
    getDetailedVehicleInfoImages(widget.vehicleSpecId);
    getCurrentImages(widget.vehicleSpecId, client!);

    imagesneed = widget.totalImg - widget.missingImage;

    super.initState();
  }

  int variableSet = 0;

  double? width;
  double? height;

  convertCurrentToBase64(String imageUrl) async {
    http.Response resp = await http.get(Uri.parse(imageUrl));
    final bytes = resp.bodyBytes;
    // String yes = base64Encode(bytes);
    return (bytes != null ? base64Encode(bytes) : null);
  }

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    getSharedPrefValues();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Select Photos'),
        backgroundColor: componentColor,
        actions: [
          Row(
            children: [
              FlatButton.icon(
                icon: const Icon(
                  Icons.format_list_numbered_sharp,
                  color: Colors.white,
                ),
                label: const Text(
                  'Priority',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (OrderImagePriority(
                              widget.vehicleSpecId, widget.numVehicles))));
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.0,
              color: cardColor,
              child: MediaQuery(
                data: query.copyWith(textScaleFactor: 1.25),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          /*Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 0, 18),
                            child: Text(
                              year.toString() + " ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: componentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 300,
                                      child: Text(
                                        year.toString() + " " + friendlyName,
                                        overflow: TextOverflow.fade,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                        child: Text(
                          "Reg: " + reg.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 0, 0),
                        child: Text(
                          "Vin: " + vin.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 0, 0),
                        child: Text(
                          "Stock #" + stockCode,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              "Photos: " + widget.missingImage.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                //fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              " | Need " + imagesneed.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color.fromARGB(255, 170, 55, 47),
                                //   fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 6, 0, 0),
                        child: Text(
                          "Existing Vehicle Photos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _currentDbImage.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _currentDbImage.length == 0
                                ? Container(
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ])))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (EnlargeImage(
                                                      _currentDbImage[index]
                                                          .blobUrl,
                                                    )))),
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridTile(
                                            child: Hero(
                                          tag: 'vehimg',
                                          child: Image.network(
                                            _currentDbImage[index].blobUrl,
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          ),
                                        )),
                                      ),
                                    ),
                                    /* GridTile(
                                        child: Image.network(
                                      _currentDbImage[index].blobUrl,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 90,
                                    )),*/
                                  );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              showAlertDialogMedia();
                              //  _CaptureImage();
                              // _pickImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 40,
                            )),
                      ),
                      Center(
                        child: DragAndDropGridView(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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

                              if (_imageFileList!.length > 0) {
                                _saveImageVisible = true;
                              }

                              return Stack(children: <Widget>[
                                GridTile(
                                  child: Image.file(
                                    File(_imageFileList![index].path),
                                    fit: BoxFit.cover,
                                    height: height,
                                    width: width,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_imageFileList!.length < 1) {
                                        _saveImageVisible = true;
                                      }
                                      _imageFileList?.removeAt(index);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ]);
                            }),
                          ),
                          itemCount: _imageFileList!.length,
                          onWillAccept: (oldIndex, newIndex) => true,
                          onReorder: (oldIndex, newIndex) {
                            // You can also implement on your own logic on reorderable

                            int indexOfFirstItem = _imageFileList!
                                .indexOf(_imageFileList![oldIndex]);
                            int indexOfSecondItem = _imageFileList!
                                .indexOf(_imageFileList![newIndex]);

                            if (indexOfFirstItem > indexOfSecondItem) {
                              for (int i = _imageFileList!
                                      .indexOf(_imageFileList![oldIndex]);
                                  i >
                                      _imageFileList!
                                          .indexOf(_imageFileList![newIndex]);
                                  i--) {
                                var tmp = _imageFileList![i - 1];
                                _imageFileList![i - 1] = _imageFileList![i];
                                _imageFileList![i] = tmp;
                              }
                            } else {
                              for (int i = _imageFileList!
                                      .indexOf(_imageFileList![oldIndex]);
                                  i <
                                      _imageFileList!
                                          .indexOf(_imageFileList![newIndex]);
                                  i++) {
                                var tmp = _imageFileList![i + 1];
                                _imageFileList![i + 1] = _imageFileList![i];
                                _imageFileList![i] = tmp;
                              }
                            }
                            //    setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _saveImageVisible,
        child: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 25, 214, 120),
          label: const Text('Save Images',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              )),
          onPressed: () async {
            int numOfImages = _imageFileList!.length;

            var priority = 0;

            priority = widget.missingImage;

            if (_imageFileList!.isNotEmpty) {
              for (int i = 0; i < _imageFileList!.length; i++) {
                File file = File(_imageFileList![i].path);
                var b64 = Uri.file(file.path, windows: false);

                String base64Img = convertToB64(file);

                priority++;
                numOfImages--;
                DialogBuilder(context)
                    .showLoadingIndicator('Saving vehicle images..');
                Uri apiUrl = Uri.parse(qaApi + "api/v1.0/stock/media");

                Map<String, String> headers = {
                  HttpHeaders.authorizationHeader: "Bearer " + token!,
                  'content-Type': 'application/json'
                };

                Map<String, dynamic> bodyRes = {
                  "MediaTypeID": 1,
                  "VehicleStockID": widget.vehicleSpecId,
                  "Title": file.path.toString(),
                  "Source": "BeepMe",
                  "Priority": priority,
                  "Orientation": 1,
                  "ImageType": 1,
                  "Filename": file.path.toString(),
                  "Image": base64Img,
                  "Username": user_name,
                  "imageID": 0,
                  "newPriority": 0
                };

                var jsonBod = jsonEncode(bodyRes);

                Response res =
                    await http.post(apiUrl, body: jsonBod, headers: headers);

                if (res.statusCode == 200) {
                  // return CurrImage.fromJson(jsonDecode(res.body));
                  //  data = res.body;

                } else {
                  throw 'unable to load vehicles';
                }
                jsonBod = '';
                base64Img = '';
                DialogBuilder(context).hideOpenDialog();
                if (numOfImages < 1) {
                  showAlertDialog();
                  // _clearImage();
                }
              }
            } else {}
          },
        ),
      ),
    );
  }

  convertToB64(File imagefile) {
    Uint8List imagebytes = imagefile.readAsBytesSync(); //convert to bytes
    base64string = base64Encode(imagebytes);
    return base64string;
  }

  Future<void> _pickImage() async {
    //File selected =  await ImagePicker.platform.pickImage(source: source)
    final List<XFile>? selectedImages =
        await _picker.pickMultiImage(imageQuality: 10);
    if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(selectedImages);
    }
    if (_imageFileList != null) {
      setState(() {});
    }
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 1,
    );
    return compressedFile;
  }

  Future _CaptureImage() async {
    final img =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    File imgFil = File(img!.path);
    _imageFileList!.add(img);

    /* if (selectedImages!.isNotEmpty) {
      _imageFileList!.addAll(Fileimg);
    }*/
    /*final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;*/
    if (_imageFileList != null) {
      setState(() {
        //  state = AppState.picked;
      });
    }
  }

  void _clearImage() {
    _imageFileList = null;
    setState(() {});
  }
}
