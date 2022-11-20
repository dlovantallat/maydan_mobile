import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/app_utilities.dart';

class CompanyRegisterScreen extends StatefulWidget {
  const CompanyRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final List<String> _dropdownValues = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five"
  ]; //The list of values we want on the dropdown

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
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Card(
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
              ],
            ),
            Column(
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
                    padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                    child: DropdownButton(
                        isExpanded: true,
                        items: _dropdownValues
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        value: _dropdownValues.first,
                        onChanged: (i) {}),
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
                      onPressed: () {},
                      child: const Text("Register")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
