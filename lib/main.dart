import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userNamePrefs = prefs.getString('username');
  var passwordPrefs = prefs.getString("password");

  if (kDebugMode) {
    print(userNamePrefs);
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userNamePrefs == null ? const LoginPage() : const ResultScreen(),
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
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
