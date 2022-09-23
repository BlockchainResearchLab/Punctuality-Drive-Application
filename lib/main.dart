import 'package:flutter/material.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("PUNCTUALITY DRIVE AKGEC"),
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.blueGrey.shade900,
        ),
        body: const Scanner(),
      ),
    );
  }
}

class Scanner extends StatelessWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              backgroundColor:
            ),
            child: Text("Button 1"),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: null,
            child: Text("Button 2"),
          ),
        ],
      ),
    );
  }
}
