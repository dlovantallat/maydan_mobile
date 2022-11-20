import 'package:flutter/material.dart';

import '../../widgets/otp/otp_field.dart';
import '../../widgets/otp/style.dart';
import '../register/company_register_screen.dart';
import '../register/personal_register_screen.dart';

class OtpScreen extends StatefulWidget {
  final bool isPersonal;

  const OtpScreen({Key? key, required this.isPersonal}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 45,
                fieldStyle: FieldStyle.underline,
                outlineBorderRadius: 8,
                style: const TextStyle(fontSize: 17),
                onChanged: (pin) {
                  setState(() {});
                },
                onCompleted: (pin) {}),
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
                          builder: (_) => !widget.isPersonal
                              ? const PersonalRegisterScreen()
                              : const CompanyRegisterScreen(),
                        ));
                  },
                  child: const Text("Verify")),
            ),
          ],
        ),
      ),
    );
  }
}
