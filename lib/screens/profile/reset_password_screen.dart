import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
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

  MaydanServices get service => GetIt.I<MaydanServices>();

  late ApiResponse<ChangePassword> changePassword;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(8.0),
            child: TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.password,
                  color: appColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                hintText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8.0),
            child: TextField(
              controller: passwordConfirmationController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(
                  Icons.password,
                  color: appColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                hintText: 'Password Confirmation',
              ),
            ),
          ),
          ElevatedButton(onPressed: resetPassword, child: Text("Save"))
        ],
      ),
    );
  }
}
