import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/setting/setting_screen.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import '../static_content/static_content_screen.dart';
import 'edit_profile.dart';
import 'login_widget.dart';
import 'profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with LoginCallBack, LogoutListener {
  MaydanServices get service => GetIt.I<MaydanServices>();

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

    if (!profile.requestStatus) {
      if (profile.statusCode == 401) {
        setToken("");
        tokenCheck();
      }
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
        title: Text(
          AppLocalizations.of(context)!.profile_title,
          style: const TextStyle(color: Colors.black),
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
                            const Padding(
                              padding: EdgeInsetsDirectional.only(start: 8.0),
                              child: SizedBox(),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                height: 50,
                                width: 50,
                                color: const Color(0xFFFFFFFF),
                                child: Image.network(
                                  imageLoader(profile.data!.urlPhoto),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.account_circle),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(profile.data!.name),
                                  Text(profile.data!.email),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EditProfile(profile: profile.data!)));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.profile_edit,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingScreen())),
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 16, end: 8, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.profile_setting),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => StaticContentScreen(
                                  title: AppLocalizations.of(context)!
                                      .home_drawer_about_us,
                                  name: "about_us"))),
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 8, end: 16, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.profile_about_us),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        logout(context, this);
                      },
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 16, end: 8, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.home_drawer_logout),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 8, end: 16, top: 16),
                      height: 110,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return LoginWidget(
            callBack: this,
          );
        }
      }),
    );
  }

  @override
  void onLogin() {
    tokenCheck();
  }

  @override
  void onLogout() {
    Navigator.pop(context);
    setToken("");
    tokenCheck();
  }
}
