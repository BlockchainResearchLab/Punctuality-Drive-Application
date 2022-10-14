import 'package:flutter/material.dart';
import 'package:punctuality_drive/routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  final _validationKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
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
                        "PUNCTUALITY DRIVE APPLICATION",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.amberAccent,
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
                          TextFormField(
                            cursorColor: Colors.amberAccent,
                            style: const TextStyle(color: Colors.amberAccent),
                            validator: (name) {
                              if (name!.isEmpty) {
                                return "Please enter you Name!";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Name', hintText: 'Your Name'),
                            onChanged: (value) {
                              name = value;
                              setState(() {});
                            },
                          ),
                          TextFormField(
                            cursorColor: Colors.amberAccent,
                            style: const TextStyle(color: Colors.amberAccent),
                            validator: (usernm) {
                              if (usernm!.isEmpty) {
                                return "Please enter you Username!";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Username', hintText: 'Username'),
                          ),
                          TextFormField(
                            cursorColor: Colors.amberAccent,
                            style: const TextStyle(color: Colors.amberAccent),
                            validator: (pswd) {
                              if (pswd!.isEmpty) {
                                return "Please enter Password!";
                              } else if (pswd.length < 8) {
                                return "Password should at least have 8 characters!";
                              }
                              return null;
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
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.resultScreen);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.amberAccent,
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.05),
                        elevation: 8.0,
                        animationDuration: const Duration(seconds: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.g_mobiledata_rounded),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Google Sign In",
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
