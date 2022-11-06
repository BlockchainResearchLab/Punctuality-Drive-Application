import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/Modals/create_entry.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/main.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Modals/student_data.dart';

class ScannedEntry extends StatefulWidget {
  ScannedEntry({super.key});

  @override
  State<ScannedEntry> createState() => _ScannedEntryState();
}

class _ScannedEntryState extends State<ScannedEntry> {
// barcodeScanRes is the Result of the SCANNER

  bool _isElevated = true;
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

  bool? badRequest;
  Future<EntryModel?> lateEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Authorization': 'Bearer ${prefs.getString('authTokenPrefs')}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request(
      'POST',
      Uri.parse(postApiURL),
    );
    request.bodyFields = {
      'stdNo': studentNumber.toString(),
      'location': location.toString()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        badRequest = false;
      });
      log(await response.stream.bytesToString());
      log(badRequest.toString());
    } else {
      setState(() {
        badRequest = true;
      });

      log(response.reasonPhrase!);
      log("entry already exists");
      log(badRequest.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    var size = MediaQuery.of(context).size;

    var height = size.height;
    var width = size.width;
    if (kDebugMode) {
      print(height);
      print(width);
    }

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    return Scaffold(
      bottomSheet: ResultFooter(),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.15,
                      image: AssetImage("images/AKGEC_1_0.png"),
                      fit: BoxFit.scaleDown),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: Colors.grey),
                ),
                child: emptyBarcode == true
                    ? Center(
                        child: Text("No ID Card Found\nUse Valid ID Card."),
                      )
                    : FutureBuilder<StudentData?>(
                        future: show(studentNumber ?? "0000"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              child: Center(
                                  child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                              height: 100,
                              width: 100,
                            );
                          } else if (snapshot.hasData) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 80,
                                      backgroundImage: NetworkImage(snapshot
                                          .data!.result!.img
                                          .toString()), // link to be provided later.
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Student Name : ${snapshot.data!.result!.name.toString()}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Student Number :${snapshot.data!.result!.stdNo} ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Buttons(
                                          const IconData(0xe156,
                                              fontFamily: 'MaterialIcons'), () {
                                        lateEntry().then((error) {
                                          badRequest == false
                                              ? showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Entry Status"),
                                                      content: Text(
                                                          "Entry Marked \nCount : ${snapshot.data!.result!.lateCount! + 1}"),
                                                    );
                                                  }),
                                                ).then((value) =>
                                                  Navigator.pop(context))
                                              : showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Entry Status"),
                                                      content: Text(
                                                          "Entry Already Marked"),
                                                    );
                                                  }),
                                                ).then((value) =>
                                                  Navigator.pop(context));
                                        });
                                        // ScaffoldMessenger(child: Text("Entry Marked"));

                                        // Future.delayed(Duration(seconds: 2), () {
                                        //   Navigator.pop(context);
                                        // });
                                      }, "Mark Entry", Colors.blue),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Buttons(
                                          const IconData(0xe139,
                                              fontFamily: 'MaterialIcons'),
                                          () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text("Entry Status"),
                                                    content: Text(
                                                      "Entry Cancelled",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  );
                                                },
                                              ).then((value) {
                                                Navigator.pop(context);
                                              }),
                                          "Cancel",
                                          Colors.red)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ]);
                          } else {
                            return ScaffoldMessenger(
                                child: Text(
                              "Scan the card again",
                              style: TextStyle(fontSize: 18),
                            ));
                          }
                        }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  Buttons(
    this.icon,
    this.onpressed,
    this.text,
    this.color,
  );
  IconData icon;
  String text;
  Function() onpressed;
  Color color;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            minimumSize: MaterialStateProperty.all(Size(50, 50)),
            side: MaterialStatePropertyAll(BorderSide(color: color)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        onPressed: onpressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black54,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}

Widget ResultFooter() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // SizedBox(
      //   width: 145,
      // ),
      Container(
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "POWERED BY : ",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Image(
                image: AssetImage(
                  "images/brl_logo.png",
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}
