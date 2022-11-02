import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userNamePrefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userNamePrefs = prefs.getString('username');
  String? passwordPrefs = prefs.getString("password");
  log(userNamePrefs!);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userNamePrefs == null ? const LoginPage() : const LandingScreen(),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginPage(),
        '/result': (context) => const LandingScreen(),
      },
    );
  }
}
