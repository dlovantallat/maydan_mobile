import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'cloud_functions/maydan_services.dart';
import 'screens/category/category_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utilities/app_utilities.dart';

void main() {
  servicesLocator();
  runApp(const MyApp());
}

void servicesLocator() {
  GetIt.I.registerLazySingleton(() => MaydanServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: appTheme,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
    const CategoryScreen(),
    const PostScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (pos) => setState(() {
          currentIndex = pos;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  SvgPicture.asset(
                    mainHomeBottomNavigationSvg,
                    semanticsLabel: '',
                    height: 24,
                    width: 24,
                    color: currentIndex == 0 ? appColor : null,
                  ),
                  Text(
                    "Home",
                    style:
                        TextStyle(color: currentIndex == 0 ? appColor : null),
                  ),
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  mainCategoryBottomNavigationSvg,
                  semanticsLabel: '',
                  height: 24,
                  width: 24,
                  color: currentIndex == 1 ? appColor : null,
                ),
                Text(
                  "Category",
                  style: TextStyle(color: currentIndex == 1 ? appColor : null),
                ),
              ],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              mainPostBottomNavigationSvg,
              semanticsLabel: '',
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  mainFavoriteBottomNavigationSvg,
                  semanticsLabel: '',
                  height: 24,
                  width: 24,
                  color: currentIndex == 3 ? appColor : null,
                ),
                Text(
                  "Favorite",
                  style: TextStyle(color: currentIndex == 3 ? appColor : null),
                ),
              ],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  mainProfileBottomNavigationSvg,
                  semanticsLabel: '',
                  height: 24,
                  width: 24,
                  color: currentIndex == 4 ? appColor : null,
                ),
                Text(
                  "Profile",
                  style: TextStyle(color: currentIndex == 4 ? appColor : null),
                ),
              ],
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
