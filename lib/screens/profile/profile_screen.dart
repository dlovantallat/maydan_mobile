import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../setting/setting_screen.dart';
import '../static_content/static_content_screen.dart';
import 'delete_profile_screen.dart';
import 'edit_profile.dart';
import '../register/login_widget.dart';
import 'profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with LoginCallBack, LogoutListener {
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.data!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      profile.data!.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 8),
                              child: SvgPicture.asset(
                                settingSvg,
                                semanticsLabel: '',
                              ),
                            ),
                            Text(AppLocalizations.of(context)!.profile_setting),
                          ],
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 8),
                              child: SvgPicture.asset(
                                aboutMaydanSvg,
                                semanticsLabel: '',
                              ),
                            ),
                            Text(
                                AppLocalizations.of(context)!.profile_about_us),
                          ],
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DeleteProfileScreen(
                                      msisdn: profile.data!.msisdn,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 16, end: 8, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 8),
                              child: SvgPicture.asset(
                                deleteAccountSvg,
                                semanticsLabel: '',
                              ),
                            ),
                            Text(AppLocalizations.of(context)!
                                .delete_account_title),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        logout(context, this);
                      },
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 8, end: 16, top: 16),
                        height: 110,
                        color: const Color(0xFFF1F1F1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 8),
                              child: SvgPicture.asset(
                                logoutSvg,
                                semanticsLabel: '',
                              ),
                            ),
                            Text(AppLocalizations.of(context)!
                                .home_drawer_logout),
                          ],
                        ),
                      ),
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
