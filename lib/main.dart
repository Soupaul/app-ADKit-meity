import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/ui/choose_nail_palm.dart';
import 'package:thefirstone/ui/doctors.dart';
import 'package:thefirstone/ui/home.dart';
import 'package:thefirstone/ui/select_language.dart';
import 'ui/home.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/login.dart';
import 'utils/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var ins;

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.microphone
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  _getScreen() {
    if (FirebaseAuth.instance != null) {
      if (FirebaseAuth.instance.currentUser != null) {
        if (!FirebaseAuth.instance.currentUser!.uid.isEmpty)
          return DoctorsPage();
        // return HomePage();
      }
    }

    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Example Dialogflow Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFFFCF0E7),
      ),
      debugShowCheckedModeBanner: false,
      home: _getScreen(),
    );
  }
}
