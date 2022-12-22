import 'package:flutter/material.dart';
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

/// Static Strings for static values
const String appToken = "app-token";

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
          title: const Center(child: Text("Logout")),
          content: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(top: 8, bottom: 16),
                    child: Text("Are you sure of logout"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      listener.onLogout();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFEB5757),
                      ),
                      minimumSize: MaterialStateProperty.resolveWith<Size>(
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
                  TextButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith<Size>(
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
                ],
              ),
            ],
          ),
        );
      },
      barrierDismissible: true);
}

abstract class LogoutListener {
  void onLogout();
}
