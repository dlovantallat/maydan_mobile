import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maydan/main.dart';
import 'package:maydan/screens/register/register.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../utilities/app_utilities.dart';
import '../post/post_obj.dart';

class CompanyRegisterScreen extends StatefulWidget {
  final String phoneNumber;
  final String tempToken;
  final bool isPersonal;

  const CompanyRegisterScreen({
    Key? key,
    required this.phoneNumber,
    required this.tempToken,
    required this.isPersonal,
  }) : super(key: key);

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<CategoryObj> categories;
  late ApiResponse<RegisterModel> register;
  bool isLoading = false;

  /// Category DropDown
  final List<CategoryDrop> _dropdownCategoriesDrop = [];
  CategoryDrop? _dropdownCategoryValue;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  File? image;

  String path = "";

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
    _dropdownCategoryValue = null;
    if (!categories.requestStatus) {
      if (categories.statusCode == 200) {
        _dropdownCategoriesDrop.add(CategoryDrop("-1", "Select"));
        for (var i in categories.data!.data) {
          _dropdownCategoriesDrop.add(CategoryDrop(i.id, i.title));
        }
        _dropdownCategoryValue = _dropdownCategoriesDrop.first;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  registerRequest() async {
    String name = nameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();
    String passwordConfirmation =
        passwordConfirmationController.text.trim().toString();

    if (name.isEmpty) {
      setSnackBar(context, "Please enter a name");
      return;
    }

    if (email.isNotEmpty) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        setSnackBar(context, "Please enter a correct email");
        return;
      }
      return;
    }

    if (password.isEmpty) {
      setSnackBar(context, "Please enter a password");
      return;
    }

    if (password != passwordConfirmation) {
      setSnackBar(
          context, "Confirmed Password must be exactly the same as password");
      return;
    }

    if (_dropdownCategoryValue == _dropdownCategoriesDrop.first) {
      setSnackBar(context, "Select a category");
      return;
    }

    loading(context);

    register = await service.register(
        name,
        email,
        widget.tempToken,
        "964${widget.phoneNumber}",
        password,
        _dropdownCategoryValue!.id,
        path == "" ? null : path,
        widget.isPersonal);
    if (!mounted) return;

    Navigator.pop(context);
    if (register.requestStatus) {
      setSnackBar(context, register.errorMessage);
    } else {
      if (register.statusCode == 422) {
        setSnackBar(context, register.errorMessage);
      } else if (register.statusCode == 403) {
        setSnackBar(context, register.data!.message);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const MainPage(
            index: 4,
          );
        }), (route) => false);
      }
    }
  }

  void openImage() async {
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
      print("an error occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  image != null
                      ? Card(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              SizedBox(
                                height: 110,
                                width: 110,
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: openImage,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "+964 ${widget.phoneNumber}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 20),
                    child: Text(
                      "First and last name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextField(
                    controller: nameController,
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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
                    child: Text(
                      "Email (Optional)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextField(
                    controller: emailController,
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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
                    child: Text(
                      "Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextField(
                    controller: addressController,
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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
                    child: Text(
                      "Password Confirmed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordConfirmationController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
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
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
                    child: Text(
                      "Service type",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                              // getSub(_dropdownCategoryValue!.id);
                            } else {
                              // isSubLoaded = false;
                            }
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 32),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith<Size>(
                            (Set<MaterialState> states) {
                              return const Size(double.infinity, 40);
                            },
                          ),
                        ),
                        onPressed: registerRequest,
                        child: const Text("Register")),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
