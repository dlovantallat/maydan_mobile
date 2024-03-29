import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/profile/reset_password_screen.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../../utilities/log_event_names.dart';
import '../../widgets/otp/otp_field.dart';
import 'company_register_screen.dart';
import 'personal_register_screen.dart';
import 'register.dart';

class OtpScreen extends StatefulWidget {
  final bool isPersonal;
  final bool isRest;
  final String phoneNumber;

  const OtpScreen({
    Key? key,
    required this.isPersonal,
    required this.phoneNumber,
    this.isRest = false,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late ApiResponse<OtpRespond> otpService;
  late ApiResponse<OtpRespond> otpServiceRest;
  late ApiResponse<RequestOtpRespond> otpRe;
  late ApiResponse<RequestOtpRespond> otp111;

  String otp = "";

  OtpFieldController otpController = OtpFieldController();
  final myController = TextEditingController();
  int counter = 0;

  int _start = 119;
  bool isResend = false;

  @override
  void initState() {
    analytics.logEvent(name: leOtpScreen, parameters: <String, dynamic>{
      leOtpScreen: "Otp Screen",
      "phone_number": widget.phoneNumber,
    });
    startTimer();
    super.initState();
  }

  void otpSend() async {
    loading(context);

    otp = replaceArabicNumberToEnglish(otp);

    if (widget.isRest) {
      otpServiceRest = await service.verifyChangePass(widget.phoneNumber, otp);
      if (!mounted) return;
      if (!otpServiceRest.requestStatus) {
        if (otpServiceRest.statusCode == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ResetPasswordScreen(
                        phoneNumber: widget.phoneNumber,
                        tempToken: otpServiceRest.data!.token,
                      )));
        } else {
          Navigator.pop(context);
          setSnackBar(context, AppLocalizations.of(context)!.invalid_pin_code);
        }
      } else {
        Navigator.pop(context);
        setSnackBar(context, AppLocalizations.of(context)!.invalid_pin_code);
      }
    } else {
      otpService = await service.verifyPinCode(widget.phoneNumber, otp);
      if (!mounted) return;

      if (!otpService.requestStatus) {
        if (otpService.statusCode == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => !widget.isPersonal
                    ? PersonalRegisterScreen(
                        phoneNumber: widget.phoneNumber,
                        tempToken: otpService.data!.token,
                        isPersonal: widget.isPersonal,
                      )
                    : CompanyRegisterScreen(
                        phoneNumber: widget.phoneNumber,
                        tempToken: otpService.data!.token,
                        isPersonal: widget.isPersonal,
                      ),
              ));
        } else {
          Navigator.pop(context);
          setSnackBar(context, AppLocalizations.of(context)!.invalid_pin_code);
        }
      } else {
        Navigator.pop(context);
        setSnackBar(context, AppLocalizations.of(context)!.invalid_pin_code);
      }
    }
  }

  otpRequest() async {
    otpRe = await service.requestPinCode(widget.phoneNumber, widget.isPersonal);
    if (!mounted) return;
    if (otpRe.requestStatus) {
      setSnackBar(context, otpRe.errorMessage);
    } else {
      if (otpRe.statusCode == 403) {
        setSnackBar(context, otpRe.data!.message);
      } else {
        setSnackBar(context, AppLocalizations.of(context)!.new_message);
        setState(() {
          _start = 119;
          isResend = false;
          startTimer();
        });
      }
    }
  }

  void smsSend() async {
    otp111 = await service.requestChangePass(widget.phoneNumber);

    if (!mounted) return;
    if (otp111.requestStatus) {
      setSnackBar(context, otp111.errorMessage);
    } else {
      if (otp111.statusCode == 403) {
        setSnackBar(context, "otp111.data!.message");
      } else {
        setSnackBar(context, AppLocalizations.of(context)!.new_message);
        setState(() {
          _start = 119;
          isResend = false;
          startTimer();
        });
      }
    }
  }

  void startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isResend = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
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
      body: Padding(
        padding: EdgeInsetsDirectional.only(
            start: 32, end: 32, top: (MediaQuery.of(context).size.height / 6)),
        child: Column(
          children: [
            Card(
              elevation: 8,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 64),
                        child: Text(
                          AppLocalizations.of(context)!.otp_verification,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 30,
                              fontSize: 30),
                          cursorColor: Colors.grey,
                          controller: myController,
                          maxLength: 6,
                          onChanged: (text) {
                            setState(() {
                              counter = text.length;
                            });

                            if (counter >= 6) {
                              otp = text;
                              otpSend();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            counterText: "",
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 64, start: 8, end: 8, bottom: 16),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(double.infinity, 40);
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: counter >= 6 ? otpSend : null,
                            child:
                                Text(AppLocalizations.of(context)!.otp_verify)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isResend
                ? TextButton(
                    onPressed: widget.isRest ? smsSend : otpRequest,
                    child: Text(AppLocalizations.of(context)!.send_again_btn))
                : Text(
                    "${AppLocalizations.of(context)!.trouble_sign_in}  ${formatTime(_start)}",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
