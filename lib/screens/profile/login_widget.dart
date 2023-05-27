import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/profile/forget_password_screen.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/login.dart';
import '../../utilities/app_utilities.dart';
import '../register/register_screen.dart';

class LoginWidget extends StatefulWidget {
  final LoginCallBack callBack;

  const LoginWidget({Key? key, required this.callBack}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  int phoneCounter = 0;
  int passwordCounter = 0;

  MaydanServices get service => GetIt.I<MaydanServices>();

  late ApiResponse<LoginData> login;

  loginRequest() async {
    loading(context);

    String phone =
        replaceArabicNumberToEnglish(phoneNumberController.text.trim());
    String password = passwordController.text.trim();
    login = await service.login(phone, password);
    if (!mounted) return;

    if (login.requestStatus) {
      Navigator.pop(context);
      setSnackBar(context, login.errorMessage);
    } else {
      Navigator.pop(context);
      if (login.statusCode == 401) {
        setSnackBar(context, AppLocalizations.of(context)!.invalid_credentials);
      } else {
        setToken(login.data!.token!);
        setUserName(login.data!.userData!.name!);
        setUserPhone(login.data!.userData!.phone!);
        widget.callBack.onLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(bottom: 64, top: 32),
            child: SvgPicture.asset(
              maydanLogoSvg,
              semanticsLabel: '',
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(8.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                onChanged: (v) {
                  setState(() {
                    phoneCounter = v.trim().length;
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
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: passwordController,
                onChanged: (v) {
                  setState(() {
                    passwordCounter = v.trim().length;
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
                          child: Icon(
                            Icons.password,
                            color: appColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 8),
                          child: Text(""),
                        ),
                      ],
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 16, end: 16, top: 16, bottom: 16),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith<Size>(
                  (Set<MaterialState> states) {
                    return const Size(double.infinity, 60);
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return const Color(0x8179a207);
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
              onPressed: phoneCounter >= 10 && passwordCounter >= 1
                  ? loginRequest
                  : null,
              child: Text(AppLocalizations.of(context)!.login_btn),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              child: Text(
                AppLocalizations.of(context)!.signup_btn,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              )),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgetPasswordScreen()));
              },
              child: Text(
                AppLocalizations.of(context)!.forget_password_btn,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
              )),
        ],
      ),
    );
  }
}

abstract class LoginCallBack {
  void onLogin();
}
