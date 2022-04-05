// To parse this JSON data, do
//
//     final impersonate = impersonateFromJson(jsonString);

import 'dart:convert';

Impersonate impersonateFromJson(String str) =>
    Impersonate.fromJson(json.decode(str));

String impersonateToJson(Impersonate data) => json.encode(data.toJson());

class Impersonate {
  Impersonate({
    required this.status,
    required this.message,
    required this.identity,
    required this.result,
  });

  String status;
  String message;
  int identity;
  Result result;

  factory Impersonate.fromJson(Map<String, dynamic> json) => Impersonate(
        status: json["status"],
        message: json["message"],
        identity: json["identity"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "identity": identity,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    required this.list,
  });

  List<ListImpersonElement> list;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        list: List<ListImpersonElement>.from(
            json["list"].map((x) => ListImpersonElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListImpersonElement {
  ListImpersonElement({
    required this.value,
    required this.text,
    required this.selected,
  });

  String value;
  String text;
  bool selected;

  factory ListImpersonElement.fromJson(Map<String, dynamic> json) =>
      ListImpersonElement(
        value: json["value"],
        text: json["text"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "text": text,
        "selected": selected,
      };
}
