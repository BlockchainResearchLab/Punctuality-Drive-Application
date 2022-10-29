import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'Modals/studentData.dart';

class ScannedEntry extends StatefulWidget {
  const ScannedEntry({super.key});

  @override
  State<ScannedEntry> createState() => _ScannedEntryState();
}

class _ScannedEntryState extends State<ScannedEntry> {
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
    return Scaffold(
      bottomSheet: ResultFooter(),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            height: height * 0.479,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: FutureBuilder<StudentData?>(
                future: show(studentNumber ?? "0000"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      child: Center(child: LinearProgressIndicator()),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Buttons(
                                  IconData(0xe156, fontFamily: 'MaterialIcons'),
                                  () {
                                lateEntry()
                                    .whenComplete(() => showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            title: Text("Entry Status"),
                                            content: Text(
                                                "Entry Marked \nCount : ${snapshot.data!.result!.lateCount}"),
                                          );
                                        })))
                                    .whenComplete(() => Navigator.pop(context));
                                // ScaffoldMessenger(child: Text("Entry Marked"));

                                // Future.delayed(Duration(seconds: 2), () {
                                //   Navigator.pop(context);
                                // });
                              }, "Mark Entry", Colors.blue),
                              SizedBox(
                                width: 10,
                              ),
                              Buttons(
                                  IconData(0xe139, fontFamily: 'MaterialIcons'),
                                  () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Entry Status"),
                                            content: Text(
                                              "Entry Cancelled",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          );
                                        },
                                      ).then((value) => Navigator.pop(context)),
                                  "Cancel",
                                  Colors.red)
                            ],
                          ),
                        ]);
                  } else {
                    return ScaffoldMessenger(
                        child: Text(
                      "Scan the card again",
                      style: TextStyle(fontSize: 18),
                    ));
                  }
                  ;
                }),
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
            side: MaterialStatePropertyAll(BorderSide(color: Colors.white)),
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
