import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:punctuality_drive/Modals/student_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

String postApiURL =
    // "http://akgec-late-entry.herokuapp.com/api/admin/entry/create";
    "https://akgec-late-entry-backend.onrender.com/api/admin/entry/create";

Future<StudentData?> show(String stdNum) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String studentDataApiURL =
      // "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$stdNum";
      "https://akgec-late-entry-backend.onrender.com/api/admin/student/read?stdNo=$stdNum";
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
