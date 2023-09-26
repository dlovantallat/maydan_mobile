import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';

initAppsFlyer() {
  AppsflyerSdk _appsflyerSdk;

  try {
    String appId = Platform.isIOS ? "1662821784" : "co.tornet.maydan";
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "MjGmUKzWdMYJ654pKjVXJ",
        appId: appId,
        showDebug: false,
        timeToWaitForATTUserAuthorization: 15);
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      // setState(() {
      //   _deepLinkData = res;
      // });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      // setState(() {
      //   _gcd = res;
      // });
    });
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      // setState(() {
      //   _deepLinkData = dp.toJson();
      // });
    });

    _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: false,
        registerOnDeepLinkingCallback: true);
  } catch (e) {
    print("Caught error");
  }
}
