import 'dart:ui';

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
        drawer: Drawer(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                // fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1), BlendMode.dstATop),
                image: const AssetImage("images/akgeclogo.png"),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40.0),
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("images/akgeclogo.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    const Text(
                      "UserName",
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                const ListTile(
                  trailing: Icon(
                    Icons.logout,
                    size: 30.0,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  onTap: null,
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text("PUNCTUALITY DRIVE AKGEC"),
          centerTitle: true,
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.blueGrey.shade900,
        ),
        body: const ScannerPage(),
      ),
    );
  }
}

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          // fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.1), BlendMode.dstATop),
          image: const AssetImage("images/akgeclogo.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.amberAccent,
              elevation: 2.5,
              side: const BorderSide(
                color: Colors.green,
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              "SCAN CARD",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              elevation: 2.5,
              side: const BorderSide(
                color: Colors.red,
                style: BorderStyle.solid,
              ),
            ),
            child: const Text(
              "LOGOUT",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
