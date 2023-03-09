import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../static_content/static_content_screen.dart';
import 'language_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Setting",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
        child: Column(
          children: [
            InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen())),
                child:
                    item(AppLocalizations.of(context)!.setting_language_title)),
          ],
        ),
      ),
    );
  }

  Widget item(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios_outlined,
                color: Color(0x5E000000))
          ],
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(top: 16, bottom: 16),
          child: Divider(
            thickness: 1,
            color: Color(0x5E000000),
          ),
        )
      ],
    );
  }
}
