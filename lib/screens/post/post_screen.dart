import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../profile/login_widget.dart';
import 'image_row_item.dart';
import 'post_obj.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with LoginCallBack, DeleteListener {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  /// Category DropDown
  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  CategoryDrop? _dropdownCategoryValue;

  /// SubCategory DropDown
  final List<SubCategoryDrop> _dropdownSubCategoriesDrop = [
    SubCategoryDrop("-1", "Select")
  ];
  SubCategoryDrop? _dropdownSubCategoryValue;

  /// City DropDown
  final List<CityDrop> _dropdownCitiesDrop = [];
  CityDrop? _dropdownCityValue;

  /// District DropDown
  final List<DistrictDrop> _dropdownDistrictsDrop = [];
  DistrictDrop? _dropdownDistrictValue;

  /// Duration DropDown
  final List<String> _dropdownDurationDrop = ["7", "15", "30"];
  String _dropdownDurationValue = "7";

  /// City DropDown
  final List<String> _dropdownPriceDrop = ["IQ", "USD"];
  String _dropdownPriceValue = "IQ";

  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryObj> categories;
  late ApiResponse<SubCategoryObj> subCategories;
  late ApiResponse<CityObj> cities;
  late ApiResponse<DistrictObj> districts;
  late ApiResponse<ItemRespond> postItem;
  bool isLoading = false;
  bool isSubLoading = false;
  bool isSubLoaded = false;
  bool isTokenLoading = false;
  bool isLogin = false;
  bool isCityLoading = false;
  bool isCityLoaded = false;
  bool isDistrictLoading = false;
  bool isDistrictLoaded = false;
  String token = "";

  File? image;

  String path = "";

  List<UploadImage> uploadedPhotos = [];

  @override
  void initState() {
    tokenCheck();
    super.initState();
  }

  tokenCheck() async {
    setState(() {
      isTokenLoading = true;
    });

    token = await getToken();
    if (token == "") {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
      getCategories();
      getCity();
    }
    setState(() {
      isTokenLoading = false;
    });
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });

    categories = await service.getCategories();

    _dropdownCategoriesDrop.clear();
    _dropdownCategoryValue = null;
    if (!categories.requestStatus) {
      if (categories.statusCode == 200) {
        _dropdownCategoriesDrop.add(CategoryDrop("-1", "Select"));
        for (var i in categories.data!.data) {
          _dropdownCategoriesDrop.add(CategoryDrop(i.id, i.title));
        }
        _dropdownCategoryValue = _dropdownCategoriesDrop.first;
        // getSub(_dropdownCategoryValue!.id);
      }
    }

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
    _dropdownSubCategoryValue = null;
    if (!subCategories.requestStatus) {
      if (subCategories.statusCode == 200) {
        _dropdownSubCategoriesDrop.clear();
        _dropdownSubCategoriesDrop.add(SubCategoryDrop("-1", "Select"));
        for (var i in subCategories.data!.data) {
          _dropdownSubCategoriesDrop.add(SubCategoryDrop(i.id, i.title));
        }
        _dropdownSubCategoryValue = _dropdownSubCategoriesDrop.first;
      }
    }

    setState(() {
      isSubLoading = false;
      isSubLoaded = true;
    });
  }

  getCity() async {
    setState(() {
      isCityLoading = true;
      isCityLoaded = false;
    });

    cities = await service.getCities();

    _dropdownCitiesDrop.clear();
    _dropdownCityValue = null;

    if (!cities.requestStatus) {
      if (cities.statusCode == 200) {
        _dropdownCitiesDrop.add(CityDrop("-1", "Select"));
        for (var i in cities.data!.data) {
          _dropdownCitiesDrop.add(CityDrop(i.id, i.name));
        }
        _dropdownCityValue = _dropdownCitiesDrop.first;
        // getDistrict(_dropdownCityValue!.id);
      }
    }

    setState(() {
      isCityLoading = false;
      isCityLoaded = true;
    });
  }

  void getDistrict(String cityId) async {
    setState(() {
      isDistrictLoading = true;
      isDistrictLoaded = false;
    });

    districts = await service.getDistricts(cityId);
    setState(() {
      isDistrictLoading = false;
    });
    _dropdownDistrictsDrop.clear();
    _dropdownDistrictValue = null;

    if (!districts.requestStatus) {
      if (districts.statusCode == 200) {
        _dropdownDistrictsDrop.add(DistrictDrop("-1", "Select"));
        for (var i in districts.data!.data) {
          _dropdownDistrictsDrop.add(DistrictDrop(i.id, i.name));
        }
        _dropdownDistrictValue = _dropdownDistrictsDrop.first;
      }
    }

    setState(() {
      isDistrictLoading = false;
      isDistrictLoaded = true;
    });
  }

  void openGallery() async {
    if (uploadedPhotos.length < 5) {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) {
          return;
        }

        File tempCompressedImage = await customCompress(File(image.path));
        path = tempCompressedImage.path;
        final imageTemp = File(image.path);

        this.image = imageTemp;
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print("an error occurred $e");
        }
      }

      setState(() {
        uploadedPhotos.addAll([UploadImage(path, image!)]);
      });
    } else {
      setSnackBar(
          context, "you have reached the limit: ${uploadedPhotos.length}");
    }
  }

  void save() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    String price = priceController.text.trim();

    if (_dropdownSubCategoryValue == null ||
        _dropdownSubCategoryValue == _dropdownSubCategoriesDrop.first) {
      setSnackBar(context,
          "Please choose a subCategory or choose another category which has subCategory");
      return;
    }

    if (uploadedPhotos.isEmpty) {
      setSnackBar(context, "Please upload at least one image");
      return;
    }

    if (title.isEmpty) {
      setSnackBar(context, "title can't be empty");
      return;
    }

    if (description.isEmpty) {
      setSnackBar(context, "description can't be empty");
      return;
    }

    if (price.isEmpty) {
      setSnackBar(context, "price can't be empty");
      return;
    }

    if (_dropdownCityValue == null) {
      setSnackBar(context, "Please choose at least one city");
      return;
    }

    if (_dropdownDistrictValue == null ||
        _dropdownDistrictValue == _dropdownDistrictsDrop.first) {
      setSnackBar(context,
          "Please choose a District or choose another City which has District");
      return;
    }

    String token = await getToken();

    loading(context);
    postItem = await service.postItem(
      token: token,
      title: title,
      price: price,
      description: description,
      subCategory: _dropdownSubCategoryValue!.id,
      duration: _dropdownDurationValue,
      districtId: _dropdownDistrictValue!.id,
      uploadedPhotos: uploadedPhotos,
    );
    if (!mounted) return;

    if (!postItem.requestStatus) {
      if (postItem.statusCode == 201) {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 0,
          );
        }), (route) => false);

        setSnackBar(context, "post added: ${postItem.data!.id}");
      } else {
        Navigator.pop(context);
        if (kDebugMode) {
          print("code ${postItem.statusCode} d");
          print("code ${postItem.errorMessage} e");
        }

        setSnackBar(context, "post added: error ${postItem.errorMessage}");
      }
    } else {
      Navigator.pop(context);
      if (kDebugMode) {
        print("code ${postItem.errorMessage} e");
      }
    }
  }

  resetScreen() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();

    setState(() {
      uploadedPhotos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.post_title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        if (isTokenLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (isLogin) {
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
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 4),
                  child: Text(AppLocalizations.of(context)!.post_category),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
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
                              style: TextStyle(
                                  color: user == _dropdownCategoryValue
                                      ? appColor
                                      : Colors.black),
                            ),
                          );
                        }).toList(),
                        value: _dropdownCategoryValue,
                        onChanged: (i) {
                          setState(() {
                            _dropdownCategoryValue = i!;
                          });

                          if (i != _dropdownCategoriesDrop.first) {
                            getSub(_dropdownCategoryValue!.id);
                          } else {
                            isSubLoaded = false;
                          }
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                  child: Text(AppLocalizations.of(context)!.post_sub_category),
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
                                        style: TextStyle(
                                            color: user ==
                                                    _dropdownSubCategoryValue
                                                ? appColor
                                                : Colors.black),
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
                                        }),
                            ),
                          )
                        : const Text("Please Select another category"),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                  child: Text(AppLocalizations.of(context)!.post_add_images),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: uploadedPhotos.length + 1,
                        itemBuilder: (context, index) => index == 0
                            ? InkWell(
                                onTap: openGallery,
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: 112,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          editProfileSvg,
                                          height: 50,
                                          width: 30,
                                        ),
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              top: 8),
                                          child: Text("Add new Photo"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : PostImageItem(
                                index: index - 1,
                                image: uploadedPhotos[index - 1].image,
                                listener: this,
                              ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                  child: Text(AppLocalizations.of(context)!.post_title_caption),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
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
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                  child: Text(
                      AppLocalizations.of(context)!.post_description_caption),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: null,
                  minLines: 3,
                  decoration: const InputDecoration(
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
                      hintText: "Please write your description"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              top: 12, bottom: 4),
                          child: Text(
                              AppLocalizations.of(context)!.post_price_caption),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8, end: 8),
                                child: DropdownButton(
                                    underline: const SizedBox(),
                                    items: _dropdownPriceDrop
                                        .map((value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: value ==
                                                            _dropdownPriceValue
                                                        ? appColor
                                                        : Colors.black),
                                              ),
                                            ))
                                        .toList(),
                                    value: _dropdownPriceValue,
                                    onChanged: (i) {
                                      setState(() {
                                        _dropdownPriceValue = i!;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              top: 12, bottom: 4),
                          child: Text(AppLocalizations.of(context)!
                              .post_duration_caption),
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
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: value ==
                                                        _dropdownDurationValue
                                                    ? appColor
                                                    : Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                value: _dropdownDurationValue,
                                onChanged: (i) {
                                  setState(() {
                                    _dropdownDurationValue = i!;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                top: 12, bottom: 4),
                            child: Text(AppLocalizations.of(context)!
                                .post_city_caption),
                          ),
                          isCityLoading
                              ? const Center(child: CircularProgressIndicator())
                              : isCityLoaded
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        border: Border.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 8, end: 8),
                                        child: DropdownButton(
                                            underline: const SizedBox(),
                                            items: _dropdownCitiesDrop
                                                .map((CityDrop user) {
                                              return DropdownMenuItem<CityDrop>(
                                                value: user,
                                                child: Text(
                                                  user.title,
                                                  style: TextStyle(
                                                      color: user ==
                                                              _dropdownCityValue
                                                          ? appColor
                                                          : Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                            value: _dropdownCityValue,
                                            onChanged: (i) {
                                              setState(() {
                                                _dropdownCityValue = i!;
                                              });

                                              if (i !=
                                                  _dropdownCitiesDrop.first) {
                                                getDistrict(
                                                    _dropdownCityValue!.id);
                                              } else {
                                                isDistrictLoaded = false;
                                              }
                                            }),
                                      ),
                                    )
                                  : const Text(
                                      "Please Select another category"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 12, bottom: 4),
                              child: Text(AppLocalizations.of(context)!
                                  .post_district_caption),
                            ),
                            isDistrictLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : isDistrictLoaded
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8, end: 8),
                                          child: DropdownButton(
                                              underline: const SizedBox(),
                                              items: _dropdownDistrictsDrop
                                                  .map((DistrictDrop user) {
                                                return DropdownMenuItem<
                                                    DistrictDrop>(
                                                  value: user,
                                                  child: Text(
                                                    user.title,
                                                    style: TextStyle(
                                                        color: user ==
                                                                _dropdownDistrictValue
                                                            ? appColor
                                                            : Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                              value: _dropdownDistrictValue,
                                              onChanged: (i) {
                                                setState(() {
                                                  _dropdownDistrictValue = i!;
                                                });
                                              }),
                                        ),
                                      )
                                    : const Text(
                                        "Please Select another City",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                          onPressed: resetScreen,
                          child: Text(
                              AppLocalizations.of(context)!.post_clear_button)),
                      ElevatedButton(
                          onPressed: save,
                          child: Text(
                              AppLocalizations.of(context)!.post_save_button)),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return LoginWidget(
            callBack: this,
          );
        }
      }),
    );
  }

  @override
  void onLogin() {
    tokenCheck();
  }

  @override
  void onDelete(int index) {
    setState(() {
      uploadedPhotos.removeAt(index);
    });
  }
}
