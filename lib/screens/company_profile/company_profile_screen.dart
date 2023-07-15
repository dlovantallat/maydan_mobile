import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../../widgets/whatsapp_unilink.dart';
import '../profile/profile.dart';
import 'company_widget.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String id;

  const CompanyProfileScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  Future<void> _launchUrl(String adsUrl) async {
    final Uri url = Uri.parse(adsUrl);

    if (!await launchUrl(url)) {
      setSnackBar(context,
          AppLocalizations.of(context)!.url_cannot_lunch(url.toString()));
    }
  }

  launchWhatsAppUri() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+',
      text: AppLocalizations.of(context)!.viber_whatsapp_temp,
    );
    await launchUrl(link.asUri());
  }

  bool isItemLoading = false;
  late ApiResponse<ProfileData> profile;
  String key = "";

  @override
  void initState() {
    getAccount();
    super.initState();
  }

  getAccount() async {
    setState(() {
      isItemLoading = true;
    });
    key = await getLanguageKeyForApi();
    profile = await service.getCompanyId(widget.id);

    setState(() {
      isItemLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          if (!isItemLoading)
            if (profile.data!.whatsapp != "")
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    launchWhatsAppUri();
                  },
                  child: SvgPicture.asset(
                    waSvg,
                    semanticsLabel: '',
                  ),
                ),
              ),
          if (!isItemLoading)
            if (profile.data!.viber != "")
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    _launchUrl(
                        "viber://chat/?number=+${profile.data!.msisdn}&draft=${AppLocalizations.of(context)!.viber_whatsapp_temp}");
                  },
                  child: SvgPicture.asset(
                    vSvg,
                    semanticsLabel: '',
                  ),
                ),
              ),
          if (!isItemLoading)
            if (profile.data!.facebook != "")
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    _launchUrl(profile.data!.facebook!);
                  },
                  child: SvgPicture.asset(
                    fbSvg,
                    semanticsLabel: '',
                  ),
                ),
              ),
          if (!isItemLoading)
            if (profile.data!.youtube != "")
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    _launchUrl(profile.data!.youtube!);
                  },
                  child: SvgPicture.asset(
                    ytSvg,
                    semanticsLabel: '',
                  ),
                ),
              ),
          if (!isItemLoading)
            if (profile.data!.instagram != "")
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: InkWell(
                  onTap: () {
                    _launchUrl(profile.data!.instagram!);
                  },
                  child: SvgPicture.asset(
                    instagramSvg,
                    semanticsLabel: '',
                  ),
                ),
              )
        ],
      ),
      body: Builder(builder: (context) {
        if (isItemLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (profile.requestStatus) {
          return Center(
            child: Text(profile.errorMessage),
          );
        }

        return CompanyWidget(
          data: profile.data!,
          langKey: key,
        );
      }),
    );
  }
}
