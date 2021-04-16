import 'package:flutter/material.dart';
import 'package:thefirstone/ui/home.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'utils/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  _getScreen() {
    return StreamBuilder(
      stream: AuthProvider.getAuth.onAuthStateChanged,
      builder: (context, snapshot) =>
          snapshot.hasData ? HomePage() : LoginPage(),
    );
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
