import 'package:flutter/material.dart';

/// imageLoader is a helper method for loading image from API
/// imageName is a string parameter which we retrieving from API
/// and combining with base url
String imageLoader(String imageName) {
  return "http://192.168.30.131:8000/api/storage/app/public/image/$imageName";
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
