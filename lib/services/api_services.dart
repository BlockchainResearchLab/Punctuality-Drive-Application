/*

var headers = {
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYzMzgxYmI0YWRiZDMyNTZkMGQzOWYzMyIsIm5hbWUiOiJTSEFIQkFaIEFMSSIsIm1vYmlsZSI6NzM5ODM1ODAxMiwidXNlck5hbWUiOiJzaGE3Mzk4MyIsInByaXZpbGVnZSI6MSwiZW1haWwiOiJzaGFoYmF6X2FsaUBvdXRsb29rLmluIiwicGFzc3dvcmQiOiIkMmIkMTAkOXVlNzBUakxsTGY3ODRDY3BrTlFNdXF0LlF4L0pWVW5rZktaVnFnSHBoZDRyeEdnVEswZGUiLCJkZXB0IjoiSVQiLCJjcmVhdGVkQXQiOiIyMDIyLTEwLTAxVDEwOjUxOjMyLjM3MFoiLCJ1cGRhdGVkQXQiOiIyMDIyLTEwLTI5VDE3OjEwOjUyLjUzNFoiLCJfX3YiOjAsInNhdmVkRm9ybWF0IjoiRm9sbG93aW5nIHN0dWRlbnRzIGFyZSBiZWluZyBhd2FyZGVkIDxzdHJvbmc-ZGVkdWN0aW9uIG9mIFR3bygyKSBHUCBNYXJrcyA8L3N0cm9uZz4gZWFjaCBmb3IgYmVpbmcgbGF0ZSB0aHJpY2UgZHVyaW5nIHB1bmN0dWFsaXR5IGRyaXZlLiJ9LCJpYXQiOjE2NjcxMDk5NDQsImV4cCI6MTY2NzEyMDc0NH0.tPT0qIVfZz3gad_2BeYltsYA19LmnPK6i_2xmu_n0Ic',
  'Content-Type': 'application/x-www-form-urlencoded'
};
var request = http.Request('POST', Uri.parse('http://akgec-late-entry.herokuapp.com/api/admin/entry/create'));
request.bodyFields = {
  'stdNo': '2012014',
  'location': 'MG'
};
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}


 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
/*Function for creating late entry in the DB */
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String studentDataApiURL =
      "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$stdNum";
  final response = await http.get(Uri.parse(studentDataApiURL), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
  });
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


