import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/screens/register/register.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<RequestOtpRespond> otp;
  bool isPersonal = false;
  final phoneNumberController = TextEditingController();
  int phoneCounter = 0;

  otpRequest() async {
    String phoneNumber = phoneNumberController.text.trim();
    otp = await service.requestPinCode(phoneNumber,isPersonal);
    if (!mounted) return;
    if (otp.requestStatus) {
      setSnackBar(context, otp.errorMessage);
    } else {
      if (otp.statusCode == 403) {
        setSnackBar(context, otp.data!.message);
      } else {
        setSnackBar(context, "200: ${otp.data!.message}");
        nextScreen(phoneNumber);
      }
    }
  }

  nextScreen(String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          isPersonal: isPersonal,
          phoneNumber: phoneNumber,
        ),
      ),
    );
  }

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
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
                    child: Center(
                      child: TextField(
                        maxLength: 10,
                        controller: phoneNumberController,
                        onChanged: (v) {
                          setState(() {
                            phoneCounter = v.trim().length;
                          });
                        },
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: '750 XXX XXXX',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(top: 64, start: 16, end: 16),
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0x8179a207);
                      }
                      return null; // Use the component's default.
                    },
                  ),
                ),
                onPressed: phoneCounter >= 10 ? otpRequest : null,
                child: const Text("Continue")),
          ),
        ],
      ),
    );
  }
}
