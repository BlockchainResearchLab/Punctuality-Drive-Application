import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punctuality_drive/Modals/studentData.dart';
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
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        isSuccess = "false";
      });
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: ResultFooter(),
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
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
                            isExpanded: true,
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
                            controller: usernameController,
                            // field for username
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                            validator: (usernm) {
                              if (usernm!.isEmpty) {
                                return "Please enter you Username!";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              username = value;
                              print(username);
                            },
                            decoration: const InputDecoration(
                                labelText: 'Username', hintText: 'Username'),
                          ),
                          TextFormField(
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
                              print(password);
                            },
                            obscureText: true,
                            autocorrect: false,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
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
                          // });
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
                            Future.delayed(Duration(seconds: 2), () {
                              Container(
                                child: LinearProgressIndicator(
                                  color: Colors.black,
                                  minHeight: 18,
                                ),
                              );
                            }).then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(),
                                )));
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
                  ),
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
