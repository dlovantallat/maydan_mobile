import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../utilities/app_utilities.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  late CategoryDrop _dropdownCategoryValue;

  final List<SubCategoryDrop> _dropdownSubCategoriesDrop = [
    SubCategoryDrop("-1", "Select")
  ];
  SubCategoryDrop _dropdownSubCategoryValue = SubCategoryDrop("-1", "Select");

  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryList> categories;
  late ApiResponse<SubCategoryObj> subCategories;
  bool isLoading = false;
  bool isSubLoading = false;
  bool isSubLoaded = false;

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

    _dropdownCategoriesDrop.clear();
    for (var i in categories.data!.list) {
      _dropdownCategoriesDrop.add(CategoryDrop(i.id, i.title));
    }
    _dropdownCategoryValue = _dropdownCategoriesDrop.first;
    getSub(_dropdownCategoryValue.id);

    setState(() {
      isLoading = false;
    });
  }

  void getSub(String categoryId) async {
    setState(() {
      isSubLoading = true;
      isSubLoaded = false;
    });

    subCategories = await service.getSubCategories(categoryId);
    setState(() {
      isSubLoading = false;
    });
    _dropdownSubCategoriesDrop.clear();
    for (var i in subCategories.data!.data) {
      _dropdownSubCategoriesDrop.add(SubCategoryDrop(i.id, i.title));
    }
    _dropdownSubCategoryValue = _dropdownSubCategoriesDrop.first;

    setState(() {
      isSubLoading = false;
      isSubLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Post",
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

        return Container(
          margin: const EdgeInsetsDirectional.only(start: 16, end: 16),
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 4),
                child: Text("Category"),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: Colors.black, style: BorderStyle.solid, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  child: DropdownButton<CategoryDrop>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _dropdownCategoriesDrop.map((CategoryDrop user) {
                        return DropdownMenuItem<CategoryDrop>(
                          value: user,
                          child: Text(
                            user.title,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      value: _dropdownCategoryValue,
                      onChanged: (i) {
                        setState(() {
                          _dropdownCategoryValue = i!;
                        });
                        getSub(_dropdownCategoryValue.id);
                        print(_dropdownCategoryValue.title);
                      }),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                child: Text("Sub Category"),
              ),
              isSubLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isSubLoaded
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, end: 8),
                            child: DropdownButton<SubCategoryDrop>(
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: _dropdownSubCategoriesDrop
                                    .map((SubCategoryDrop user) {
                                  return DropdownMenuItem<SubCategoryDrop>(
                                    value: user,
                                    child: Text(
                                      user.title,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                value: _dropdownSubCategoryValue,
                                onChanged: !isSubLoaded
                                    ? null
                                    : (i) {
                                        setState(() {
                                          _dropdownSubCategoryValue = i!;
                                        });

                                        print(_dropdownCategoryValue.title);
                                      }),
                          ),
                        )
                      : Container(
                          child: const Text("Please Select another category"),
                        ),
            ],
          ),
        );
      }),
    );
  }
}

class CategoryDrop {
  String id;
  String title;

  CategoryDrop(this.id, this.title);
}

class SubCategoryDrop {
  String id;
  String title;

  SubCategoryDrop(this.id, this.title);
}
