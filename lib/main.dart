import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'cloud_functions/maydan_services.dart';
import 'l10n/l10n.dart';
import 'utilities/locale_provider.dart';
import 'screens/category/category_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utilities/app_utilities.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  servicesLocator();

  String key = await getLanguageKey();
  Locale locale = Locale(key);

  runApp(MyApp(
    locale: locale,
  ));
}

void servicesLocator() {
  GetIt.I.registerLazySingleton(() => MaydanServices());
}

class MyApp extends StatelessWidget {
  bool isFirst = true;
  Locale? locale;

  MyApp({super.key, this.locale});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          if (isFirst) {
            provider.setLocale(locale!);
            isFirst = false;
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: appTheme,
              appBarTheme: const AppBarTheme(elevation: 0),
            ),
            locale: provider.local,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            home: const MainPage(),
          );
        },
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with HomeDrawerListener {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      HomeScreen(
        listener: this,
      ),
      const CategoryScreen(),
      const PostScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: children[currentIndex],
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
                  AppLocalizations.of(context)!.helloWorld,
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

  @override
  void indexListener(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
