// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

EntryModel welcomeFromJson(String str) => EntryModel.fromJson(json.decode(str));

String welcomeToJson(EntryModel data) => json.encode(data.toJson());

class EntryModel {
  EntryModel({
    required this.stdNo,
    required this.location,
  });

  String stdNo;
  String location;

  factory EntryModel.fromJson(Map<String, dynamic> json) => EntryModel(
        stdNo: json["stdNo"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "stdNo": stdNo,
        "location": location,
      };
}
