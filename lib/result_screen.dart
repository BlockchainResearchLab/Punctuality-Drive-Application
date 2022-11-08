
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/login_screen.dart';
import 'package:punctuality_drive/main.dart';
import 'package:punctuality_drive/result2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'barcode_scanner.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isElevated = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Are you sure?',
              ),
              content: const Text(
                'Do you want to exit?',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'No',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Yes',
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
        bottomSheet: resultFooter(),
        drawer: Drawer(
          child: SizedBox(
            width: double.infinity,
            child: Column(
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
                        image: AssetImage("images/akg2.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  userNamePrefs.toString(),
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('username');
                            prefs.remove('password');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ).whenComplete(
                              () {
                                setState(
                                  () {
                                    password = null;
                                    username = null;
                                    authToken = null;
                                    isSuccess = "false";
                                    location = null;
                                  },
                                );
                              },
                            );
                            // TODO: Logout Function Implementation
                            setState(
                              () {
                                _isElevated = !_isElevated;
                              },
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: _isElevated
                                    ? [
                                        const BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(4, 4),
                                            blurRadius: 15,
                                            spreadRadius: 1),
                                        const BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(-8, -8),
                                            blurRadius: 15,
                                            spreadRadius: 1),
                                      ]
                                    : null),
                            child: Center(
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color:
                                      _isElevated ? Colors.red : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text("PUNCTUALITY DRIVE"),
          centerTitle: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.amberAccent,
          elevation: 20.0,
        ),
        body: const Scaffold(),
        floatingActionButton: const Scanner(),
      ),
    );
  }
}
