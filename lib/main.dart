import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_functions/maydan_services.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'screens/on_boarding/on_boarding_screen.dart';
import 'utilities/locale_provider.dart';
import 'screens/category/category_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utilities/app_utilities.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fire = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  // ios foreground notification
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (kDebugMode) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification!.title}');
    }

    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also contained a notification: ${message.notification}');
      }
    }
  });

  if (kDebugMode) {
    print("firebase: ${fire.name}");
    print("firebase: ${fire.options.projectId}");
  }

  // getDeviceToken();

  servicesLocator();

  String key = await getLanguageKey();
  bool isOnBoard = await getOnBoard();
  Locale locale = Locale(key);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(
        locale: locale,
        isOnboard: isOnBoard,
      ),
    ),
  );
}

void getDeviceToken() async {
  await FirebaseMessaging.instance
      .getToken()
      .then((token) => print("token: $token"));
}

void servicesLocator() {
  GetIt.I.registerLazySingleton(() => MaydanServices());
}

Future<bool> getOnBoard() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isOnBoard = preferences.getBool(onBoardKey) ?? false;
  return isOnBoard;
}

class MyApp extends StatelessWidget {
  bool isFirst = true;
  Locale? locale;
  bool isOnboard;

  MyApp({super.key, this.locale, this.isOnboard = false});

  @override
  Widget build(BuildContext context) {
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
      home: isOnboard ? const MainPage() : const OnBoardingScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int index;

  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with HomeDrawerListener {
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

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
                    AppLocalizations.of(context)!.main_bottom_navigation_home,
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
                  AppLocalizations.of(context)!.main_bottom_navigation_category,
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
                  AppLocalizations.of(context)!.main_bottom_navigation_favorite,
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
                  AppLocalizations.of(context)!.main_bottom_navigation_profile,
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
