import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageModel extends ChangeNotifier {
  String _currentLocale = "en";

  String get currentLocale => _currentLocale;
  List<Map<String, dynamic>> get locales => _locales;

  final List<Map<String, dynamic>> _locales = [
    {"lang": "English", "locale": "en"},
    {"lang": "हिंदी", "locale": "hi"},
    {"lang": "বাংলা", "locale": "bn"},
  ];

  LanguageModel() {
    SharedPreferences.getInstance().then((prefs) {
      _currentLocale = prefs.getString("locale") ?? "en";
      notifyListeners();
    });
  }

  set setLocale(String locale) {
    _currentLocale = locale;
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString("locale", locale);
    });
    notifyListeners();
  }
}
