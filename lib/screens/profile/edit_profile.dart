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
import '../../utilities/app_utilities.dart';
import '../post/post_obj.dart';
import '../register/register.dart';
import 'profile.dart';

class EditProfile extends StatefulWidget {
  final ProfileData profile;

  const EditProfile({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryObj> categories;
  late ApiResponse<UpdateUser> updateProfile;
  bool isLoading = false;

  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  late CategoryDrop _dropdownCategoryValue;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  File? image;
  String path = "";
  bool isPersonal = false;

  @override
  void initState() {
    nameController.text = widget.profile.name;
    emailController.text = widget.profile.email;
    phoneNumberController.text = widget.profile.msisdn;

    if (widget.profile.userType == "P") {
      setState(() {
        isLoading = false;
      });
      isPersonal = true;
    } else {
      isPersonal = false;
      getCategories();
    }

    super.initState();
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });

    categories = await service.getCategories();

    if (!categories.requestStatus) {
      if (categories.statusCode == 200) {
        _dropdownCategoriesDrop.clear();
        for (var i in categories.data!.data) {
          _dropdownCategoriesDrop.add(CategoryDrop(i.id, i.title));
        }
        _dropdownCategoryValue = _dropdownCategoriesDrop.first;

        for (var i in _dropdownCategoriesDrop) {
          if (i.id == widget.profile.categoryId) {
            _dropdownCategoryValue = i;
            break;
          }
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  editProfileFun() async {
    String name = nameController.text.trim().toString();
    String email = emailController.text.trim().toString();

    if (name.isEmpty) {
      setSnackBar(context, "You have to set name");
    }

    if (email.isEmpty) {
      setSnackBar(context, "Please enter a email");
      return;
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      setSnackBar(context, "Please enter a correct email");
      return;
    }

    String token = await getToken();

    updateProfile =
        await service.updateMe(name, "imagePath", token, isPersonal);

    if (!mounted) return;

    if (!updateProfile.requestStatus) {
      if (updateProfile.statusCode == 200) {
        setSnackBar(context, "yes profile has been updated");
      } else {
        print("eee ${updateProfile.errorMessage}");
        print("eee ${"updateProfile.data!.message"}");
      }
    } else {
      print("rrr ${updateProfile.errorMessage}");
    }
  }

  openGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      File tempCompressedImage = await customCompress(File(image.path));
      path = tempCompressedImage.path;
      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("an error occurred $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(builder: (context) {
        if (isPersonal) {
          return editProfile();
        }
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

        return editProfile();
      }),
    );
  }

  Widget editProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isPersonal
            ? Container()
            : Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: image == null
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  editProfileSvg,
                                  height: 50,
                                  width: 30,
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.only(top: 8),
                                  child: Text("Add new Photo"),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 100,
                          width: 112,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Image.file(
                                image!,
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    removeImageSvg,
                                    semanticsLabel: "",
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: nameController,
            decoration: const InputDecoration(
              fillColor: Color(0xFFF1F1F1),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: emailController,
            decoration: const InputDecoration(
              fillColor: Color(0xFFF1F1F1),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
          child: TextField(
            enabled: false,
            keyboardType: TextInputType.text,
            controller: phoneNumberController,
            decoration: const InputDecoration(
              fillColor: Color(0xFFF1F1F1),
              filled: true,
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F1F1), width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
        isPersonal
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 4, start: 16, end: 16, top: 16),
                    child: Text(AppLocalizations.of(context)!.post_category),
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, bottom: 32),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: Colors.black,
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
                          }),
                    ),
                  ),
                ],
              ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 32, end: 32),
          child: ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.resolveWith<Size>(
                (Set<MaterialState> states) {
                  return const Size(double.infinity, 40);
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            onPressed: editProfileFun,
            child: const Text("Save"),
          ),
        )
      ],
    );
  }
}
