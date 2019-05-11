import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCache {

  LanguageCache._();

  static LanguageCache instance = new LanguageCache._();

  Future<List<String>> getLanguage() async {
    return SharedPreferences.getInstance().then((prefs){
      return prefs.getStringList('language');
    });
  }

  Future<bool> setLanguage(List<String> language) async {
    return SharedPreferences.getInstance().then((prefs){
      return prefs.setStringList('language', language);
    });
  }
}