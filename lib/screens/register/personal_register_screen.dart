import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import 'register.dart';

class PersonalRegisterScreen extends StatefulWidget {
  final String tempToken;

  const PersonalRegisterScreen({Key? key, required this.tempToken})
      : super(key: key);

  @override
  State<PersonalRegisterScreen> createState() => _PersonalRegisterScreenState();
}

class _PersonalRegisterScreenState extends State<PersonalRegisterScreen> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<RegisterModel> register;

  registerRequest() async {
    register = await service.register(
        "dlo", "d5@mail.com", "+96475042312205", "12345678");

    if (register.requestStatus) {
      print(register.errorMessage);
    } else {
      if (register.statusCode == 422) {
        print("object");
      } else {
        print(register.data!.user.name);
      }
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
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: SvgPicture.asset(
              homeLogoSvg,
              color: appColor,
              semanticsLabel: '',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "+964 750 XXX XXXX",
              style: TextStyle(
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
              padding: EdgeInsetsDirectional.only(bottom: 8, top: 16),
              child: Text(
                "Email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                  onPressed: () {
                    registerRequest();
                  },
                  child: const Text("Register")),
            )
          ],
        ),
      ),
    );
  }
}
