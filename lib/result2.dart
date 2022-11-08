import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/Modals/create_entry.dart';
import 'package:punctuality_drive/barcode_scanner.dart';
import 'package:punctuality_drive/login_screen.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Modals/student_data.dart';

class ScannedEntry extends StatefulWidget {
  const ScannedEntry({super.key});

  @override
  State<ScannedEntry> createState() => _ScannedEntryState();
}

class _ScannedEntryState extends State<ScannedEntry> {


  // void _dropDownCallback(String? selectedValue) {
  //   if (selectedValue is String) {
  //     setState(() {
  //       location = selectedValue;
  //     });
  //     if (kDebugMode) {
  //       print(location);
  //     }
  //   }
  // }



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
      setState(
        () {
          badRequest = false;
        },
      );
      log(await response.stream.bytesToString());
      log(badRequest.toString());
    } else {
      setState(
        () {
          badRequest = true;
        },
      );

      log(response.reasonPhrase!);
      log("entry already exists");
      log(badRequest.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
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
      bottomSheet: resultFooter(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                elevation: 20,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(color: Colors.grey),
                  ),
                  child: emptyBarcode == true
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text("No ID card found. Scan again"),
                          ),
                        )
                      : FutureBuilder<StudentData?>(
                          future: show(studentNumber ?? "0000"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 80,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.result!.img.toString(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Student Name:  ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 20),
                                      children: [
                                        sData(snapshot.data!.result!.name
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Student Number:  ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 20),
                                      children: [
                                        sData(
                                            "${snapshot.data!.result!.stdNo}"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Buttons(
                                          const IconData(0xe156,
                                              fontFamily: 'MaterialIcons'), () {
                                        lateEntry().then(
                                          (error) {
                                            badRequest == false
                                                ? showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return AlertDialog(
                                                        icon: Image.asset(
                                                            'images/tick.png'),
                                                        title: const Text(
                                                            "Entry Status"),
                                                        content: Text(
                                                            "Entry marked \nCount : ${snapshot.data!.result!.lateCount! + 1}"),
                                                      );
                                                    }),
                                                  ).then((value) =>
                                                    Navigator.pop(context))
                                                : showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return const AlertDialog(
                                                        title: Text(
                                                            "Entry Status"),
                                                        content: Text(
                                                            "Entry already marked"),
                                                      );
                                                    }),
                                                  ).then((value) =>
                                                    Navigator.pop(context));
                                          },
                                        );
                                      }, "Mark Entry", Colors.green),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Buttons(
                                          const IconData(0xe139,
                                              fontFamily: 'MaterialIcons'),
                                          () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    icon: Image.asset(
                                                        'images/cancel.png'),
                                                    title: const Text(
                                                        "Entry Status"),
                                                    content: const Text(
                                                      "Entry cancelled.",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                (value) {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                          "Cancel",
                                          Colors.red)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            } else {
                              return const ScaffoldMessenger(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "Scan card again.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                ),
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
        minimumSize: MaterialStateProperty.all(
          const Size(50, 50),
        ),
        side: MaterialStatePropertyAll(BorderSide(color: color)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: onpressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black54,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Row resultFooter() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "POWERED BY : ",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Image(
            width: 120,
            image: AssetImage(
              "images/brl_logo.png",
            ),
          ),
          SizedBox(
            height: 50.0,
          )
        ],
      ),
    ],
  );
}

TextSpan sData(String text) {
  return TextSpan(
    text: text,
    style: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20.0,
    ),
  );
}
