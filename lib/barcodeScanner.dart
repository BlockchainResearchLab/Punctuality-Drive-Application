import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/result2.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

String? studentNumber;

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  // barcodeScanRes is the Result of the SCANNER
  String barcodeScanRes = "";

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(
        () {
          studentNumber = barcodeScanRes;

          // lateEntry(); // moved to mark entry button.
          show(studentNumber ?? "2012014");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => ScannedEntry()),
            ),
          );
        },
      );

      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  void _dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        location = selectedValue;
      });
      if (kDebugMode) {
        print(location);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
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
      }),
      child: GestureDetector(
        onTap: scanBarcodeNormal,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                DropdownButton(
                  hint: Text(
                    location ?? 'Your location',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  //focusColor: Colors.amber,
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                      value: "LT",
                      child: Text("LT"),
                    ),
                    DropdownMenuItem(
                      value: "CS/IT",
                      child: Text("CS/IT"),
                    ),
                    DropdownMenuItem(
                      value: "MG",
                      child: Text("Main Gate"),
                    ),
                  ],
                  onChanged: _dropDownCallback,
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('username');
                    prefs.remove('password');
                    prefs.remove('authTokenPrefs');
                    // username = null;
                    // password = null;

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        )).whenComplete(() {
                      // password = null;
                      // username = null;
                      setState(() {
                        password = null;
                        username = null;
                        authToken = null;
                        isSuccess = "false";
                        location = null;
                        // is_loading = false;
                      });
                    });
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            bottomSheet: ResultFooter(),
            body: Center(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "images/scan_icon.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Tap anywhere on the screen to scan."),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
