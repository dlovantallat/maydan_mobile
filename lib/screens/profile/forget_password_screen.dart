import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import '../register/otp_screen.dart';
import '../register/register.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  final phoneNumberController = TextEditingController();
  int phoneNumberControllerCounter = 0;

  late ApiResponse<RequestOtpRespond> otp;

  void smsSend() async {
    loading(context);

    String phoneNumber = phoneNumberController.text.trim().toString();
    otp = await service.requestChangePass(phoneNumber);

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
          isPersonal: false,
          phoneNumber: phoneNumber,
          isRest: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
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
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: phoneNumberControllerCounter >= 10 ? smsSend : null,
              child: const Text("Send"))
        ],
      ),
    );
  }
}
