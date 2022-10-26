import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:punctuality_drive/Modals/studentData.dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/loginScreen..dart';

import '../Modals/createEntry.dart';
import 'package:punctuality_drive/Modals/login.dart';

String postApiURL =
    "http://akgec-late-entry.herokuapp.com/api/admin/entry/create";
/*Function for creating late entry in the DB */
Future<EntryModel?> lateEntry() async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request(
    'POST',
    Uri.parse(postApiURL),
  );
  request.bodyFields = {
    'stdNo': studentNumber ?? '...',
    'location': location ?? '...'
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(await response.stream.bytesToString());
    }
  } else {
    if (kDebugMode) {
      print(response.reasonPhrase);
    }
  }
  return null;
}

/*Function for fetching student details in result2 page*/
Future<StudentData?> show(String stdNum) async {
  String studentDataApiURL =
      "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$stdNum";
  final response = await http.get(
    Uri.parse(studentDataApiURL),
  );
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(response.body);
    }
    return StudentData.fromJson(
      jsonDecode(response.body),
    );
  } else {
    if (kDebugMode) {
      print(response.statusCode);
    }
  }
  //return null;
}

/*Function for login authorization */

Future<Login?> login(String username, String password) async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request(
      'POST', Uri.parse('http://akgec-late-entry.herokuapp.com/login'));
  request.bodyFields = {'userName': username, 'password': password};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var jsondata = jsonDecode(data);
    print(jsondata);
    // print(jsondata["success"]);

    isSuccess = jsondata["success"].toString();
  } else {
    print(response.reasonPhrase);
  }
}
