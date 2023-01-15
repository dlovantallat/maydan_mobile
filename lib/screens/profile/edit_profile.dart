import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/app_utilities.dart';
import 'profile.dart';

class EditProfile extends StatefulWidget {
  final ProfileData profile;

  const EditProfile({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  File? image;
  String path = "";

  @override
  void initState() {
    nameController.text = widget.profile.name;
    emailController.text = widget.profile.email;
    phoneNumberController.text = widget.profile.msisdn;
    super.initState();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
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
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 16),
                        child: Icon(
                          Icons.account_circle,
                          color: appColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 8),
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
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
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 16),
                        child: Icon(
                          Icons.account_circle,
                          color: appColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 8),
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
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
              controller: phoneNumberController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 16),
                        child: Icon(
                          Icons.account_circle,
                          color: appColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 8),
                        child: Text(""),
                      ),
                    ],
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
              ),
            ),
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
              onPressed: () {},
              child: const Text("Save"),
            ),
          )
        ],
      ),
    );
  }
}
