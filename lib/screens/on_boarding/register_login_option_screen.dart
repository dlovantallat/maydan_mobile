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
                onBoarding1Png,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  EdgeInsetsDirectional.only(start: width / 5, end: width / 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: btnStyle,
                      onPressed: () async {
                        final ff = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));

                        if (ff == "token") {
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const MainPage()),
                              (route) => false);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login_btn,
                        style: const TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()));
                      },
                      child: Text(AppLocalizations.of(context)!.signup_btn,
                          style: const TextStyle(color: Colors.white))),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainPage()),
                            (route) => false);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.on_board_skip,
                        style: const TextStyle(color: Color(0xFF565656)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
