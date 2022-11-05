import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:punctuality_drive/Modals/studentData.dart';
import 'package:punctuality_drive/main.dart';
import 'package:punctuality_drive/result2.dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Modals/createEntry.dart';
import 'package:punctuality_drive/Modals/login.dart';

String postApiURL =
    "http://akgec-late-entry.herokuapp.com/api/admin/entry/create";

/* Function for creating late entry in the DB */

Future<EntryModel?> lateEntry() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var headers = {
    'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  var request = http.Request(
    'POST',
    Uri.parse(postApiURL),
  );
  request.bodyFields = {'stdNo': studentNumber!, 'location': location!};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    if (kDebugMode) {
      log(await response.stream.bytesToString());
    }
  } else {
    if (kDebugMode) {
      log(response.reasonPhrase!);
    }
  }
  return null;
}

/*Function for fetching student details in result2 page*/
Future<StudentData?> show(String stdNum) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String studentDataApiURL =
      "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$stdNum";
  final response = await http.get(Uri.parse(studentDataApiURL), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
  });
  if (response.statusCode == 200) {
    if (kDebugMode) {
      log(response.body);
    }

    return StudentData.fromJson(
      jsonDecode(response.body),
    );
  } else {
    if (kDebugMode) {
      log(
        response.statusCode.toString(),
      );
    }
  }
  return null;
}

/*Function for login authorization */
