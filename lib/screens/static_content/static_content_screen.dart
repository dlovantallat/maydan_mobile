import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import 'static_content_obj.dart';

class StaticContentScreen extends StatefulWidget {
  final String name;

  const StaticContentScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<StaticContentObj> staticContent;
  bool isLoading = false;

  @override
  void initState() {
    getStaticContent();
    super.initState();
  }

  getStaticContent() async {
    setState(() {
      isLoading = true;
    });

    staticContent = await service.getStaticContent(widget.name);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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

        return Center(
          child: Text(staticContent.data!.name),
        );
      }),
    );
  }
}
