import 'package:flutter/material.dart';

import '../../utilities/app_utilities.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isTokenLoading = false;
  bool isLogin = false;
  String token = "";

  @override
  void initState() {
    tokenCheck();
    super.initState();
  }

  void tokenCheck() async {
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

  getMe() {
    print("object");
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
          print("ss");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (isLogin) {
          print("ss1");
          return Text("login");
        } else {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
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
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 8, end: 8),
                child: TextField(
                  decoration: InputDecoration(
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
                onPressed: () {},
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
