import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utilities/app_utilities.dart';
import '../../utilities/locale_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isEnglish = false;
  bool isKurdish = false;
  bool isArabic = false;

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

  void getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String key = preferences.getString(languageKey) ?? "en";

    checker(key);
  }

  setLanguage(String key) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(key));

    checker(key);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(languageKey, key);
  }

  void checker(String key) {
    if (key == "en") {
      setState(() {
        isEnglish = true;
        isKurdish = false;
        isArabic = false;
      });
    } else if (key == "ps") {
      setState(() {
        isEnglish = false;
        isKurdish = true;
        isArabic = false;
      });
    } else if (key == "ar") {
      setState(() {
        isEnglish = false;
        isKurdish = false;
        isArabic = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting_language_title),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              setLanguage("en");
              Get.updateLocale(const Locale("en"));
            },
            child: Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.home_drawer_english),
                  if (isEnglish) const Icon(Icons.check)
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setLanguage("ps");
              Get.updateLocale(const Locale("ps"));
            },
            child: Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.home_drawer_kurdish),
                  if (isKurdish) const Icon(Icons.check)
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setLanguage("ar");
              Get.updateLocale(const Locale("ar"));
            },
            child: Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.home_drawer_arabic),
                  if (isArabic) const Icon(Icons.check)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
