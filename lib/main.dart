import 'dart:convert';

import 'package:punctuality_drive/Screens/splash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/Screens/barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/constants.dart';
import 'Constants/variables.dart';
import 'Modals/student_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  userNamePrefs = prefs.getString('username');
  var passwordPrefs = prefs.getString("password");
  locPrefs = prefs.getString('location');
  authTokenPrefs = prefs.getString("authTokenPrefs");

  if (kDebugMode) {
    print(userNamePrefs);
  }
  if (kDebugMode) {
    print(authTokenPrefs);
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const PDApp(),
  );
}

class PDApp extends StatefulWidget {
  const PDApp({Key? key}) : super(key: key);

  @override
  State<PDApp> createState() => _PDAppState();
}

class _PDAppState extends State<PDApp> {
  Future<StudentData?> show2(String stdNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentDataApiURL =
        // "https://akgec-late-entry.herokuapp.com/api/admin/student/read?stdNo=$stdNum";
        "https://akgec-late-entry-backend.onrender.com/api/admin/student/read?stdNo=$stdNum";
    final response = await http.get(
      headers: {
        'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      Uri.parse(studentDataApiURL),
    );

    if (response.statusCode == 200) {
      setState(() {
        errorCode = "200";
      });
      if (kDebugMode) {
        print(response.body);
      }

      return StudentData.fromJson(
        jsonDecode(response.body),
      );
    } else {
      setState(() {
        errorCode = "400";
      });
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    show2("2010113");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Palette.kToDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: errorCode == "200" ? const Scanner() : const Splash());
  }
}
