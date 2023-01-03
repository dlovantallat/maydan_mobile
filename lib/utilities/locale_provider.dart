import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale;

  Locale get local => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
