import 'package:flutter/material.dart';
import 'package:maydan/utilities/log_event_names.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import 'static_content_obj.dart';

class StaticContentScreen extends StatefulWidget {
  final String name;
  final String title;

  const StaticContentScreen({Key? key, required this.title, required this.name})
      : super(key: key);

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  late ApiResponse<StaticContentObj> staticContent;
  bool isLoading = false;

  @override
  void initState() {
    analytics
        .logEvent(name: leStaticContentScreen, parameters: <String, dynamic>{
      leStaticContentScreen: "Static Content Screen",
      "screen_title": widget.title,
      "screen_name": widget.name,
    });

    getStaticContent();
    super.initState();
  }

  getStaticContent() async {
    setState(() {
      isLoading = true;
    });

    String localLang = await getLanguageKeyForApi();
    staticContent = await service.getStaticContent(widget.name, localLang);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (staticContent.requestStatus) {
          return Center(
            child: Text(staticContent.errorMessage),
          );
        }

        if (staticContent.data!.message != "") {
          return Center(
            child: Text(staticContent.data!.message),
          );
        }

        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsetsDirectional.all(16),
            child: Text(
              staticContent.data!.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        );
      }),
    );
  }
}
