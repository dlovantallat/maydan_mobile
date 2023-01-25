import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../company_profile/company_widget.dart';
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

  bool isPersonal = true;

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
      if (profile.statusCode == 200) {
        if (profile.data!.userType == "P") {
          isPersonal = true;
        } else {
          isPersonal = false;
        }
      }
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
      appBar: isPersonal
          ? AppBar(
              title: Text(
                AppLocalizations.of(context)!.profile_title,
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.transparent,
            )
          : AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) {
                      return const MainPage(
                        index: 2,
                      );
                    }), (route) => false);
                  },
                  child: Chip(
                    shape: const StadiumBorder(
                        side: BorderSide(
                      width: 1,
                      color: Colors.black,
                    )),
                    backgroundColor: Colors.white,
                    label:
                        Text(AppLocalizations.of(context)!.profile_place_ads),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EditProfile(profile: profile.data!)));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 8, end: 16),
                    child: Chip(
                      shape: const StadiumBorder(
                          side: BorderSide(
                        width: 1,
                        color: Colors.black,
                      )),
                      backgroundColor: Colors.white,
                      label: Text(AppLocalizations.of(context)!.profile_edit),
                    ),
                  ),
                ),
              ],
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

          if (isPersonal) {
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
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8.0),
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
                    Expanded(
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
                        child: Center(
                          child: Text(AppLocalizations.of(context)!
                              .profile_help_center),
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
                          child: Center(
                            child: Text(AppLocalizations.of(context)!
                                .home_drawer_logout),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return CompanyWidget(
              data: profile.data!,
            );
          }
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
