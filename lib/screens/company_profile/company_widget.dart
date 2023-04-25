import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/meta_data_widget.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../list_items/items_item.dart';
import '../profile/profile.dart';

class CompanyWidget extends StatefulWidget {
  final ProfileData data;
  final String langKey;

  const CompanyWidget({Key? key, required this.data, required this.langKey})
      : super(key: key);

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemObj> items;
  bool isLoading = false;
  bool isLoading2 = false;

  String token = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;

  @override
  void initState() {
    getRelatedItem();
    super.initState();
  }

  getRelatedItem() async {
    setState(() {
      isLoading = true;
    });

    token = await getToken();

    items = await service.getItemsByUser(widget.data.id, token, currentPage);

    if (!items.requestStatus) {
      if (items.statusCode == 200) {
        data.addAll(items.data!.list);
        currentPage++;
        totalPage = items.data!.lastPage;

        if (currentPage > totalPage) {
          setState(() {
            noMoreLoad = false;
          });
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetMyItems() async {
    setState(() {
      isLoading2 = true;
    });
    items = await service.getItemsByUser(widget.data.id, token, currentPage);
    data.addAll(items.data!.list);
    currentPage++;

    if (currentPage > totalPage) {
      setState(() {
        noMoreLoad = false;
        isLoading2 = false;
      });
    } else {
      setState(() {
        isLoading2 = false;
      });
    }
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
              imageLoader(widget.data.urlBanner),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Image(
                image: AssetImage(imageHolder),
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
                child: Center(
                  child: Text(widget.data.name),
                ),
              ),
              meteData(AppLocalizations.of(context)!.company_phone_number,
                  widget.data.msisdn),
              meteData(AppLocalizations.of(context)!.company_email,
                  widget.data.email),
              meteData(
                  AppLocalizations.of(context)!.company_service_type,
                  widget.langKey == "en"
                      ? widget.data.cat!.title.en
                      : widget.langKey == "ar"
                          ? widget.data.cat!.title.ar
                          : widget.data.cat!.title.ckb),
              meteData(AppLocalizations.of(context)!.company_location,
                  widget.data.address),
              meteData(
                  AppLocalizations.of(context)!.company_code, widget.data.id),
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

          if (data.isEmpty) {
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
                  crossAxisCount: 2, mainAxisExtent: 240),
              itemBuilder: (BuildContext context, int index) => ItemsItem(
                item: data[index],
                isFav: data[index].favorite,
                keyLang: widget.langKey,
              ),
              itemCount: data.length,
            ),
          );
        }),
        noMoreLoad
            ? isLoading2
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 60, end: 60),
                    child: ElevatedButton(
                      onPressed: () {
                        _secondGetMyItems();
                      },
                      child: Text(AppLocalizations.of(context)!.load_more),
                    ),
                  )
            : Container(),
      ],
    );
  }
}
