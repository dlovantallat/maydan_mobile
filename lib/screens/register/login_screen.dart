import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/utilities/log_event_names.dart';

import '../../main.dart';
import 'login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginCallBack {
  @override
  void initState() {
    analytics.logEvent(name: leLoginScreen, parameters: <String, dynamic>{
      leLoginScreen: "Login Screen",
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.login_title,
            style: const TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: LoginWidget(callBack: this));
  }

  @override
  void onLogin() {
    Navigator.pop(context, "token");
  }
}
