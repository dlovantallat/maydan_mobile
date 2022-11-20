import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/app_utilities.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPersonal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsetsDirectional.only(bottom: 64),
              child: SvgPicture.asset(
                height: 90,
                homeLogoSvg,
                color: appColor,
                semanticsLabel: '',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (isPersonal) {
                          return const Color(0xFFF1F1F1);
                        }
                        return null; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isPersonal = !isPersonal;
                    });
                  },
                  child: const Text("Personal account")),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (!isPersonal) {
                          return const Color(0xFFF1F1F1);
                        }
                        return null; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isPersonal = !isPersonal;
                    });
                  },
                  child: const Text("Company account")),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Phone number"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(start: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius:
                        const BorderRadiusDirectional.all(Radius.circular(10)),
                  ),
                  height: 40,
                  width: 100,
                  child: const Center(child: Text("+964 (0)")),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius:
                        const BorderRadiusDirectional.all(Radius.circular(10)),
                  ),
                  height: 40,
                  width: 100,
                  child: const Padding(
                    padding: EdgeInsetsDirectional.only(start: 4, end: 4),
                    child: Center(
                        child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '750 XXX XXXX',
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 64, start: 8, end: 8),
            child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith<Size>(
                    (Set<MaterialState> states) {
                      return const Size(double.infinity, 40);
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OtpScreen(
                                isPersonal: isPersonal,
                              )));
                },
                child: const Text("Continue")),
          ),
        ],
      ),
    );
  }
}
