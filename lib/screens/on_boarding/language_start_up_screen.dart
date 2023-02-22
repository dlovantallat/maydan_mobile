import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/screens/on_boarding/on_boarding_screen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utilities/app_utilities.dart';
import '../../utilities/locale_provider.dart';

class LanguageStartUpScreen extends StatefulWidget {
  const LanguageStartUpScreen({Key? key}) : super(key: key);

  @override
  State<LanguageStartUpScreen> createState() => _LanguageStartUpScreenState();
}

class _LanguageStartUpScreenState extends State<LanguageStartUpScreen> {
  bool isEnglish = false;
  bool isKurdish = false;
  bool isArabic = false;

  @override
  void initState() {
    checker("en");

    super.initState();
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
    } else if (key == "ar") {
      setState(() {
        isEnglish = false;
        isKurdish = false;
        isArabic = true;
      });
    } else if (key == "ps") {
      setState(() {
        isEnglish = false;
        isKurdish = true;
        isArabic = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0x81acce52);
                            }
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: !isKurdish
                          ? () {
                              setLanguage("ps");
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_kurdish,
                        style: TextStyle(
                            color: isKurdish ? Colors.white : appColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0x81acce52);
                            }
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: !isArabic
                          ? () {
                              setLanguage("ar");
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_arabic,
                        style: TextStyle(
                            color: isArabic ? Colors.white : appColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0x81acce52);
                            }
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: !isEnglish
                          ? () {
                              setLanguage("en");
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_english,
                        style: TextStyle(
                            color: isEnglish ? Colors.white : appColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            PositionedDirectional(
              end: 16,
              bottom: 16,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OnBoardingScreen()));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.on_board_skip,
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
