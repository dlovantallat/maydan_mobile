import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../../utilities/log_event_names.dart';
import '../register/register.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  final String tempToken;

  const ResetPasswordScreen(
      {Key? key, required this.phoneNumber, required this.tempToken})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  late ApiResponse<ChangePassword> changePassword;
  final oib = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
  );

  void resetPassword() async {
    String password = passwordController.text.trim().toString();
    String passwordConfirmation =
        passwordConfirmationController.text.trim().toString();

    if (password.isEmpty) {
      setSnackBar(context, "Please enter a password");
      return;
    }

    if (password != passwordConfirmation) {
      setSnackBar(
          context, "Confirmed Password must be exactly the same as password");
      return;
    }

    loading(context);
    changePassword = await service.changePassword(
      widget.tempToken,
      "964${widget.phoneNumber}",
      password,
    );
    if (!mounted) return;

    if (changePassword.requestStatus) {
      setSnackBar(context, changePassword.errorMessage);
    } else {
      if (changePassword.statusCode == 422) {
        setSnackBar(context, changePassword.errorMessage);
      } else if (changePassword.statusCode == 403) {
        setSnackBar(context, changePassword.data!.message);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 4,
          );
        }), (route) => false);
      }
    }
  }

  @override
  void initState() {
    analytics
        .logEvent(name: leResetPasswordScreen, parameters: <String, dynamic>{
      leResetPasswordScreen: "Reset Password Screen",
      "user_phone": widget.phoneNumber,
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
          AppLocalizations.of(context)!.reset_password_title,
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
            padding: const EdgeInsetsDirectional.only(
                bottom: 8, top: 8, start: 16, end: 16),
            child: TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(
                  Icons.password,
                  color: appColor,
                ),
                focusedBorder: oib,
                enabledBorder: oib,
                hintText: AppLocalizations.of(context)!.reset_password_pass_htn,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                bottom: 8, top: 8, start: 16, end: 16),
            child: TextField(
              controller: passwordConfirmationController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(
                  Icons.password,
                  color: appColor,
                ),
                focusedBorder: oib,
                enabledBorder: oib,
                hintText:
                    AppLocalizations.of(context)!.reset_password_pass_con_htn,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
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
              onPressed: resetPassword,
              child: Text(AppLocalizations.of(context)!.reset_btn_save),
            ),
          )
        ],
      ),
    );
  }
}
