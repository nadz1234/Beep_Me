// To parse this JSON data, do
//
//     final currentVehicleImg = currentVehicleImgFromJson(jsonString);

import 'dart:convert';

CurrentVehicleImg currentVehicleImgFromJson(String str) =>
    CurrentVehicleImg.fromJson(json.decode(str));

String currentVehicleImgToJson(CurrentVehicleImg data) =>
    json.encode(data.toJson());

class CurrentVehicleImg {
  CurrentVehicleImg({
    required this.status,
    required this.message,
    required this.identity,
    required this.result,
  });

  String status;
  String message;
  int identity;
  List<CurrentVehImg> result;

  factory CurrentVehicleImg.fromJson(Map<String, dynamic> json) =>
      CurrentVehicleImg(
        status: json["status"],
        message: json["message"],
        identity: json["identity"],
        result: List<CurrentVehImg>.from(
            json["result"].map((x) => CurrentVehImg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "identity": identity,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class CurrentVehImg {
  CurrentVehImg({
    required this.blobUrl,
    required this.blobUsedVehicleId,
  });

  String blobUrl;
  int blobUsedVehicleId;

  factory CurrentVehImg.fromJson(Map<String, dynamic> json) => CurrentVehImg(
        blobUrl: json["blobURL"],
        blobUsedVehicleId: json["blobUsedVehicleID"],
      );

  Map<String, dynamic> toJson() => {
        "blobURL": blobUrl,
        "blobUsedVehicleID": blobUsedVehicleId,
      };
}
