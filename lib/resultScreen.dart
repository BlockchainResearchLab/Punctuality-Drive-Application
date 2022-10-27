import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/result2.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'barcodeScanner.dart';
import 'package:punctuality_drive/Modals/studentData.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isElevated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: ResultFooter(),
      drawer: Drawer(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              // color: Colors.grey[800],
              ),
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
                      // TODO: UID IMAGE
                      image: AssetImage("images/akg2.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                // TODO: UID NAME
                "UserName",
                style: TextStyle(fontSize: 30.0, color: Colors.black),
              ),
              // SizedBox(
              //   height: 500,
              // ),
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
                          // username = null;
                          // password = null;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              )).whenComplete(() {
                            password = null;
                            username = null;
                          });
                          // TODO: Logout Function Implementation
                          setState(() {
                            _isElevated = !_isElevated;
                          });
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
                                color: _isElevated ? Colors.red : Colors.white,
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
        // actions: [
        //   DropdownButton(
        //     hint: Text(
        //       location ?? 'Default',
        //       style: const TextStyle(
        //         color: Colors.amberAccent,
        //       ),
        //     ),
        //     //focusColor: Colors.amber,
        //     iconEnabledColor: Colors.amberAccent,
        //     dropdownColor: Colors.amberAccent,
        //     items: const [
        //       DropdownMenuItem(
        //         value: "LT",
        //         child: Text("LT"),
        //       ),
        //       DropdownMenuItem(
        //         value: "CS/IT",
        //         child: Text("CS/IT"),
        //       ),
        //       DropdownMenuItem(
        //         value: "MG",
        //         child: Text("Main Gate"),
        //       ),
        //     ],
        //     onChanged: _dropDownCallback,
        //   ),
        // ],
        centerTitle: false,
        backgroundColor: Colors.black,
        foregroundColor: Colors.amberAccent,
        elevation: 20.0,
      ),
      body: const Scaffold(),
      floatingActionButton: const Scanner(),
    );
  }
}

// class ResultPage extends StatefulWidget {
//   const ResultPage({Key? key}) : super(key: key);

//   @override
//   State<ResultPage> createState() => _ResultPageState();
// }

// class _ResultPageState extends State<ResultPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         image: DecorationImage(
//           // fit: BoxFit.fitHeight,
//           colorFilter: ColorFilter.mode(
//               const Color(0xFF424242).withOpacity(0.2), BlendMode.dstATop),
//           image: const AssetImage("images/akg2.png"),
//         ),
//       ),
//       child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//         Center(
//           child: FutureBuilder<StudentData?>(
//               future: show(studentNumber ?? "0000"),
//               builder: (context, snapshot) {
//                 return Container(
//                   margin: const EdgeInsets.only(top: 40.0),
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image:
//                           NetworkImage(snapshot.data!.result!.img.toString())
//                     ),
//                   ),
//                 );
//               }),
//         ),
//         FutureBuilder<StudentData?>(
//             future: show(studentNumber ?? "0000"),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       height: 15.0,
//                     ),
//                     Text(
//                       snapshot.data!.result!.name!.toString(),
//                       style: const TextStyle(fontSize: 30.0, color: Colors.white),
//                     ),
//                     const SizedBox(
//                       height: 15.0,
//                     ),
//                     Text(
//                       snapshot.data!.result!.stdNo!.toString(),
//                       style: const TextStyle(fontSize: 30.0, color: Colors.white),
//                     ),
//                   ],
//                 );
//               } else {
//                 return const CircularProgressIndicator.adaptive();
//               }
//             }),
//       ]),
//     );
//   }
// }
