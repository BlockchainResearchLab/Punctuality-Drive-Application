import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/loginScreen..dart';
import 'package:punctuality_drive/main.dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'barcodeScanner.dart';
import 'package:ripple_wave/ripple_wave.dart';


class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isElevated = true;

  void _dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(
            () {
          location = selectedValue;
        },
      );
      log(location!);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
        bottomSheet: ResultFooter(),
        drawer: Drawer(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
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
                                builder: (context) => const LoginPage(),
                              ),
                            ).whenComplete(() {
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
          actions: [
            DropdownButton(
              // isExpanded: true,
              elevation: 12,
              hint: Text(
                location ?? 'Your Location',
                style: const TextStyle(
                  color: Colors.amberAccent,
                ),
              ),
              //focusColor: Colors.amber,
              iconEnabledColor: Colors.amberAccent,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
          ],
          centerTitle: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.amberAccent,
          elevation: 20.0,
        ),
        body: Scaffold(
          body: RippleWave(
            childTween: Tween(begin: 1.5, end: 2),
            color: Colors.blue,
            child: const Scanner(),
          ),
        ),
        // floatingActionButton: const Scanner(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      ),
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
