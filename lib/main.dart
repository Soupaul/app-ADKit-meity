import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:screen/screen.dart';
import 'package:thefirstone/resources/language_model.dart';
import 'package:thefirstone/ui/profiles.dart';
import 'l10n/l10n.dart';
import 'ui/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => LanguageModel(),
    child: MyApp(),
  ));
}

final _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var ins;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
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
    // print(_auth.currentUser!.uid);
    if (_auth != null) {
      if (_auth.currentUser != null) {
        // if (!_auth.currentUser!.uid.isEmpty)
        // return DoctorsPage();
        return Profiles();
      }
    }
    // return Profiles();
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Dialogflow Flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFFFCF0E7),
      ),
      debugShowCheckedModeBanner: false,
      home: _getScreen(),
      locale: Locale(Provider.of<LanguageModel>(context).currentLocale),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
