import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

String temp = "";

class _ScannerState extends State<Scanner> {
  // barcodeScanRes is the Result of the SCANNER
  String barcodeScanRes = "";

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        temp = barcodeScanRes;
      });
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () => scanBarcodeNormal(),
      elevation: 10.0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.amberAccent,
      child: const Icon(Icons.document_scanner),
    );
  }
}
