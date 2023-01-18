import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/meta_data_widget.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../list_items/items_item.dart';
import '../profile/profile.dart';

class CompanyWidget extends StatefulWidget {
  final ProfileData data;

  const CompanyWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemObj> items;
  bool isLoading = false;

  @override
  void initState() {
    getRelatedItem();
    super.initState();
  }

  getRelatedItem() async {
    setState(() {
      isLoading = true;
    });

    String token = await getToken();

    items = await service.getRelatedCompanyItems(token, widget.data.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsetsDirectional.only(start: 8, end: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              width: double.infinity,
              'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Image(
                image: AssetImage(mainProfileBottomNavigationSvg),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(10),
                      topEnd: Radius.circular(10)),
                  color: appColor,
                ),
                child: const Center(
                  child: Text("Cow"),
                ),
              ),
              meteData(AppLocalizations.of(context)!.company_phone_number,
                  "widget.data.duration widget"),
              meteData(AppLocalizations.of(context)!.company_email,
                  "widget.data.duration widget"),
              meteData(AppLocalizations.of(context)!.company_location,
                  "widget.data.duration widget"),
              meteData(AppLocalizations.of(context)!.company_service_type,
                  "widget.data.duration widget"),
              meteData(AppLocalizations.of(context)!.company_code,
                  "widget.data.duration widget"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              AppLocalizations.of(context)!.company_related(widget.data.name)),
        ),
        Builder(builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (items.requestStatus) {
            return Center(
              child: Text(items.errorMessage),
            );
          }

          if (items.data!.list.isEmpty) {
            return const Center(
              child: Text("Empty"),
            );
          }

          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 220),
              itemBuilder: (BuildContext context, int index) => ItemsItem(
                item: items.data!.list[index],
                isFav: items.data!.list[index].favorite,
              ),
              itemCount: items.data!.list.length,
            ),
          );
        }),
      ],
    );
  }
}
