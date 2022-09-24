import 'package:flutter/material.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/resultScreen.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => const LoginPage(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}

