import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import 'category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryList> categories;
  bool isLoading = false;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });

    categories = await service.getCategories();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Category",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (categories.requestStatus) {
          return Center(
            child: Text(categories.errorMessage),
          );
        }

        if (categories.data!.list.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisExtent: 104),
          itemBuilder: (BuildContext context, int index) => CategoryItem(
            context: context,
            category: categories.data!.list[index],
          ),
          itemCount: categories.data!.list.length,
        );
      }),
    );
  }
}
