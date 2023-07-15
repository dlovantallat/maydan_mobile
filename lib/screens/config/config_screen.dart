import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import 'config_model.dart';

class ConfigScreen extends StatefulWidget {
  final Update? update;

  const ConfigScreen({super.key, this.update});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  void openStores() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid
          ? widget.update!.androidStoreLinkPackage
          : widget.update!.appleStoreLinkAppId;
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.config_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
              child: Text(
                widget.update!.title.en,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 16, bottom: 32, start: 16, end: 16),
              child: Text(
                widget.update!.content.en,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            ElevatedButton(onPressed: openStores, child: const Text("Update")),
            if (widget.update!.updateMethod != "force")
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) {
                          return const MainPage();
                        },
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text("Continue"))
          ],
        ),
      ),
    );
  }
}
