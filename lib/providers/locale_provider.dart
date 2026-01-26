import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale? locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if (locale == null) {
      _locale = null; // System Default
      notifyListeners();
      await prefs.remove('language_code');
      return;
    }

    if (!['en', 'es'].contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();
    await prefs.setString('language_code', locale.languageCode);
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
}
