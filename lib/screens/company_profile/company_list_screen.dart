import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/screens/company_profile/company_item.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import 'company_obj.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CompanyObj> companies;
  bool isLoading = false;

  @override
  void initState() {
    getActiveCompanies();
    super.initState();
  }

  getActiveCompanies() async {
    setState(() {
      isLoading = true;
    });

    companies = await service.getActiveCompanies();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("hhh"),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (companies.requestStatus) {
          return Center(
            child: Text(companies.errorMessage),
          );
        }

        if (companies.data!.data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisExtent: 230),
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsetsDirectional.only(top: 8, start: 8, end: 8),
            child: CompanyItem(
              data: companies.data!.data[index],
            ),
          ),
          itemCount: companies.data!.data.length,
        );
      }),
    );
  }
}
