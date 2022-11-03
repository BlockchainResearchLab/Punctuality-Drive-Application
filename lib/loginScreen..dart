import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/Modals/studentData.dart';
import 'package:punctuality_drive/barcodeScanner.dart';
import 'package:punctuality_drive/main.dart';
import 'package:punctuality_drive/result2.dart';
import 'package:punctuality_drive/resultScreen.dart';
import 'package:punctuality_drive/routes/routes.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Modals/login.dart';
import 'package:http/http.dart' as http;

String? location;
String? username;
String? password;
String? isSuccess = "false";
// var is_loading;
String? authToken;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _validationKey = GlobalKey<FormState>();

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

  Future<Login?> login(String username, String password) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST', Uri.parse('http://akgec-late-entry.herokuapp.com/login'));
    request.bodyFields = {'userName': username, 'password': password};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var jsondata = jsonDecode(data);
      print(jsondata);
      // print(jsondata["success"]);

      setState(() {
        isSuccess = "true";
        authToken = jsondata["token"];
      });
      print(authToken);
    } else {
      print(response.reasonPhrase);
      setState(() {
        isSuccess = "false";
      });
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScannedEntry scannedEntry = ScannedEntry();
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   usernameController.dispose();
  //   passwordController.dispose();
  // }
  @override
  void initState() {
    super.initState();
    usernameController.addListener(_printLatestUsername);
    passwordController.addListener(_printLatestPassword);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _printLatestUsername() {
    setState(() {
      username = usernameController.text;
    });
    print(username);
  }

  void _printLatestPassword() {
    setState(() {
      password = passwordController.text;
    });
    print(password);
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        body: SingleChildScrollView(
          primary: false,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'images/akg2.png',
                          fit: BoxFit.fill,
                          scale: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 35.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text(
                          "PUNCTUALITY DRIVE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        key: _validationKey,
                        child: Column(
                          children: [
                            DropdownButton(
                              // isExpanded: true,
                              elevation: 12,
                              hint: Text(
                                location ?? 'Your Location',
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              //focusColor: Colors.amber,
                              iconEnabledColor: Colors.black,
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
                            // TextFormField(
                            //   //field for location
                            //   cursorColor: Colors.amberAccent,
                            //   style: const TextStyle(color: Colors.amberAccent),
                            //   validator: (name) {
                            //     if (name!.isEmpty) {
                            //       return "Please enter your Location (Main Gate, CS/IT, LT)!";
                            //     }
                            //     return null;
                            //   },
                            //   decoration: const InputDecoration(
                            //       labelText: 'Location',
                            //       hintText: 'Your Location'),
                            //   onChanged: (value) {
                            //     location = value;
                            //     setState(() {});
                            //   },
                            // ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: usernameController,

                              // field for username
                              cursorColor: Colors.black,
                              cursorHeight: 25,
                              style: const TextStyle(color: Colors.black),
                              validator: (usernm) {
                                if (usernm!.isEmpty) {
                                  return "Please enter you Username!";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                username = value;
                                // print(username);
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.account_circle_sharp),
                                  prefixIconColor: Colors.black),
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              // field for password
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              validator: (pswd) {
                                if (pswd!.isEmpty) {
                                  return "Please enter Password!";
                                } else if (pswd.length < 8) {
                                  return "Password should at least have 8 characters!";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                                // print(password);
                              },
                              obscureText: _obscureText,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIconColor: Colors.black,
                                  prefixIcon: Icon(Icons.password_outlined),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: _obscureText == true
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      autofocus: true,
                      onPressed: () async {
                        setState(() {});
                        if (password == null && username == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                  "Please provide required details to login"),
                            ),
                          );
                        } else {
                          try {
                            // login(username!, password!).then((value) {
                            //   isSuccess = "true";
                            // }).catchError(() {
                            //   isSuccess = "false";
                            //
                            await login(username!, password!).then((value) {
                              if (value != null) {
                                setState(() {
                                  isSuccess = "true";
                                });
                              }
                            }).catchError(() {
                              setState(() {
                                isSuccess = "false";
                              });
                            });
                            if (isSuccess == "false") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Unauthorized Access",
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', username.toString());
                              prefs.setString('password', password.toString());
                              prefs.setString(
                                  'authTokenPrefs', authToken.toString());
                              Future.delayed(Duration(milliseconds: 2), () {
                                LinearProgressIndicator(
                                  color: Colors.black,
                                );
                              }).then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scanner(),
                                    ));
                              });
                            }
                          } catch (e) {
                            print("cannot process");
                          }
                        }
                      },
                      // onPressed: () {
                      //   // Navigator.pushNamed(context, Routes.resultScreen);
                      //   try {
                      //     // login(username!, password!);
                      //     if (isSuccess == "true") {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => ResultScreen(),
                      //           ));
                      //     } else if (username == "" && password == "") {
                      //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //           content: Text(
                      //               "Please fill Username and Password to Login")));
                      //     } else {
                      //       return null;
                      //     }
                      //   } catch (e) {
                      //     throw (e);
                      //   }
                      // },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          // foregroundColor: Colors.amberAccent,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.05),
                          elevation: 8.0,
                          animationDuration: const Duration(seconds: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          // Icon(Icons.g_mobiledata_rounded),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    )
                  ],
                ),
                // isSuccess == "true"
                //     ? Text("Logged In")
                //     : Text("Incorrect Username or Password"),
                //linear progress indicator is to be put here.
                const SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FutureBuilder<Login?> isSuccess() {
//   return FutureBuilder<Login?>(
//     future: login(username!, password!),
//     builder: (context, snapshot) {
//       if (snapshot.data!.success == true) {
//         return
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ResultScreen(),
//             ));
//       } else {
//         return LinearProgressIndicator();
//       }

//     }
//   );
// }

// bool isSuccess() {}


// var headers = {
//   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYzMzgxYmI0YWRiZDMyNTZkMGQzOWYzMyIsIm5hbWUiOiJTSEFIQkFaIEFMSSIsIm1vYmlsZSI6NzM5ODM1ODAxMiwidXNlck5hbWUiOiJzaGE3Mzk4MyIsInByaXZpbGVnZSI6MSwiZW1haWwiOiJzaGFoYmF6X2FsaUBvdXRsb29rLmluIiwicGFzc3dvcmQiOiIkMmIkMTAkOXVlNzBUakxsTGY3ODRDY3BrTlFNdXF0LlF4L0pWVW5rZktaVnFnSHBoZDRyeEdnVEswZGUiLCJkZXB0IjoiSVQiLCJjcmVhdGVkQXQiOiIyMDIyLTEwLTAxVDEwOjUxOjMyLjM3MFoiLCJ1cGRhdGVkQXQiOiIyMDIyLTEwLTI5VDE3OjEwOjUyLjUzNFoiLCJfX3YiOjAsInNhdmVkRm9ybWF0IjoiRm9sbG93aW5nIHN0dWRlbnRzIGFyZSBiZWluZyBhd2FyZGVkIDxzdHJvbmc-ZGVkdWN0aW9uIG9mIFR3bygyKSBHUCBNYXJrcyA8L3N0cm9uZz4gZWFjaCBmb3IgYmVpbmcgbGF0ZSB0aHJpY2UgZHVyaW5nIHB1bmN0dWFsaXR5IGRyaXZlLiJ9LCJpYXQiOjE2NjcxMDk5NDQsImV4cCI6MTY2NzEyMDc0NH0.tPT0qIVfZz3gad_2BeYltsYA19LmnPK6i_2xmu_n0Ic',
//   'Content-Type': 'application/x-www-form-urlencoded'
// };
// var request = http.Request('POST', Uri.parse('http://akgec-late-entry.herokuapp.com/api/admin/entry/create'));
// request.bodyFields = {
//   'stdNo': '2012014',
//   'location': 'MG'
// };
// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
