import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/login.dart';
import '../../utilities/app_utilities.dart';
import '../login/register_screen.dart';

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

    login = await service.login("+9647503231905", "12345678");
    if (!mounted) return;

    if (login.data != null) {
      if (login.data!.token != null) {
        setToken(login.data!.token!);
        widget.callBack.onLogin();
        //tokenCheck();
        Navigator.pop(context);
      } else if (login.data!.message != null) {
        setSnackBar(context, login.data!.message!);
      } else {
        print("something wrong please check manually");
      }
    } else {
      setSnackBar(context, login.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
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
            child: const Text("Login"),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()));
            },
            child: const Text(
              "Sign Up",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )),
        TextButton(
            onPressed: () {},
            child: const Text(
              "Forget Password",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )),
      ],
    );
  }
}

abstract class LoginCallBack {
  void onLogin();
}
