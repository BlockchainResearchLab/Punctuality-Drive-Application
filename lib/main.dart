import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/result2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

String? userNamePrefs;
var authTokenPrefs;
var locPrefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final fcmToken = await FirebaseMessaging.instance.getToken();

  print(fcmToken);

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
    theme: ThemeData(
      primarySwatch: Palette.kToDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
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

//palette.dart

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff000000, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff000000), //10%
      100: const Color(0xff000000), //20%
      200: const Color(0xff000000), //30%
      300: const Color(0xff000000), //40%
      400: const Color(0xff000000), //50%
      500: const Color(0xff000000), //60%
      600: const Color(0xff000000), //70%
      700: const Color(0xff000000), //80%
      800: const Color(0xff000000), //90%
      900: const Color(0xff000000), //100%
    },
  );
}
