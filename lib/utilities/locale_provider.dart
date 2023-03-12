import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  String _locale;

  LocaleProvider(this._locale);

  String get local => _locale;

  void setLocale(String locale) {
    _locale = locale;
    notifyListeners();
  }
}
