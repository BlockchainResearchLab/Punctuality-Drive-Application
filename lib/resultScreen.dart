import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'barcodeScanner.dart';


String? location;

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
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
                style: TextStyle(fontSize: 30.0, color: Colors.amberAccent),
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
                        onTap: () {
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
        actions: [
          DropdownButton(
            hint: Text(
              location??'Default',
              style: const TextStyle(
                color: Colors.amberAccent,
              ),
            ),
            //focusColor: Colors.amber,
            iconEnabledColor: Colors.amberAccent,
            dropdownColor: Colors.amberAccent,
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
      body: const ResultPage(),
      floatingActionButton: const Scanner(),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        image: DecorationImage(
          // fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
              const Color(0xFF424242).withOpacity(0.2), BlendMode.dstATop),
          image: const AssetImage("images/akg2.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Entry Marked\n\nSTUDENT NUMBER = $studentNumber\n\nLocation = $location",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
