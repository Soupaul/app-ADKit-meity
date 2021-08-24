import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static String _baseURL = 'https://c72173ad250f.ngrok.io/api';
  static Reference _firebaseStorageRef = FirebaseStorage.instance.ref();

  static Future<double?> processVideo(
      String filePath, String age, String gender) async {
    String url = '$_baseURL/processVideo';
    print(url);

    Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "URL": filePath,
        // "URL":
        //     "https://firebasestorage.googleapis.com/v0/b/adkit-demo.appspot.com/o/e7_n1.mp4?alt=media&token=3e7b8ccc-219b-43cb-a4c9-8f670ad60b17",
        "AGE": age,
        "GENDER": gender
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['val'].toStringAsFixed(2));

      return body['val'];
    }

    return null;
  }

  static Future<double?> dummy() async {
    String url = "https://mocki.io/v1/c9a3b173-a44f-4293-8672-d4d063431a60";

    Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['val']);

      return double.parse(body['val']);
    }

    return null;
  }

  static UploadTask? uploadVideo(File file) {
    try {
      var storagePath = _firebaseStorageRef.child(
          'VideoG' + new DateTime.now().millisecondsSinceEpoch.toString());
      return storagePath.putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }

  static void addResult(double hb) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('results')
        .add({
      "hb_val": hb,
      "time": DateTime.now(),
    });
  }
}
