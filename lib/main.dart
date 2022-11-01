import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

var userNamePrefs;
var authTokenPrefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userNamePrefs = prefs.getString('username');
  var passwordPrefs = prefs.getString("password");
  authTokenPrefs = prefs.getString("authTokenPrefs");
  print(userNamePrefs);
  print(authTokenPrefs);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: authTokenPrefs == null ? LoginPage() : ResultScreen(),
  ));
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
