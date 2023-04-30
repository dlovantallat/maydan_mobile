import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../utilities/app_utilities.dart';
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

    String localLang = await getLanguageKeyForApi();
    subCategories =
        await service.getSubCategories(widget.category.id, localLang);

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
          widget.category.title,
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
          return Center(
            child: Text(subCategories.errorMessage),
          );
        }

        if (subCategories.data!.data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 24, end: 24, top: 16),
          child: StaggeredGridView.countBuilder(
            itemBuilder: (BuildContext context, int index) => SubCategoryItem(
              context: context,
              subCategory: subCategories.data!.data[index],
            ),
            itemCount: subCategories.data!.data.length,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            crossAxisCount: 3,
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          ),
        );
      }),
    );
  }
}
