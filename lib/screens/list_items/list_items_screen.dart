import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import 'items_item.dart';

class ListItemsScreen extends StatefulWidget {
  final SubCategoryData subCategory;

  const ListItemsScreen({Key? key, required this.subCategory})
      : super(key: key);

  @override
  State<ListItemsScreen> createState() => _ListItemsScreenState();
}

class _ListItemsScreenState extends State<ListItemsScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemObj> items;
  bool isLoading = false;
  String token = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;
  String key = "";

  @override
  void initState() {
    getItems();
    super.initState();
  }

  void getItems() async {
    setState(() {
      isLoading = true;
    });

    token = await getToken();
    key = await getLanguageKeyForApi();
    items = await service.getItems(token, widget.subCategory.id, currentPage);

    if (!items.requestStatus) {
      if (items.statusCode == 200) {
        data.addAll(items.data!.list);
        currentPage++;
        totalPage = items.data!.lastPage;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetItems() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }

    items = await service.getItems(token, widget.subCategory.id, currentPage);
    data.addAll(items.data!.list);
    currentPage++;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.subCategory.title,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
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
          child: SmartRefresher(
            controller: refreshController,
            enablePullUp: noMoreLoad,
            enablePullDown: false,
            onLoading: () async {
              await _secondGetItems();

              if (items.requestStatus) {
                refreshController.loadFailed();
              } else {
                refreshController.loadComplete();
              }
            },
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 240),
              itemBuilder: (BuildContext context, int index) => ItemsItem(
                item: data[index],
                isFav: data[index].favorite,
                keyLang: key,
              ),
              itemCount: data.length,
            ),
          ),
        );
      }),
    );
  }
}
