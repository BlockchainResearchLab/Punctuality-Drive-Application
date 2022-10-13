// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.stdNo,
    required this.location,
  });

  String stdNo;
  String location;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        stdNo: json["stdNo"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "stdNo": stdNo,
        "location": location,
      };
}
