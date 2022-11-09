import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:punctuality_drive/login_screen.dart';
import 'package:punctuality_drive/result2.dart';

import 'package:shared_preferences/shared_preferences.dart';

String? studentNumber;
String? error;
bool emptyBarcode = false;

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  Future<void> scanBarcodeNormal() async {
    try {
      ScanResult barcodeScanRes = await BarcodeScanner.scan();
      log(barcodeScanRes.rawContent);
      setState(
        () {
          if (barcodeScanRes.rawContent.isEmpty) {
            log(barcodeScanRes.rawContent);
            emptyBarcode = true;
          } else {
            log(barcodeScanRes.rawContent);
            emptyBarcode = false;
            studentNumber = barcodeScanRes.rawContent;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const ScannedEntry()),
            ),
          );
        },
      );

      if (kDebugMode) {
        log(barcodeScanRes.rawContent);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(
          () {
            error = 'The user did not grant the camera permission!';
          },
        );
      } else {
        setState(() => error = 'Unknown error: $e');
        if (kDebugMode) {
          print(studentNumber);
        }
      }
    }
  }

  void _dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(
        () {
          location = selectedValue;
        },
      );
      if (kDebugMode) {
        print(location);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
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
                    'NO',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('YES',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
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
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: DropdownButton(
                      value: location,
                      elevation: 12,
                      hint: const Text(
                        'Your Location',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      items: const [
                        DropdownMenuItem(
                          value: "LT",
                          child: Text(
                            "LT",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "CS/IT",
                          child: Text(
                            "CS/IT",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "MG",
                          child: Text(
                            "Main Gate",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      onChanged: _dropDownCallback,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('username');
                      prefs.remove('password');
                      prefs.remove('authTokenPrefs');
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
                              // is_loading = false;
                            },
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
            ),
            bottomSheet: resultFooter(),
            body: Center(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
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
                    Text(
                      "Tap anywhere on the screen to scan.",
                    ),
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
