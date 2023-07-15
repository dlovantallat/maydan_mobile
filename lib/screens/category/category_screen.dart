import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/category.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import 'category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ApiResponse<CategoryObj> categories;
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

    String localLang = await getLanguageKeyForApi();
    categories = await service.getCategories(localLang);

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
          AppLocalizations.of(context)!.category_title,
          style: const TextStyle(color: Colors.black),
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

        if (categories.data!.data.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        }

        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 40, end: 40),
          child: StaggeredGridView.countBuilder(
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 40.0,
            crossAxisCount: 2,
            itemBuilder: (BuildContext context, int index) => CategoryItem(
              context: context,
              category: categories.data!.data[index],
            ),
            itemCount: categories.data!.data.length,
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          ),
        );
      }),
    );
  }
}
