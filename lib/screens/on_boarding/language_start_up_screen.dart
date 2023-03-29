import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utilities/app_utilities.dart';
import '../../utilities/locale_provider.dart';
import 'on_boarding_screen.dart';

class LanguageStartUpScreen extends StatefulWidget {
  const LanguageStartUpScreen({Key? key}) : super(key: key);

  @override
  State<LanguageStartUpScreen> createState() => _LanguageStartUpScreenState();
}

class _LanguageStartUpScreenState extends State<LanguageStartUpScreen> {
  final ff = MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return const Color(0x81acce52);
      }
      return Colors.white; // Use the component's default.
    },
  );

  setLanguage(String key) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(key);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(languageKey, key);
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const OnBoardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 36),
              child: SvgPicture.asset(
                homeLogoSvg,
                height: 100,
                semanticsLabel: '',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ff,
                  ),
                  onPressed: () {
                    setLanguage("fa");
                    Get.updateLocale(const Locale("fa"));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.home_drawer_kurdish,
                    style: const TextStyle(color: appColor),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ff,
                  ),
                  onPressed: () {
                    setLanguage("ar");
                    Get.updateLocale(const Locale("ar"));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.home_drawer_arabic,
                    style: const TextStyle(color: appColor),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ff,
                  ),
                  onPressed: () {
                    setLanguage("en");
                    Get.updateLocale(const Locale("en"));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.home_drawer_english,
                    style: const TextStyle(color: appColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
