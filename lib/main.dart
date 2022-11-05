import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/result2.dart';
import 'package:punctuality_drive/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userNamePrefs;
var authTokenPrefs;
var locPrefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userNamePrefs = prefs.getString('username');
  var passwordPrefs = prefs.getString("password");
  locPrefs = prefs.getString('location');
  authTokenPrefs = prefs.getString("authTokenPrefs");
  print(userNamePrefs);
  print(authTokenPrefs);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: authTokenPrefs == null ? LoginPage() : Scanner(),
  ));
}

// class MainPage extends StatelessWidget {
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
//     );

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.grey,
//       ),
//       routes: {
//         '/': (context) => const LoginPage(),
//         // '/result': (context) => const ResultScreen(),
//       },
//     );
//   }
// }
