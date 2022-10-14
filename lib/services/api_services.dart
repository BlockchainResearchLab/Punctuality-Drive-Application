import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:punctuality_drive/Modals/studentData.dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:punctuality_drive/barcodeScanner.dart';

import '../Modals/createEntry.dart';

String postApiURL = "http://akgec-late-entry.herokuapp.com/api/admin/entry/create";

String studentDataApiURL = "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$studentNumber";



Future<EntryModel?> lateEntry() async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request(
    'POST',
    Uri.parse(postApiURL),
  );
  request.bodyFields = {'stdNo': studentNumber ?? '...', 'location': location ?? '...'};
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


Future<StudentData?> show() async {
  final response = await http.get(Uri.parse(studentDataApiURL));
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(response.body);
    }
    return StudentData.fromJson(jsonDecode(response.body));
  } else {
    if (kDebugMode) {
      print(response.statusCode);
    }
  }
  return null;
}
