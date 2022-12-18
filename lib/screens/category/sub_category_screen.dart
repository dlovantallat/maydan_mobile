import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import 'sub_category_item.dart';

class SubCategoryScreen extends StatefulWidget {
  final CategoryData category;

  const SubCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<SubCategoryObj> subCategories;
  bool isLoading = false;

  @override
  void initState() {
    getSubCategories();
    super.initState();
  }

  void getSubCategories() async {
    setState(() {
      isLoading = true;
    });

    subCategories = await service.getSubCategories(widget.category.id);

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
          widget.category.id,
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

        if (subCategories.requestStatus) {
          return const Center(
            child: Text("Failed"),
          );
        }

        if (subCategories.data!.data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) => SubCategoryItem(
            context: context,
            subCategory: subCategories.data!.data[index],
          ),
          itemCount: subCategories.data!.data.length,
        );
      }),
    );
  }
}
