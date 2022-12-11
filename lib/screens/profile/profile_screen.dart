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
              Text("user name: ${profile.data!.name}"),
              Text("user email: ${profile.data!.email}"),
              ElevatedButton(
                onPressed: () {
                  setToken("");
                  tokenCheck();
                },
                child: const Text("logout"),
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
