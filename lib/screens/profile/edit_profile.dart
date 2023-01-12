import 'package:flutter/material.dart';

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

  @override
  void initState() {
    nameController.text = widget.profile.name;
    emailController.text = widget.profile.email;
    phoneNumberController.text = widget.profile.msisdn;
    super.initState();
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
        children: [
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
