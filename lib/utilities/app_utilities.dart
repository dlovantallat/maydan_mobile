import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// imageLoader is a helper method for loading image from API
/// imageName is a string parameter which we retrieving from API
/// and combining with base url
String imageLoader(String imageName) {
  return "https://maydan.s3.eu-central-1.amazonaws.com/$imageName";
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
const String soldOutPngEn = 'assets/soldout_en.png';
const String soldOutPngAr = 'assets/soldout_ar.png';
const String soldOutPngCkb = 'assets/soldout_ckb.png';
const String oneOnBoardPng = 'assets/one.png';
const String twoOnBoardPng = 'assets/two.png';
const String threeOnBoardPng = 'assets/three.png';
const String fbSvg = 'assets/fb.svg';
const String instagramSvg = 'assets/instagram.svg';
const String ytSvg = 'assets/youtube.svg';
const String waSvg = 'assets/whatsapp.svg';
const String vSvg = 'assets/viber.svg';
const String aboutMaydanSvg = "assets/about.svg";
const String deleteAccountSvg = "assets/delete_account.svg";
const String logoutSvg = "assets/logout.svg";
const String settingSvg = "assets/setting.svg";
const String onBoardingNewLogoSvg = "assets/on_boarding_new_logo.svg";
const String onBoardingBackJpg = "assets/on_boarding_back.jpg";
const String onBoarding1Png = "assets/on_board_1.png";
const String onBoarding2Png = "assets/on_board_2.png";

/// Static Strings for static values
const String appToken = "app-token";
const String userName = "user-name";
const String userPhone = "user-phone";
const String userTypeKey = "user-type";
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

void setUserName(String name) async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Write value
  prefs.setString(userName, name);
}

Future<String> getUserName() async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Read value
  return prefs.getString(userName) ?? "";
}

void setUserPhone(String phone) async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Write value
  prefs.setString(userPhone, phone);
}

void setUserType(String userType) async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Write value
  prefs.setString(userTypeKey, userType);
}

Future<String> getUserType() async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Read value
  return prefs.getString(userTypeKey) ?? "P";
}

Future<String> getUserPhone() async {
  // Create storage
  final prefs = await SharedPreferences.getInstance();
  // Read value
  return prefs.getString(userPhone) ?? "";
}

Future<String> getLanguageKey() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String key = preferences.getString(languageKey) ?? "en";
  return key;
}

Future<String> getLanguageKeyForApi() async {
  String key = await getLanguageKey();
  if (key == 'fa') {
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
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 8, bottom: 16),
                    child:
                        Text(AppLocalizations.of(context)!.logout_title_popup),
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
                          child: Text(AppLocalizations.of(context)!
                              .log_out_btn
                              .toUpperCase()),
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
                            child: Text(AppLocalizations.of(context)!
                                .cancel
                                .toUpperCase()),
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

String replaceArabicNumberToEnglish(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }
  return input;
}

String currencyFormat(String type, String price) {
  final dollar = NumberFormat("#,##0.00", "en_US");
  final dinar = NumberFormat("#,##0", "ar_IQ");

  if (type == "U") {
    return "${dollar.format(double.parse(price))} \$";
  } else {
    return "${dinar.format(double.parse(price))} IQD";
  }
}

abstract class LogoutListener {
  void onLogout();
}
