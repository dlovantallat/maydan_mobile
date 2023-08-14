import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/register/login_screen.dart';
import 'package:maydan/screens/register/register_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/login.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../profile/forget_password_screen.dart';
import '../register/register.dart';

class RegisterLoginOptionScreen extends StatefulWidget {
  const RegisterLoginOptionScreen({Key? key}) : super(key: key);

  @override
  State<RegisterLoginOptionScreen> createState() =>
      _RegisterLoginOptionScreenState();
}

class _RegisterLoginOptionScreenState extends State<RegisterLoginOptionScreen> {
  final btnStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return const Color(0xFF565656);
      },
    ),
    minimumSize: MaterialStateProperty.resolveWith<Size>(
      (Set<MaterialState> states) {
        return const Size(double.infinity, 40);
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  int phoneCounter = 0;
  int passwordCounter = 0;

  bool isOther = false;

  late ApiResponse<LoginData> login;
  late ApiResponse<RegisterModel> register;

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

        /// widget.callBack.onLogin();
      }
    }
  }

  facebook() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'public_profile'
    ]); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      loading(context);

      register = await service.social(
          token: accessToken.token, isFace: true, name: "");
      if (!mounted) return;
      Navigator.pop(context);
      if (register.requestStatus) {
        setSnackBar(context, register.errorMessage);
      } else {
        if (register.statusCode == 422) {
          setSnackBar(context, register.errorMessage);
        } else if (register.statusCode == 403) {
          setSnackBar(context, register.data!.message);
        } else {
          setToken(register.data!.token);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) {
            return const MainPage(
              index: 4,
            );
          }), (route) => false);
        }
      }
    } else {
      setSnackBar(context, "There is a problem with facebook login");
    }
  }

  apple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    loading(context);

    String name = "";
    if (credential.givenName != null) {
      name = "${credential.givenName} ${credential.familyName}";
    }

    register =
        await service.social(token: credential.identityToken!, name: name);
    if (!mounted) return;
    Navigator.pop(context);
    if (register.requestStatus) {
      setSnackBar(context, register.errorMessage);
    } else {
      if (register.statusCode == 422) {
        setSnackBar(context, register.errorMessage);
      } else if (register.statusCode == 403) {
        setSnackBar(context, register.data!.message);
      } else {
        setToken(register.data!.token);

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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(onBoardingBackJpg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  onBoardingNewLogoSvg,
                  height: 140,
                  semanticsLabel: '',
                ),
                SizedBox(
                  height: 250,
                  width: 400,
                  child: Image.asset(
                    onBoarding1Png,
                    fit: BoxFit.cover,
                  ),
                ),
                if (!isOther)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (Platform.isIOS)
                        Padding(
                          padding: const EdgeInsetsDirectional.all(8.0),
                          child: SignInWithAppleButton(
                            onPressed: apple,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsetsDirectional.all(8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.resolveWith<Size>(
                              (Set<MaterialState> states) {
                                return const Size(double.infinity, 44);
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return const Color(0xFF3b5998);
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: facebook,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsetsDirectional.only(end: 8),
                                child: Icon(Icons.facebook),
                              ),
                              Text("Login with facebook"),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isOther = !isOther;
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context)!.other_option,
                            style: const TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                if (isOther)
                  Column(
                    children: [
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
                                      padding:
                                          EdgeInsetsDirectional.only(start: 16),
                                      child: Icon(Icons.phone_android_rounded),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(start: 8),
                                      child: Text("+964 (0)"),
                                    ),
                                  ],
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
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
                                      padding:
                                          EdgeInsetsDirectional.only(start: 16),
                                      child: Icon(
                                        Icons.password,
                                        color: appColor,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(start: 8),
                                      child: Text(""),
                                    ),
                                  ],
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
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
                            minimumSize:
                                MaterialStateProperty.resolveWith<Size>(
                              (Set<MaterialState> states) {
                                return const Size(double.infinity, 60);
                              },
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const Color(0x8179a207);
                                }
                                return null;
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.signup_btn,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgetPasswordScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.forget_password_btn,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isOther = !isOther;
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.other_option,
                            style: const TextStyle(color: Colors.black)),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
