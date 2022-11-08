import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'screens/category/category_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utilities/app_utilities.dart';

void main() {
  runApp(const MyApp());
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
                children: const [
                  Icon(Icons.home),
                  Text("Home"),
                ],
              ),
              label: ""),
          BottomNavigationBarItem(
            icon: Column(
              children: const [
                Icon(Icons.category),
                Text("Category"),
              ],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/post.svg',
              semanticsLabel: '',
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: const [
                Icon(Icons.favorite),
                Text("Favorite"),
              ],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: const [
                Icon(Icons.account_circle),
                Text("Profile"),
              ],
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
