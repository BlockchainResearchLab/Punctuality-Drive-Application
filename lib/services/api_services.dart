import 'package:http/http.dart' as http;
import 'package:punctuality_drive/resultScreen.dart';
import 'package:punctuality_drive/barcodeScanner.dart';

import '../Modals/createEntry.dart';

String apiURL = "http://akgec-late-entry.herokuapp.com/api/admin/entry/create";


Future<EntryModel?> lateEntry() async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request(
    'POST',
    Uri.parse(apiURL),
  );
  request.bodyFields = {'stdNo': studentNumber ?? '...', 'location': location ?? '...'};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    // print("$location AAAAAAAAAAAAA $studentNumber");
  } else {
    print(response.reasonPhrase);
  }
}
