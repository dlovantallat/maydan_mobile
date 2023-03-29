import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/app_utilities.dart';
import 'on_boarding_item.dart';
import 'register_login_option_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int pos = 0;

  void skip() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(onBoardKey, true);

    if (!mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const RegisterLoginOptionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                pos = index;
              });
            },
            children: const <Widget>[
              OnBoardItem(
                image: oneOnBoardPng,
              ),
              OnBoardItem(
                image: twoOnBoardPng,
              ),
              OnBoardItem(
                image: threeOnBoardPng,
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 40, end: 16),
              child: TextButton(
                  onPressed: skip,
                  child: Text(
                    pos == 2
                        ? AppLocalizations.of(context)!.on_board_get_start
                        : AppLocalizations.of(context)!.on_board_skip,
                    style: const TextStyle(color: Colors.black),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
