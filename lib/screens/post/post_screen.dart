import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  late CategoryDrop _dropdownCategoryValue;

  final List<String> _dropdownDurationDrop = ["7", "15", "30"];
  String _dropdownDurationValue = "7";

  final List<String> _dropdownPriceDrop = ["IQ", "USD"];
  String _dropdownPriceValue = "IQ";

  final List<String> _dropdownCityDrop = ["Erbil", "Sulaymany", "Duhok"];
  String _dropdownCityValue = "Erbil";

  final List<String> _dropdownDistrictDrop = ["Nawand", "Golden"];
  String _dropdownDistrictValue = "Nawand";

  final List<SubCategoryDrop> _dropdownSubCategoriesDrop = [
    SubCategoryDrop("-1", "Select")
  ];
  SubCategoryDrop _dropdownSubCategoryValue = SubCategoryDrop("-1", "Select");

  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryObj> categories;
  late ApiResponse<SubCategoryObj> subCategories;
  late ApiResponse<ItemRespond> postItem;
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
    for (var i in categories.data!.data) {
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

  void openGallery() {
    print("hello from gallery");
  }

  void save() async {
    String token = await getToken();

    postItem = await service.postItem(token);

    if (postItem.requestStatus) {
      print("code ${postItem.errorMessage} t");
    } else {
      if (postItem.statusCode == 201) {
        print(postItem.data!.id);
      } else {
        print("code ${postItem.statusCode} d");
        print("code ${postItem.errorMessage} e");
      }
    }
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

        if (categories.data!.data.isEmpty) {
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
              const Padding(
                padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                child: Text("Ad photos"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: openGallery,
                    child: Card(
                      elevation: 8,
                      child: Container(
                          margin: const EdgeInsetsDirectional.only(
                              start: 40, end: 40, top: 30, bottom: 30),
                          child: SvgPicture.asset(
                            editProfileSvg,
                            height: 50,
                            width: 30,
                          )),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(
                  top: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 70,
                child: const Padding(
                  padding: EdgeInsetsDirectional.all(8),
                  child: Text("Description"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                        child: Text("Price"),
                      ),
                      Container(
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
                          child: DropdownButton(
                              underline: const SizedBox(),
                              items: _dropdownPriceDrop
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              value: _dropdownPriceValue,
                              onChanged: (i) {
                                setState(() {
                                  _dropdownPriceValue = i!;
                                });

                                print(_dropdownPriceValue);
                              }),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                        child: Text("Duration"),
                      ),
                      Container(
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
                          child: DropdownButton(
                              underline: const SizedBox(),
                              items: _dropdownDurationDrop
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              value: _dropdownDurationValue,
                              onChanged: (i) {
                                setState(() {
                                  _dropdownDurationValue = i!;
                                });

                                print(_dropdownDurationValue);
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 8, top: 20),
                child: Text("Seller name"),
              ),
              const TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(bottom: 8, top: 20),
                child: Text("Phone number"),
              ),
              const TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                        child: Text("City"),
                      ),
                      Container(
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
                          child: DropdownButton(
                              underline: const SizedBox(),
                              items: _dropdownCityDrop
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              value: _dropdownCityValue,
                              onChanged: (i) {
                                setState(() {
                                  _dropdownCityValue = i!;
                                });

                                print(_dropdownCityValue);
                              }),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
                        child: Text("District"),
                      ),
                      Container(
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
                          child: DropdownButton(
                              underline: const SizedBox(),
                              items: _dropdownDistrictDrop
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              value: _dropdownDistrictValue,
                              onChanged: (i) {
                                setState(() {
                                  _dropdownDistrictValue = i!;
                                });

                                print(_dropdownDistrictValue);
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () {}, child: const Text("clear")),
                    ElevatedButton(
                        onPressed: save, child: const Text("Confirm")),
                  ],
                ),
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
