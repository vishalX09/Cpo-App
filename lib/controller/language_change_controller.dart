import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? appLocale;

  LanguageChangeController() {
    _loadLocale();
  }


  Future<void> _loadLocale() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString('language_code');

    if (languageCode != null) {
      appLocale = Locale(languageCode);
    } else {
      appLocale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (type == const Locale('en')) {
      appLocale = const Locale('en');
      await sp.setString('language_code', 'en');
    } else {
      appLocale = const Locale('hi');
      await sp.setString('language_code', 'hi');
    }
    notifyListeners();
  }
}
