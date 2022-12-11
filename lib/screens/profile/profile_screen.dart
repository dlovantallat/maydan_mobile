import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/login.dart';
import '../../utilities/app_utilities.dart';
import '../login/login_screen.dart';
import 'profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  int phoneCounter = 0;
  int passwordCounter = 0;

  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<LoginData> login;
  late ApiResponse<ProfileData> profile;
  bool isLoading = false;
  bool isTokenLoading = false;
  bool isLogin = false;
  String token = "";

  @override
  void initState() {
    tokenCheck();
    super.initState();
  }

  tokenCheck() async {
    setState(() {
      isTokenLoading = true;
    });

    token = await getToken();
    if (token == "") {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
      getMe();
    }
    setState(() {
      isTokenLoading = false;
    });
  }

  getMe() async {
    setState(() {
      isLoading = true;
    });

    profile = await service.getMe(token);

    setState(() {
      isLoading = false;
    });
  }

  loginRequest() async {
    loading(context);
    setState(() {
      isLoading = true;
    });
    login = await service.login("+9647503231905", "12345678");
    if (!mounted) return;

    if (login.data != null) {
      if (login.data!.token != null) {
        setToken(login.data!.token!);
        tokenCheck();
        Navigator.pop(context);
      } else if (login.data!.message != null) {
        setSnackBar(context, login.data!.message!);
      } else {
        print("something wrong please check manually");
      }
    } else {
      setSnackBar(context, login.errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        if (isTokenLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (isLogin) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (profile.requestStatus) {
            return const Center(
              child: Text("error"),
            );
          }

          return Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFF1F1F1),
                ),
                margin: const EdgeInsetsDirectional.only(start: 24, end: 24),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            end: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsetsDirectional.only(
                                  start: 8, end: 8),
                              height: 50,
                              width: 50,
                              color: const Color(0xFFCACACA),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.data!.name),
                                Text(profile.data!.email),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 16, top: 8),
                        child: Text(
                          "Edit",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 16, end: 8, top: 16),
                      height: 110,
                      color: const Color(0xFFF1F1F1),
                      child: const Center(
                        child: Text("Setting"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 8, end: 16, top: 16),
                      height: 110,
                      color: const Color(0xFFF1F1F1),
                      child: const Center(
                        child: Text("About Maydan"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 16, end: 8, top: 16),
                      height: 110,
                      color: const Color(0xFFF1F1F1),
                      child: const Center(
                        child: Text("Help Center"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setToken("");
                        tokenCheck();
                      },
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 8, end: 16, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: const Center(
                          child: Text("Logout"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(8.0),
                child: TextField(
                  controller: phoneNumberController,
                  onChanged: (text) {
                    setState(() {
                      phoneCounter = phoneNumberController.text.trim().length;
                    });
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    hintText: '750 XXX XXXX',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (text) {
                    setState(() {
                      passwordCounter = passwordController.text.trim().length;
                    });
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    hintText: 'password',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: phoneCounter >= 10 && passwordCounter >= 1
                    ? loginRequest
                    : null,
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text("Register"),
              ),
            ],
          );
        }
      }),
    );
  }
}
