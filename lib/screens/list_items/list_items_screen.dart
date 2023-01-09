import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  @override
  void initState() {
    getItems();
    super.initState();
  }

  void getItems() async {
    setState(() {
      isLoading = true;
    });

    String token = await getToken();
    items = await service.getItems(token, widget.subCategory.id);

    setState(() {
      isLoading = false;
    });
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

        if (items.data!.list.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 4),
          child: GridView.builder(
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
    );
  }
}
