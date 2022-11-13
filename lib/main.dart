import 'package:punctuality_drive/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcode_scanner.dart';
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

class PDApp extends StatelessWidget {
  const PDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: authTokenPrefs == null ? const Splash() : const Scanner(),
    );
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
