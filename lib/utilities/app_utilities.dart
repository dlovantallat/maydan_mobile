import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// imageLoader is a helper method for loading image from API
/// imageName is a string parameter which we retrieving from API
/// and combining with base url
String imageLoader(String imageName) {
  return "https://devmaydan.s3.eu-central-1.amazonaws.com/$imageName";
}

/// Application base color
const Color appColor = Color(0xFF79a207);

/// Application base theme
MaterialColor appTheme = const MaterialColor(0xFF79a207, {
  50: appColor,
  100: appColor,
  200: appColor,
  300: appColor,
  400: appColor,
  500: appColor,
  600: appColor,
  700: appColor,
  800: appColor,
  900: appColor,
});

/// static Logos and Images path

const String noInternet = 'assets/no_internet.png';
const String imageHolder = 'assets/image_holder.jpeg';
const String mainPostBottomNavigationSvg = 'assets/post.svg';
const String mainCategoryBottomNavigationSvg = 'assets/category.svg';
const String mainHomeBottomNavigationSvg = 'assets/home.svg';
const String mainFavoriteBottomNavigationSvg = 'assets/favorite.svg';
const String mainFullFavoriteBottomNavigationSvg = 'assets/full_favorite.svg';
const String mainProfileBottomNavigationSvg = 'assets/profile.svg';
const String homeLogoSvg = 'assets/logo.svg';
const String favBoarderSvg = 'assets/fav_border.svg';
const String shareSvg = 'assets/share.svg';
const String editProfileSvg = 'assets/edit_profile.svg';
const String maydanLogoSvg = 'assets/maydan_logo.svg';
const String removeImageSvg = 'assets/remove_image.svg';
const String soldOutPng = 'assets/sold_out.png';
const String oneOnBoardPng = 'assets/one.png';
const String twoOnBoardPng = 'assets/two.png';
const String threeOnBoardPng = 'assets/three.png';
const String fbSvg = 'assets/fb.svg';
const String instagramSvg = 'assets/instagram.svg';
const String ytSvg = 'assets/youtube.svg';
const String waSvg = 'assets/whatsapp.svg';
const String vSvg = 'assets/viber.svg';

/// Static Strings for static values
const String appToken = "app-token";
const String languageKey = "languageKey";
const String onBoardKey = "onBoard";

/// Static functions

void setToken(String token) async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Write value
  prefs.setString(appToken, token);
}

Future<String> getToken() async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Read value
  return prefs.getString(appToken) ?? "";
}

Future<String> getLanguageKey() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String key = preferences.getString(languageKey) ?? "en";
  return key;
}

Future<String> getLanguageKeyForApi() async {
  String key = await getLanguageKey();
  if (key == 'ps') {
    key = 'ckb';
  }
  return key;
}

void setSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void loading(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/loading.gif'),
            ),
          ],
        ),
      );
    },
  );
}

logout(BuildContext context, LogoutListener listener) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(""),
          content: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(top: 8, bottom: 16),
                    child: Text("Are you sure of logout"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            listener.onLogout();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              appColor,
                            ),
                            minimumSize:
                                MaterialStateProperty.resolveWith<Size>(
                              (Set<MaterialState> states) {
                                return const Size(
                                  double.infinity,
                                  40,
                                );
                              },
                            ),
                          ),
                          child: Text("Logout".toUpperCase()),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8.0),
                          child: OutlinedButton(
                            style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(
                                    double.infinity,
                                    40,
                                  );
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("cancel".toUpperCase()),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
      barrierDismissible: true);
}

dateFormat(String date) {
  return DateFormat("d MMM yyyy").format(DateTime.parse(date));
}

Future<File> customCompress(File image) async {
  var path = FlutterNativeImage.compressImage(image.absolute.path,
      quality: 30, percentage: 50);
  return path;
}

abstract class LogoutListener {
  void onLogout();
}
