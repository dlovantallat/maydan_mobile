import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../../utilities/log_event_names.dart';
import 'otp_screen.dart';
import 'register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ApiResponse<RequestOtpRespond> otp;
  bool isPersonal = false;
  final phoneNumberController = TextEditingController();
  int phoneCounter = 0;

  otpRequest() async {
    String phoneNumber =
        replaceArabicNumberToEnglish(phoneNumberController.text.trim());
    loading(context);
    otp = await service.requestPinCode(phoneNumber, isPersonal);
    if (!mounted) return;
    if (otp.requestStatus) {
      print("code ${otp.statusCode}");
      setSnackBar(context, otp.errorMessage);
    } else {
      if (otp.statusCode == 403) {
        setSnackBar(context, otp.data!.message);
      } else {
        // setSnackBar(context, "200: ${otp.data!.message}");
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
  void initState() {
    analytics.logEvent(name: leRegisterScreen, parameters: <String, dynamic>{
      leRegisterScreen: "Register Screen",
    });
    super.initState();
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
                colorFilter: const ColorFilter.mode(appColor, BlendMode.srcIn),
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
                  child: Text(AppLocalizations.of(context)!.register_p)),
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
                  child: Text(AppLocalizations.of(context)!.register_c)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.register_pn),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(start: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadiusDirectional.all(
                          Radius.circular(10)),
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
                      borderRadius: const BorderRadiusDirectional.all(
                          Radius.circular(10)),
                    ),
                    height: 40,
                    width: 100,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 4, end: 4),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.phone,
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
                child: Text(AppLocalizations.of(context)!.register_continue)),
          ),
        ],
      ),
    );
  }
}
