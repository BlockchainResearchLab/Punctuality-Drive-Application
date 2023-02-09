import 'dart:convert';

import 'package:punctuality_drive/services/api_services.dart';
import 'package:punctuality_drive/splash.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Modals/student_data.dart';

String? userNamePrefs;
var authTokenPrefs;
var locPrefs;
String errorCode = "400";

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
          primarySwatch: Palette.kToDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: errorCode == "200" ? const Scanner() : const Splash());
  }
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff000000,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff000000), //10%
      100: Color(0xff000000), //20%
      200: Color(0xff000000), //30%
      300: Color(0xff000000), //40%
      400: Color(0xff000000), //50%
      500: Color(0xff000000), //60%
      600: Color(0xff000000), //70%
      700: Color(0xff000000), //80%
      800: Color(0xff000000), //90%
      900: Color(0xff000000), //100%
    },
  );
}
