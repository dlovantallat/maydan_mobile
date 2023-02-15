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
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../post/post_obj.dart';
import '../register/register.dart';
import '../../widgets/dots_indicator/src/dots_indicator.dart';
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

  late ApiResponse<UpdateUser> updateProfile2;

  final fbController = TextEditingController();
  final iController = TextEditingController();
  final ytController = TextEditingController();
  final waController = TextEditingController();
  final vController = TextEditingController();

  File? image;
  String path = "";
  File? imageBanner;
  String pathBanner = "";
  bool isPersonal = false;
  double pos = 0;

  @override
  void initState() {
    nameController.text = widget.profile.name;
    emailController.text = widget.profile.email;
    phoneNumberController.text = widget.profile.msisdn;

    fbController.text = widget.profile.facebook ?? "";
    iController.text = widget.profile.instagram ?? "";
    ytController.text = widget.profile.youtube ?? "";
    waController.text = widget.profile.whatsapp ?? "";
    vController.text = widget.profile.viber ?? "";

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

    String localLang = await getLanguageKeyForApi();
    categories = await service.getCategories(localLang);

    if (!categories.requestStatus) {
      if (categories.statusCode == 200) {
        _dropdownCategoriesDrop.clear();
        _dropdownCategoriesDrop.add(CategoryDrop("-1", "Select"));
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

    if (email == widget.profile.email) {
      email = "";
    }

    if (name.isEmpty) {
      setSnackBar(context, "You have to set name");
    }

    if (email.isNotEmpty) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        setSnackBar(context, "Please enter a correct email");
        return;
      }
    }

    if (widget.profile.userType != "P") {
      if (_dropdownCategoryValue == _dropdownCategoriesDrop.first) {
        setSnackBar(context, "Please select a category");
        return;
      }
    }

    print("image path:$path");
    String token = await getToken();
    loading(context);
    updateProfile = await service.updateMe(
        name,
        email,
        path == "" ? null : path,
        pathBanner == "" ? null : pathBanner,
        token,
        widget.profile.userType != "P" ? _dropdownCategoryValue.id : "",
        isPersonal);

    if (!mounted) return;

    if (!updateProfile.requestStatus) {
      if (updateProfile.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 4,
          );
        }), (route) => false);
        setSnackBar(context, "yes profile has been updated");
      } else {
        Navigator.pop(context);
        setSnackBar(context, updateProfile.errorMessage);
      }
    } else {
      Navigator.pop(context);
      setSnackBar(context, updateProfile.errorMessage);
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
      setSnackBar(context, "an error occurred $e");
    }
  }

  openGalleryBanner() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      File tempCompressedImage = await customCompress(File(image.path));
      pathBanner = tempCompressedImage.path;
      final imageTemp = File(image.path);

      setState(() {
        imageBanner = imageTemp;
      });
    } on PlatformException catch (e) {
      setSnackBar(context, "an error occurred $e");
    }
  }

  editProfileFun2() async {
    String fb = fbController.text.trim().toString();
    String instagram = iController.text.trim().toString();
    String youtube = ytController.text.trim().toString();
    String whatsapp = waController.text.trim().toString();
    String viber = vController.text.trim().toString();

    if (fb.isNotEmpty) {
      if (!Uri.parse(fb).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    if (instagram.isNotEmpty) {
      if (!Uri.parse(instagram).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    if (youtube.isNotEmpty) {
      if (!Uri.parse(youtube).isAbsolute) {
        setSnackBar(context, "url is not right");
        return;
      }
    }

    if (whatsapp.isNotEmpty) {
      if (whatsapp.length < 13) {
        setSnackBar(
            context, "please write down correct number ${whatsapp.length}");
        return;
      }
    }

    if (viber.isNotEmpty) {
      if (viber.length < 13) {
        setSnackBar(context, "please write down correct number of viber");
        return;
      }
    }

    String token = await getToken();
    loading(context);
    updateProfile2 = await service.updateSocialMedia(
        fb, instagram, youtube, whatsapp, viber, token);

    if (!mounted) return;

    if (!updateProfile2.requestStatus) {
      if (updateProfile2.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 4,
          );
        }), (route) => false);
        setSnackBar(context, "yes profile has been updated");
      } else {
        Navigator.pop(context);
        setSnackBar(context, updateProfile2.errorMessage);
      }
    } else {
      Navigator.pop(context);
      setSnackBar(context, updateProfile2.errorMessage);
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
    return ListView(
      children: [
        isPersonal
            ? Container()
            : DotsIndicator(
                dotsCount: 2,
                position: pos,
              ),
        pos == 0
            ? ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 16),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFF1F1F1),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF1F1F1), width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF1F1F1), width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 16),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: emailController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFF1F1F1),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF1F1F1), width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF1F1F1), width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 16),
                    child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFF1F1F1),
                        filled: true,
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF1F1F1), width: 2),
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
                              child: Text(
                                AppLocalizations.of(context)!.post_category,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
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
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8, end: 8),
                                child: DropdownButton<CategoryDrop>(
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: _dropdownCategoriesDrop
                                        .map((CategoryDrop user) {
                                      return DropdownMenuItem<CategoryDrop>(
                                        value: user,
                                        child: Text(
                                          user.title,
                                          style: TextStyle(
                                              color:
                                                  user == _dropdownCategoryValue
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
                            imageBanner == null
                                ? InkWell(
                                    onTap: openGalleryBanner,
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 16, end: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
                                  )
                                : Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 16, end: 16),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.file(
                                          imageBanner!,
                                          fit: BoxFit.cover,
                                          height: 100,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            imageBanner = null;
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  end: 16),
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
                                      ),
                                    ],
                                  )
                          ],
                        ),
                  Row(
                    mainAxisAlignment: isPersonal
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 32, end: 32),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: editProfileFun,
                          child: const Text("Save"),
                        ),
                      ),
                      isPersonal
                          ? Container()
                          : Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 32, end: 32),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    pos = 1;
                                  });
                                },
                                child: const Text("Next"),
                              ),
                            ),
                    ],
                  )
                ],
              )
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                    child: Text(
                      "Facebook",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 8),
                    child: TextField(
                      controller: fbController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 16),
                                child: SvgPicture.asset(
                                  fbSvg,
                                  semanticsLabel: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                    child: Text(
                      "Instagram",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 8),
                    child: TextField(
                      controller: iController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 16),
                                child: SvgPicture.asset(
                                  instagramSvg,
                                  semanticsLabel: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                    child: Text(
                      "Youtube",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 8),
                    child: TextField(
                      controller: ytController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 16),
                                child: SvgPicture.asset(
                                  ytSvg,
                                  semanticsLabel: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                    child: Text(
                      "Whatsapp",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 8, bottom: 8),
                    child: TextField(
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      controller: waController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 16),
                                child: SvgPicture.asset(
                                  waSvg,
                                  semanticsLabel: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                    child: Text(
                      "Viber",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 16, top: 8, bottom: 8),
                    child: TextField(
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      controller: vController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 16),
                                child: SvgPicture.asset(
                                  vSvg,
                                  semanticsLabel: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 32, end: 32),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              pos = 0;
                            });
                          },
                          child: const Text("Back"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 32, end: 32),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: editProfileFun2,
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ],
    );
  }
}
