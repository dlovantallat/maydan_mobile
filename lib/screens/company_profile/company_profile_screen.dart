import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/utilities/app_utilities.dart';
import 'package:url_launcher/url_launcher.dart';

import '../profile/profile.dart';
import 'company_widget.dart';

class CompanyProfileScreen extends StatefulWidget {
  final ProfileData data;

  const CompanyProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  Future<void> _launchUrl(String adsUrl) async {
    final Uri url = Uri.parse(adsUrl);

    if (!await launchUrl(url)) {
      setSnackBar(context, 'Could not launch $url');
    }
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
          if (widget.data.facebook != "")
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: InkWell(
                onTap: () {
                  _launchUrl(widget.data.facebook!);
                },
                child: SvgPicture.asset(
                  fbSvg,
                  semanticsLabel: '',
                ),
              ),
            ),
          if (widget.data.youtube != "")
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: InkWell(
                onTap: () {
                  _launchUrl(widget.data.youtube!);
                },
                child: SvgPicture.asset(
                  ytSvg,
                  semanticsLabel: '',
                ),
              ),
            ),
          if (widget.data.whatsapp != "")
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: InkWell(
                onTap: () {
                  _launchUrl(widget.data.instagram!);
                },
                child: SvgPicture.asset(
                  instagramSvg,
                  semanticsLabel: '',
                ),
              ),
            )
        ],
      ),
      body: CompanyWidget(data: widget.data),
    );
  }
}
