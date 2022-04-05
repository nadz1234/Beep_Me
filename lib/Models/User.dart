// To parse this JSON data, do
//
//     final member = memberFromMap(jsonString);

import 'dart:convert';

Member memberFromMap(String str) => Member.fromMap(json.decode(str));

String memberToMap(Member data) => json.encode(data.toMap());

class Member {
  Member({
    this.status,
    this.message,
    this.identity,
    this.result,
  });

  String? status;
  String? message;
  int? identity;
  Result? result;

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        status: json["status"],
        message: json["message"],
        identity: json["identity"],
        result: Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "identity": identity,
        "result": result!.toMap(),
      };
}

class Result {
  Result({
    this.name,
    this.surname,
    this.image,
    this.client,
    this.clientId,
    this.memberId,
    this.impersonating,
    this.administrator,
    this.widgets,
    this.banners,
    this.notices,
  });

  String? name;
  String? surname;
  String? image;
  String? client;
  int? clientId;
  int? memberId;
  bool? impersonating;
  bool? administrator;
  List<dynamic>? widgets;
  List<Banner>? banners;
  dynamic notices;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        name: json["name"],
        surname: json["surname"],
        image: json["image"],
        client: json["client"],
        clientId: json["clientID"],
        memberId: json["memberID"],
        impersonating: json["impersonating"],
        administrator: json["administrator"],
        widgets: List<dynamic>.from(json["widgets"].map((x) => x)),
        banners:
            List<Banner>.from(json["banners"].map((x) => Banner.fromMap(x))),
        notices: json["notices"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "surname": surname,
        "image": image,
        "client": client,
        "clientID": clientId,
        "memberID": memberId,
        "impersonating": impersonating,
        "administrator": administrator,
        "widgets": List<dynamic>.from(widgets!.map((x) => x)),
        "banners": List<dynamic>.from(banners!.map((x) => x.toMap())),
        "notices": notices,
      };
}

class Banner {
  Banner({
    this.bannerId,
    this.title,
    this.subTitle,
    this.colour,
    this.icon,
    this.description,
  });

  String? bannerId;
  String? title;
  String? subTitle;
  String? colour;
  List<Iconr>? icon;
  String? description;

  factory Banner.fromMap(Map<String, dynamic> json) => Banner(
        bannerId: json["bannerID"],
        title: json["title"],
        subTitle: json["subTitle"],
        colour: json["colour"],
        icon: List<Iconr>.from(json["icon"].map((x) => Iconr.fromMap(x))),
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "bannerID": bannerId,
        "title": title,
        "subTitle": subTitle,
        "colour": colour,
        "icon": List<dynamic>.from(icon!.map((x) => x.toMap())),
        "description": description,
      };
}

class Iconr {
  Iconr({
    this.theme,
    this.image,
    this.colour,
    this.package,
  });

  Theme? theme;
  String? image;
  String? colour;
  Package? package;

  factory Iconr.fromMap(Map<String, dynamic> json) => Iconr(
        theme: themeValues.map[json["theme"]],
        image: json["image"],
        colour: json["colour"],
        package: packageValues.map[json["package"]],
      );

  Map<String, dynamic> toMap() => {
        "theme": themeValues.reverse[theme],
        "image": image,
        "colour": colour,
        "package": packageValues.reverse[package],
      };
}

enum Package { FLUTTER_GALLERY_ASSETS }

final packageValues =
    EnumValues({"flutter_gallery_assets": Package.FLUTTER_GALLERY_ASSETS});

enum Theme { LIGHT, DARK }

final themeValues = EnumValues({"Dark": Theme.DARK, "Light": Theme.LIGHT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
