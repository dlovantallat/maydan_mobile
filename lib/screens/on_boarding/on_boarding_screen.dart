import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utilities/app_utilities.dart';
import 'on_boarding_item.dart';

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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage()), (route) => false);
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
                    pos == 2 ? "Get Start" : "Skip",
                    style: const TextStyle(color: Colors.black),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
