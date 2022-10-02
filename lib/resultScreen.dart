import 'package:flutter/material.dart';
import 'barcodeScanner.dart';

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
                      image: AssetImage("images/akg2.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
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
                          child: const Center(
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.red,
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
        title: const Text("PUNCTUALITY DRIVE AKGEC"),
        centerTitle: true,
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
        children: const [
          Text(
            "Result : ",
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ],
      ),
    );
  }
}
