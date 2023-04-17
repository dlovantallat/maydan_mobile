import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utilities/app_utilities.dart';
import '../../utilities/locale_provider.dart';
import 'register_login_option_screen.dart';

class LanguageStartUpScreen extends StatefulWidget {
  const LanguageStartUpScreen({Key? key}) : super(key: key);

  @override
  State<LanguageStartUpScreen> createState() => _LanguageStartUpScreenState();
}

class _LanguageStartUpScreenState extends State<LanguageStartUpScreen> {
  final btnStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return const Color(0xFF565656);
      },
    ),
    minimumSize: MaterialStateProperty.resolveWith<Size>(
      (Set<MaterialState> states) {
        return const Size(double.infinity, 40);
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );

  setLanguage(String key) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(key);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(languageKey, key);
    preferences.setBool(onBoardKey, true);
    if (!mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const RegisterLoginOptionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(onBoardingBackJpg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                onBoardingNewLogoSvg,
                height: 140,
                semanticsLabel: '',
              ),
              SizedBox(
                height: 250,
                width: 400,
                child: Image.asset(
                  onBoarding2Png,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: width / 5, end: width / 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        setLanguage("fa");
                        Get.updateLocale(const Locale("fa"));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_kurdish,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        setLanguage("ar");
                        Get.updateLocale(const Locale("ar"));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_arabic,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        setLanguage("en");
                        Get.updateLocale(const Locale("en"));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.home_drawer_english,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
