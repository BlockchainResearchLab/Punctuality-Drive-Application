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
  final TextEditingController _controller = TextEditingController();

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
  void initState() {
    super.initState();
    _controller.addListener(_printLatestStudentNoFromKeyboard);
  }

  void _printLatestStudentNoFromKeyboard() {
    setState(
      () {
        studentNumber = _controller.text;
      },
    );

    if (kDebugMode) {
      print(username);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
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
        onTap: () {
          if (location != null) {
            scanBarcodeNormal();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text(
                  "Please provide [Location] to Scan",
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.person_search_outlined),
              onPressed: () {
                if (location != null) {
                  showModalBottomSheet(
                    isDismissible: true,
                    useRootNavigator: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return "Enter the Student Number";
                                  } else if (value.length != 7) {
                                    return "Enter Valid Student Number";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  studentNumber = _controller.text;
                                },
                                autofocus: true,
                                controller: _controller,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.numbers),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ScannedEntry()));
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.search),
                                    ),
                                    hintText: "Student Number"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                        "Please provide [Location] to Scan",
                      ),
                    ),
                  );
                }
              },
            ),
            appBar: AppBar(
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: DropdownButton(
                      value: location,
                      elevation: 4,
                      hint: const Text(
                        'Your Location',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.black,
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
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade600),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('username');
                      prefs.remove('password');
                      prefs.remove('authTokenPrefs');
                      setState(
                        () {
                          password = null;
                          username = null;
                          authToken = null;
                          isSuccess = "false";
                        },
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
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
                          "images/scan2.jpg",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Tap anywhere on the screen to scan.",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
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
