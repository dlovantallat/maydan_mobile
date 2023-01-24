import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import '../../widgets/otp/otp_field.dart';
import '../../widgets/otp/style.dart';
import 'company_register_screen.dart';
import 'personal_register_screen.dart';
import 'register.dart';

class OtpScreen extends StatefulWidget {
  final bool isPersonal;
  final String phoneNumber;

  const OtpScreen({
    Key? key,
    required this.isPersonal,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<OtpRespond> otpService;

  String otp = "";
  int otpNumberControllerCounter = 0;
  OtpFieldController otpController = OtpFieldController();

  void otpSend() async {
    loading(context);

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
      }
    }
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
        padding: const EdgeInsetsDirectional.only(start: 32, end: 32),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.only(top: 64),
              child: Text(
                "Verification",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.underline,
                outlineBorderRadius: 8,
                style: const TextStyle(fontSize: 17),
                onChanged: (pin) {
                  setState(() {
                    otpNumberControllerCounter = pin.length;
                  });
                },
                onCompleted: (pin) {
                  otp = pin;
                }),
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
                  onPressed: otpNumberControllerCounter >= 6 ? otpSend : null,
                  child: const Text("Verify")),
            ),
          ],
        ),
      ),
    );
  }
}
