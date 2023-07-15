import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/cloud_functions/api_response.dart';
import 'package:maydan/screens/config/config_screen.dart';
import 'package:maydan/screens/my_ads/my_ads_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_functions/maydan_services.dart';
import 'firebase_options.dart';
import 'init_appsflyer.dart';
import 'l10n/l10n.dart';
import 'screens/config/config_model.dart';
import 'screens/on_boarding/language_start_up_screen.dart';
import 'utilities/locale_provider.dart';
import 'screens/category/category_screen.dart';
import 'screens/favorite/favorite_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/post/post_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utilities/app_utilities.dart';

/// Global Variable
MaydanServices get service => GetIt.I<MaydanServices>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fire = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initializing env file to load secret variables
  await dotenv.load(fileName: ".env");

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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Navigator.push(
        Get.context!, MaterialPageRoute(builder: (_) => const MyAdsScreen()));
  });

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  servicesLocator();
  config();
}

void config() async {
  bool isUpdate = false;
  Update? update;

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String platform = Platform.isIOS ? "ios" : "android";
  String buildNumber = packageInfo.buildNumber;
  ApiResponse<Config> apiResponse =
      await service.getConfig(buildNumber, platform);

  if (!apiResponse.requestStatus) {
    if (apiResponse.statusCode == 200) {
      if (apiResponse.data!.data != null) {
        isUpdate = true;
        update = apiResponse.data!.data;
      }
    }
  }

  /// here
  String key = await getLanguageKey();
  bool isOnBoard = await getOnBoard();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider("en")),
      ],
      child: MyApp(
        langKey: key,
        isUpdate: isUpdate,
        isOnboard: isOnBoard,
        update: update,
      ),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
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
  final bool isOnboard;
  final bool isUpdate;
  final String langKey;
  final Update? update;

  const MyApp({
    super.key,
    this.langKey = "",
    this.isOnboard = false,
    this.isUpdate = false,
    this.update,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: appTheme,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      locale: Locale(langKey),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      home: isUpdate
          ? ConfigScreen(update: update)
          : isOnboard
              ? const MainPage()
              : const LanguageStartUpScreen(),
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
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   await AppTrackingTransparency.requestTrackingAuthorization();

    // });

    initAppsFlyer();

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
                    colorFilter: ColorFilter.mode(
                        currentIndex == 0 ? appColor : Colors.grey,
                        BlendMode.srcIn),
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
                SvgPicture.asset(mainCategoryBottomNavigationSvg,
                    semanticsLabel: '',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        currentIndex == 1 ? appColor : Colors.grey,
                        BlendMode.srcIn)),
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
                SvgPicture.asset(mainFavoriteBottomNavigationSvg,
                    semanticsLabel: '',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        currentIndex == 3 ? appColor : Colors.grey,
                        BlendMode.srcIn)),
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
                SvgPicture.asset(mainProfileBottomNavigationSvg,
                    semanticsLabel: '',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        currentIndex == 4 ? appColor : Colors.grey,
                        BlendMode.srcIn)),
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
