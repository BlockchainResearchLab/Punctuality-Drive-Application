import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:punctuality_drive/Modals/create_entry.dart';
import 'package:punctuality_drive/Modals/student_data.dart';
import 'package:punctuality_drive/Screens/barcode_scanner.dart';
import 'package:punctuality_drive/Screens/login_screen.dart';
import 'package:punctuality_drive/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../APIs/api.dart';
import '../Constants/variables.dart';

/*Changing API. *Backend redeployed to Render* */

/* Function for creating late entry in the DB */

// Future<EntryModel?> lateEntry() async {
//   var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
//   var request = http.Request(
//     'POST',
//     Uri.parse(postApiURL),
//   );
//   request.bodyFields = {
//     'stdNo': studentNumber ?? '...',
//     'location': location ?? '...'
//   };
//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     if (kDebugMode) {
//       print(await response.stream.bytesToString());
//     }
//   } else {
//     if (kDebugMode) {
//       print(response.reasonPhrase);
//     }
//   }
//   return null;
// }

/*Function for fetching student details in result2 page*/
/*Changing API. *Backend redeployed to Render* */
Future<StudentData?> show(String stdNum) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final response = await http.get(
    headers: {
      'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    Uri.parse(studentDataApiURL + stdNum),
  );

  if (response.statusCode == 200) {
    errorCode = "200";
    if (kDebugMode) {
      print(response.body);
    }

    return StudentData.fromJson(
      jsonDecode(response.body),
    );
  } else {
    errorCode = "400";
    if (kDebugMode) {
      print(response.statusCode);
    }
  }
  return null;
}

/*Function for login authorization */
/*https://akgec-late-entry-backend.onrender.com/ */
