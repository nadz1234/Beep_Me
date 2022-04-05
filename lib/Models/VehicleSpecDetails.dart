// To parse this JSON data, do
//
//     final spec = specFromJson(jsonString);

import 'dart:convert';

Spec specFromJson(String str) => Spec.fromJson(json.decode(str));

String specToJson(Spec data) => json.encode(data.toJson());

class Spec {
  Spec({
    required this.status,
    required this.message,
    required this.identity,
    required this.result,
  });

  String status;
  String message;
  int identity;
  ResultVehicle result;

  factory Spec.fromJson(Map<String, dynamic> json) => Spec(
        status: json["status"],
        message: json["message"],
        identity: json["identity"],
        result: ResultVehicle.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "identity": identity,
        "result": result.toJson(),
      };
}

class ResultVehicle {
  ResultVehicle({
    required this.queueId,
    required this.friendlyName,
    required this.vehicleStockId,
    required this.year,
    required this.price,
    required this.stockCode,
    required this.mileage,
    required this.reg,
    required this.vin,
    required this.colour,
    required this.meadCode,
    required this.pendingSince,
    // required this.loadDate,
    required this.specs,
  });

  int queueId;
  String friendlyName;
  int vehicleStockId;
  int year;
  double price;
  String stockCode;
  int mileage;
  String reg;
  String vin;
  String colour;
  String meadCode;
  String pendingSince;
  // DateTime loadDate;
  List<SpecElement> specs;

  factory ResultVehicle.fromJson(Map<String, dynamic> json) => ResultVehicle(
        queueId: json["queueID"] ?? 0,
        friendlyName: json["friendlyName"] ?? "",
        vehicleStockId: json["vehicleStockID"] ?? 0,
        year: json["year"] ?? 0,
        price: json["price"] ?? 0.00,
        stockCode: json["stockCode"] ?? "",
        mileage: json["mileage"] ?? 0,
        reg: json["reg"] ?? "",
        vin: json["vin"] ?? "",
        colour: json["colour"] ?? "",
        meadCode: json["meadCode"] ?? "",
        pendingSince: json["pendingSince"] ?? "",
        //  loadDate: json["loadDate"],
        specs: List<SpecElement>.from(
            json["specs"].map((x) => SpecElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "queueID": queueId,
        "friendlyName": friendlyName,
        "vehicleStockID": vehicleStockId,
        "year": year,
        "price": price,
        "stockCode": stockCode,
        "mileage": mileage,
        "reg": reg,
        "vin": vin,
        "colour": colour,
        "meadCode": meadCode,
        "pendingSince": pendingSince,
        "specs": List<dynamic>.from(specs.map((x) => x.toJson())),
      };
}

class SpecElement {
  SpecElement({
    required this.optionId,
    required this.specId,
    required this.transmssion,
    required this.friendlyName,
    required this.dateFrom,
    required this.dateTo,
  });

  int optionId;
  int specId;
  String transmssion;
  String friendlyName;
  String dateFrom;
  String dateTo;

  factory SpecElement.fromJson(Map<String, dynamic> json) => SpecElement(
        optionId: json["optionID"] ?? 0,
        specId: json["specID"] ?? 0,
        transmssion: json["transmssion"] ?? "",
        friendlyName: json["friendlyName"] ?? "",
        dateFrom: json["dateFrom"] ?? "",
        dateTo: json["dateTo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "optionID": optionId,
        "specID": specId,
        "transmssion": transmssion,
        "friendlyName": friendlyName,
        "dateFrom": dateFrom,
        "dateTo": dateTo,
      };
}
