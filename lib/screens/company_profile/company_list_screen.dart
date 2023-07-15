import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../main.dart';
import '../profile/profile.dart';
import 'company_item.dart';
import 'company_obj.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  late ApiResponse<CompanyObj> companies;
  bool isLoading = false;

  String token = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ProfileData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;

  @override
  void initState() {
    getActiveCompanies();
    super.initState();
  }

  getActiveCompanies() async {
    setState(() {
      isLoading = true;
    });

    companies = await service.getActiveCompanies(currentPage);

    if (!companies.requestStatus) {
      if (companies.statusCode == 200) {
        data.addAll(companies.data!.data);
        currentPage++;
        totalPage = companies.data!.lastPage;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetMyItems() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }

    companies = await service.getActiveCompanies(currentPage);
    data.addAll(companies.data!.data);
    currentPage++;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.company_list_title),
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

        if (data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return SmartRefresher(
          controller: refreshController,
          enablePullUp: noMoreLoad,
          enablePullDown: false,
          onLoading: () async {
            await _secondGetMyItems();

            if (companies.requestStatus) {
              refreshController.loadFailed();
            } else {
              refreshController.loadComplete();
            }
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 230),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding:
                  const EdgeInsetsDirectional.only(top: 8, start: 8, end: 8),
              child: CompanyItem(
                data: data[index],
              ),
            ),
            itemCount: data.length,
          ),
        );
      }),
    );
  }
}
