import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/utilities/log_event_names.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../register/otp_screen.dart';
import '../register/register.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final phoneNumberController = TextEditingController();
  int phoneNumberControllerCounter = 0;

  late ApiResponse<RequestOtpRespond> otp;
  final oib = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
  );

  void smsSend() async {
    loading(context);

    String phoneNumber = phoneNumberController.text.trim().toString();
    otp = await service.requestChangePass(phoneNumber);

    if (!mounted) return;
    if (otp.requestStatus) {
      setSnackBar(context, otp.errorMessage);
    } else {
      if (otp.statusCode == 403) {
        setSnackBar(context, "otp.data!.message1");
      } else {
        nextScreen(phoneNumber);
      }
    }
  }

  nextScreen(String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          isPersonal: false,
          phoneNumber: phoneNumber,
          isRest: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    analytics
        .logEvent(name: leForgetPasswordScreen, parameters: <String, dynamic>{
      leForgetPasswordScreen: "Forget Password Screen",
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          AppLocalizations.of(context)!.forget_password_title_caption,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(bottom: 64, top: 32),
            child: SvgPicture.asset(
              maydanLogoSvg,
              semanticsLabel: '',
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 16),
            child: Text(
              AppLocalizations.of(context)!.forget_password_txt_caption,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                onChanged: (v) {
                  setState(() {
                    phoneNumberControllerCounter = v.trim().length;
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 16),
                          child: Icon(Icons.phone_android_rounded),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8),
                          child: Text("+964 (0)"),
                        ),
                      ],
                    ),
                  ),
                  focusedBorder: oib,
                  enabledBorder: oib,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith<Size>(
                    (Set<MaterialState> states) {
                      return const Size(double.infinity, 60);
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: phoneNumberControllerCounter >= 10 ? smsSend : null,
                child: Text(
                    AppLocalizations.of(context)!.forget_password_btn_caption)),
          )
        ],
      ),
    );
  }
}
