import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/item_detail/login_screen.dart';
import 'package:maydan/screens/register/register_screen.dart';

import '../../main.dart';
import '../../utilities/app_utilities.dart';

class RegisterLoginOptionScreen extends StatefulWidget {
  const RegisterLoginOptionScreen({Key? key}) : super(key: key);

  @override
  State<RegisterLoginOptionScreen> createState() =>
      _RegisterLoginOptionScreenState();
}

class _RegisterLoginOptionScreenState extends State<RegisterLoginOptionScreen> {
  final ff = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Stack(
        children: [
          Center(
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
                ElevatedButton(
                    style: ff,
                    onPressed: () async {
                      final ff = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));

                      if (ff == "token") {
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainPage()),
                            (route) => false);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login_btn,
                      style: const TextStyle(color: appColor),
                    )),
                ElevatedButton(
                    style: ff,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()));
                    },
                    child: Text(AppLocalizations.of(context)!.signup_btn,
                        style: const TextStyle(color: appColor)))
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 32,
            end: 16,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainPage()),
                      (route) => false);
                },
                child: Text(
                  AppLocalizations.of(context)!.on_board_skip,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
