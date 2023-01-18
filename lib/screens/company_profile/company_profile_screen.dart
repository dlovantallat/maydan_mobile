import 'package:flutter/material.dart';

import '../profile/profile.dart';
import 'company_widget.dart';

class CompanyProfileScreen extends StatefulWidget {
  final ProfileData data;

  const CompanyProfileScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: CompanyWidget(data: widget.data),
    );
  }
}
