import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/screens/profile/edit_profile.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/meta_data_widget.dart';
import '../../utilities/app_utilities.dart';
import '../list_items/items_item.dart';
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
                Chip(
                  shape: const StadiumBorder(
                      side: BorderSide(
                    width: 1,
                    color: Colors.black,
                  )),
                  backgroundColor: Colors.white,
                  label: Text(AppLocalizations.of(context)!.profile_place_ads),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EditProfile(profile: profile.data!)));
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
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
            return ListView(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      width: double.infinity,
                      'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Image(
                        image: AssetImage(mainProfileBottomNavigationSvg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(10),
                              topEnd: Radius.circular(10)),
                          color: appColor,
                        ),
                        child: const Center(
                          child: Text("Cow"),
                        ),
                      ),
                      meteData(
                          AppLocalizations.of(context)!.company_phone_number,
                          "widget.data.duration widget"),
                      meteData(AppLocalizations.of(context)!.company_email,
                          "widget.data.duration widget"),
                      meteData(AppLocalizations.of(context)!.company_location,
                          "widget.data.duration widget"),
                      meteData(
                          AppLocalizations.of(context)!.company_service_type,
                          "widget.data.duration widget"),
                      meteData(AppLocalizations.of(context)!.company_code,
                          "widget.data.duration widget"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Products related to X company"),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 220),
                    itemBuilder: (BuildContext context, int index) =>
                        const ItemsItem(
                      isFav: false,
                    ),
                    itemCount: 0,
                  ),
                ),
              ],
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
