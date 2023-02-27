import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
  final sellerController = TextEditingController();
  final sellerPhoneController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  /// Category DropDown
  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  CategoryDrop? _dropdownCategoryValue;

  /// SubCategory DropDown
  final List<SubCategoryDrop> _dropdownSubCategoriesDrop = [];
  SubCategoryDrop? _dropdownSubCategoryValue;

  /// City DropDown
  final List<CityDrop> _dropdownCitiesDrop = [];
  CityDrop? _dropdownCityValue;

  /// District DropDown
  final List<DistrictDrop> _dropdownDistrictsDrop = [];
  DistrictDrop? _dropdownDistrictValue;

  /// Duration DropDown
  final List<String> _dropdownDurationDrop = ["1", "2", "3"];
  String _dropdownDurationValue = "1";

  /// City DropDown
  final List<String> _dropdownPriceDrop = ["IQD", "USD"];
  String _dropdownPriceValue = "IQD";

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
  final _formKey = GlobalKey<FormState>();

  File? image;

  String path = "";

  List<File> images = [];

  List<String> paths = [];

  List<UploadImage> uploadedPhotos = [];
  String localLang = "";
  bool isPrice = false;

  final oib = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
  );

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

    localLang = await getLanguageKeyForApi();
    sellerController.text = await getUserName();
    sellerPhoneController.text = await getUserPhone();
    categories = await service.getCategories(localLang);

    _dropdownCategoriesDrop.clear();
    _dropdownCategoryValue = null;
    if (!categories.requestStatus) {
      if (categories.statusCode == 200) {
        _dropdownCategoriesDrop.add(CategoryDrop(
            "-1", AppLocalizations.of(Get.context!)!.select_title));
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

    subCategories = await service.getSubCategories(categoryId, localLang);
    setState(() {
      isSubLoading = false;
    });
    _dropdownSubCategoriesDrop.clear();
    _dropdownSubCategoryValue = null;
    if (!subCategories.requestStatus) {
      if (subCategories.statusCode == 200) {
        _dropdownSubCategoriesDrop.clear();
        _dropdownSubCategoriesDrop.add(SubCategoryDrop(
            "-1", AppLocalizations.of(Get.context!)!.select_title));
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
        _dropdownCitiesDrop.add(
            CityDrop("-1", AppLocalizations.of(Get.context!)!.select_title));
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
        _dropdownDistrictsDrop.add(DistrictDrop(
            "-1", AppLocalizations.of(Get.context!)!.select_title));
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
        setSnackBar(context, "an error occurred $e");
      }

      setState(() {
        uploadedPhotos.addAll([UploadImage(path, image!)]);
      });
    } else {
      setSnackBar(
          context,
          AppLocalizations.of(context)!
              .post_limit_image("${uploadedPhotos.length}"));
    }
  }

  void multiImage() async {
    try {
      final image = await ImagePicker().pickMultiImage(
          maxHeight: 200000, maxWidth: 200000, imageQuality: 30);

      List<UploadImage> arr = [];
      for (var i in image) {
        File tempCompressedImage = await customCompress(File(i.path));
        paths.add(tempCompressedImage.path);
        final imageTemp = File(i.path);

        images.add(imageTemp);

        arr.add(UploadImage(tempCompressedImage.path, imageTemp));
      }

      setState(() {
        uploadedPhotos.addAll(arr);
      });
    } on PlatformException catch (e) {
      setSnackBar(context, "an error occurred $e");
    }
  }

  void save() async {
    if (priceController.text.trim().isEmpty) {
      setState(() {
        isPrice = true;
      });
    } else {
      setState(() {
        isPrice = false;
      });
    }

    if (_formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      String price = priceController.text.trim();
      String sellerName = sellerController.text.trim();
      String phoneNumber = sellerPhoneController.text.trim();

      if (_dropdownSubCategoryValue == null ||
          _dropdownSubCategoryValue == _dropdownSubCategoriesDrop.first) {
        setSnackBar(
            context, AppLocalizations.of(context)!.post_sub_category_val);
        return;
      }

      if (uploadedPhotos.length > 5) {
        setSnackBar(context, "Please upload no more than five image");
        return;
      }

      if (uploadedPhotos.isEmpty) {
        setSnackBar(context, AppLocalizations.of(context)!.post_no_image);
        return;
      }

      if (_dropdownCityValue == null) {
        setSnackBar(context, AppLocalizations.of(context)!.post_city_val);
        return;
      }

      if (_dropdownDistrictValue == null ||
          _dropdownDistrictValue == _dropdownDistrictsDrop.first) {
        setSnackBar(context, AppLocalizations.of(context)!.post_district_val);
        return;
      }

      String token = await getToken();
      String firebaseToken = await FirebaseMessaging.instance.getToken() ?? "";

      loading(context);
      postItem = await service.postItem(
        token: token,
        title: title,
        sellerName: sellerName,
        phoneNumber: phoneNumber,
        price: price,
        description: description,
        subCategory: _dropdownSubCategoryValue!.id,
        duration: _dropdownDurationValue,
        currencyType: _dropdownPriceValue,
        districtId: _dropdownDistrictValue!.id,
        firebaseToken: firebaseToken,
        uploadedPhotos: uploadedPhotos,
      );
      if (!mounted) return;

      if (!postItem.requestStatus) {
        if (postItem.statusCode == 201) {
          Navigator.pop(context);
          postSucceed();
        } else {
          Navigator.pop(context);
          setSnackBar(context, "post added: error ${postItem.errorMessage}");
        }
      } else {
        Navigator.pop(context);
        setSnackBar(context, "post added: error ${postItem.errorMessage}");
      }
    }
  }

  String? validateTitle(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_title_val;
    } else {
      return null;
    }
  }

  String? validateSellerName(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_seller_error;
    } else {
      return null;
    }
  }

  String? validateSellerPhone(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_seller_phone_error;
    } else {
      return null;
    }
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.post_description_val;
    } else {
      return null;
    }
  }

  String? validatePrice(String? value) {
    if (value!.isEmpty) {
      return null;
    } else {
      return null;
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

  postSucceed() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.post_success_title),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 8, bottom: 16),
                      child:
                          Text(AppLocalizations.of(context)!.post_success_body),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) {
                                return const MainPage(
                                  index: 0,
                                );
                              }), (route) => false);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                appColor,
                              ),
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(
                                    double.infinity,
                                    40,
                                  );
                                },
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!
                                .post_success_close
                                .toUpperCase()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: true);
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
            child: Form(
              key: _formKey,
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
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, end: 8),
                      child: DropdownButton<CategoryDrop>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          items:
                              _dropdownCategoriesDrop.map((CategoryDrop user) {
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
                    padding:
                        const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                    child:
                        Text(AppLocalizations.of(context)!.post_sub_category),
                  ),
                  isSubLoading
                      ? const Center(child: CircularProgressIndicator())
                      : isSubLoaded
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                    color: Colors.grey,
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
                          : Text(AppLocalizations.of(context)!
                              .post_select_another_cat),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 12, bottom: 4),
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
                                  onTap: multiImage,
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
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(top: 8),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .post_add_new_photo),
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
                    padding:
                        const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                    child:
                        Text(AppLocalizations.of(context)!.post_title_caption),
                  ),
                  TextFormField(
                    controller: titleController,
                    validator: validateTitle,
                    decoration: InputDecoration(
                      focusedBorder: oib,
                      enabledBorder: oib,
                      errorBorder: oib,
                      focusedErrorBorder: oib,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                    child: Text(
                        AppLocalizations.of(context)!.post_description_caption),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    validator: validateDescription,
                    maxLines: null,
                    minLines: 3,
                    decoration: InputDecoration(
                        focusedBorder: oib,
                        enabledBorder: oib,
                        errorBorder: oib,
                        focusedErrorBorder: oib,
                        hintText: AppLocalizations.of(context)!.post_write_des),
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
                            child: Text(AppLocalizations.of(context)!
                                .post_price_caption),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: priceController,
                                    validator: validatePrice,
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
                          isPrice
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 8, top: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .post_price_val,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox()
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
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 1),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 8, end: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.post_week,
                                    style: const TextStyle(color: appColor),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 8),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                    child: Text(AppLocalizations.of(context)!.seller_name),
                  ),
                  TextFormField(
                    controller: sellerController,
                    validator: validateSellerName,
                    decoration: InputDecoration(
                      focusedBorder: oib,
                      enabledBorder: oib,
                      errorBorder: oib,
                      focusedErrorBorder: oib,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(bottom: 8, top: 20),
                    child:
                        Text(AppLocalizations.of(context)!.seller_phone_number),
                  ),
                  TextFormField(
                    controller: sellerPhoneController,
                    validator: validateSellerPhone,
                    decoration: InputDecoration(
                      focusedBorder: oib,
                      enabledBorder: oib,
                      errorBorder: oib,
                      focusedErrorBorder: oib,
                    ),
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
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : isCityLoaded
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: Colors.grey,
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
                                                return DropdownMenuItem<
                                                    CityDrop>(
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
                                    : Text(AppLocalizations.of(context)!
                                        .post_select_another_city),
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
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 8, end: 8),
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
                                      : Text(
                                          AppLocalizations.of(context)!
                                              .post_select_another_district,
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
                            child: Text(AppLocalizations.of(context)!
                                .post_clear_button)),
                        ElevatedButton(
                            onPressed: save,
                            child: Text(AppLocalizations.of(context)!
                                .post_save_button)),
                      ],
                    ),
                  ),
                ],
              ),
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
