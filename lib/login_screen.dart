import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punctuality_drive/barcode_scanner.dart';
import 'package:punctuality_drive/result2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Modals/login.dart';
import 'package:http/http.dart' as http;

String? location;
String? username;
String? password;
String? isSuccess = "false";
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

      setState(
        () {
          isSuccess = "true";
          authToken = jsondata["token"];
        },
      );
      log(authToken!);
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }

      setState(
        () {
          isSuccess = "false";
        },
      );
    }
    return null;
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
    setState(
      () {
        username = usernameController.text;
      },
    );

    if (kDebugMode) {
      print(username);
    }
  }

  void _printLatestPassword() {
    setState(
      () {
        password = passwordController.text;
      },
    );

    if (kDebugMode) {
      print(password);
    }
  }

  bool _obscureText = true;


  // void _toggle() {
  //   setState(
  //     () {
  //       _obscureText = !_obscureText;
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
    ThemeData(
      primarySwatch: Colors.grey,
    );

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
                    'NO',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text(
                    'YES',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
        bottomSheet: resultFooter(),
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
                        height: 150,
                        width: 150,
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
                        height: 40.0,
                      ),
                      Form(
                        key: _validationKey,
                        child: Column(
                          children: [
                            DropdownButton(
                              elevation: 12,
                              hint: Text(
                                location ?? 'Your Location',
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: usernameController,
                              cursorColor: Colors.black,
                              cursorHeight: 25,
                              style: const TextStyle(color: Colors.black),
                              validator: (username) {
                                if (username!.isEmpty) {
                                  return "Please enter you Username!";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                username = value;
                              },
                              decoration: const InputDecoration(
                                labelText: 'USERNAME',
                                prefixIcon: Icon(Icons.account_circle_sharp),
                                prefixIconColor: Colors.black,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return "Please enter Password!";
                                } else if (password.length < 8) {
                                  return "Password should at least have 8 characters!";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: _obscureText,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: 'PASSWORD',
                                prefixIconColor: Colors.black,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: const Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        _obscureText = !_obscureText;
                                      },
                                    );
                                  },
                                  icon: _obscureText == true
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      autofocus: true,
                      onPressed: () async {
                        setState(() {});
                        if (location == null ||
                            password == null ||
                            username == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                "Please provide required details along with [Location] to Login",
                              ),
                            ),
                          );
                        } else {
                          try {
                            await login(username!, password!).then(
                              (value) {
                                if (value != null) {
                                  setState(
                                    () {
                                      isSuccess = "true";
                                    },
                                  );
                                }
                              },
                            ).catchError(
                              (e) {
                                setState(
                                  () {
                                    isSuccess = "false";
                                  },
                                );
                              },
                            );
                            if (isSuccess == "false") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
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
                              prefs.setString('location', location.toString());
                              Future.delayed(
                                const Duration(milliseconds: 1),
                                () {
                                  const SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: LinearProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  );
                                },
                              ).then(
                                (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Scanner(),
                                    ),
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print("cannot process");
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.05),
                        elevation: 8.0,
                        animationDuration: const Duration(seconds: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
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
