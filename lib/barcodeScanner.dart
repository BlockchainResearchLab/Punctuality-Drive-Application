import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:punctuality_drive/services/api_services.dart';
import 'dart:math' as math;

String? studentNumber;

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  // barcodeScanRes is the Result of the SCANNER
  String barcodeScanRes = "";

  Future<void> scanBarcodeNormal() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        studentNumber = barcodeScanRes;
        lateEntry();
        show();
      });
      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      onPressed: () => setState(() {
        scanBarcodeNormal();
      }),
      elevation: 10.0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.amberAccent,
      child: Transform.rotate(
        angle: 90 * math.pi / 180,
        child: const Icon(Icons.document_scanner),
      ),
    );
  }
}
