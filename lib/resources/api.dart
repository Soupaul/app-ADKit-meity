import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static String _baseURL = 'https://d6fe3d202f13.ngrok.io/api';

  static Future processVideo() async {
    String url = '$_baseURL/processVideo';

    Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'URL':
            "https://firebasestorage.googleapis.com/v0/b/adkit-demo.appspot.com/o/e7_n1.mp4?alt=media&token=3e7b8ccc-219b-43cb-a4c9-8f670ad60b17",
        'AGE': "40",
        'GENDER': "0",
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['val'].toString());
    }
  }
}
