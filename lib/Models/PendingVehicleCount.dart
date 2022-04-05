// To parse this JSON data, do
//
//     final pendingVehicleCount = pendingVehicleCountFromMap(jsonString);

import 'dart:convert';

PendingVehicleCount pendingVehicleCountFromMap(String str) =>
    PendingVehicleCount.fromMap(json.decode(str));

String pendingVehicleCountToMap(PendingVehicleCount data) =>
    json.encode(data.toMap());

class PendingVehicleCount {
  PendingVehicleCount({
    required this.status,
    required this.message,
    required this.identity,
    required this.result,
  });

  String status;
  String message;
  int identity;
  Result result;

  factory PendingVehicleCount.fromMap(Map<String, dynamic> json) =>
      PendingVehicleCount(
        status: json["status"],
        message: json["message"],
        identity: json["identity"],
        result: Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "identity": identity,
        "result": result.toMap(),
      };
}

class Result {
  Result({
    required this.pendingVehicles,
  });

  int pendingVehicles;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        pendingVehicles: json["pendingVehicles"],
      );

  Map<String, dynamic> toMap() => {
        "pendingVehicles": pendingVehicles,
      };
}
