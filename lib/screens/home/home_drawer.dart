import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utilities/app_utilities.dart';
import '../../utilities/locale_provider.dart';
import '../company_profile/company_list_screen.dart';
import '../my_ads/my_ads_screen.dart';
import '../profile/profile.dart';
import '../static_content/static_content_screen.dart';
import 'home_screen.dart';

class HomeDrawer extends StatefulWidget {
  final HomeDrawerListener listener;
  final DrawerCallBack callBack;
  final String languageKey;
  final ProfileData? profileData;

  const HomeDrawer({
    Key? key,
    required this.listener,
    required this.callBack,
    required this.languageKey,
    this.profileData,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with LogoutListener {
  bool isEnglish = false;
  bool isKurdish = false;
  bool isArabic = false;

  @override
  void initState() {
    checker(widget.languageKey);

    super.initState();
  }

  setLanguage(String key) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(key));

    checker(key);
    widget.callBack.returnKey(key);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(languageKey, key);
  }

  void checker(String key) {
    if (key == "en") {
      setState(() {
        isEnglish = true;
        isKurdish = false;
        isArabic = false;
      });
    } else if (key == "ar") {
      setState(() {
        isEnglish = false;
        isKurdish = false;
        isArabic = true;
      });
    } else if (key == "ps") {
      setState(() {
        isEnglish = false;
        isKurdish = true;
        isArabic = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: appColor),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 8, bottom: 32),
                    child: InkWell(
                      onTap: () {
                        widget.listener.indexListener(4);
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: const Color(0x49000000),
                              child: Image.network(
                                imageLoader(widget.profileData?.urlPhoto ?? ""),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Image(
                                  image: AssetImage(imageHolder),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8.0),
                            child: Text(
                              widget.profileData?.name ??
                                  AppLocalizations.of(context)!
                                      .home_drawer_my_profile,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(0x81acce52);
                              }
                              return Colors
                                  .white; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: !isKurdish
                            ? () {
                                Navigator.pop(context);
                                setLanguage("ps");
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.home_drawer_kurdish,
                          style: TextStyle(
                              color: !isKurdish ? appColor : Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(0x81acce52);
                              }
                              return Colors
                                  .white; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: !isArabic
                            ? () {
                                Navigator.pop(context);
                                setLanguage("ar");
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.home_drawer_arabic,
                          style: TextStyle(
                              color: !isArabic ? appColor : Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(0x81acce52);
                              }
                              return Colors
                                  .white; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: !isEnglish
                            ? () {
                                Navigator.pop(context);
                                setLanguage("en");
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.home_drawer_english,
                          style: TextStyle(
                              color: !isEnglish ? appColor : Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 24, end: 24),
            child: Column(
              children: [
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => StaticContentScreen(
                                title: AppLocalizations.of(context)!
                                    .home_drawer_about_us,
                                name: "about_us"))),
                    child: item(
                        AppLocalizations.of(context)!.home_drawer_about_us)),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CompanyListScreen())),
                    child: item(AppLocalizations.of(context)!
                        .home_drawer_company_accounts)),
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MyAdsScreen())),
                    child:
                        item(AppLocalizations.of(context)!.home_drawer_my_ads)),
                InkWell(
                    onTap: () => widget.listener.indexListener(3),
                    child: item(AppLocalizations.of(context)!
                        .home_drawer_my_favorites)),
                InkWell(
                    onTap: () async {
                      String token = await getToken();
                      if (!mounted) return;
                      if (token != "") {
                        logout(context, this);
                      }
                    },
                    child:
                        item(AppLocalizations.of(context)!.home_drawer_logout)),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => StaticContentScreen(
                                title: AppLocalizations.of(context)!
                                    .home_drawer_terms_and_conditions,
                                name: "terms_and_condition"))),
                    child: item(AppLocalizations.of(context)!
                        .home_drawer_terms_and_conditions)),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => StaticContentScreen(
                                title: AppLocalizations.of(context)!
                                    .home_drawer_privacy_policy,
                                name: "privacy_and_policy"))),
                    child: item(AppLocalizations.of(context)!
                        .home_drawer_privacy_policy)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget item(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios_outlined,
                color: Color(0x5E000000))
          ],
        ),
        const Divider(
          thickness: 1,
          color: Color(0x5E000000),
        )
      ],
    );
  }

  @override
  void onLogout() {
    Navigator.pop(context);
    setToken("");
  }
}

abstract class DrawerCallBack {
  void returnKey(String key);
}
