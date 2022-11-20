import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/app_utilities.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<String> _dropdownCategories = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five"
  ];

  final List<String> _dropdownSub = ["One", "Two", "Three", "Four", "Five"];

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
      body: Container(
        margin: EdgeInsetsDirectional.only(start: 16, end: 16),
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
                child: DropdownButton(
                    isExpanded: true,
                    items: _dropdownCategories
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    value: _dropdownCategories.first,
                    onChanged: (i) {}),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
              child: Text("Sub Category"),
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
                child: DropdownButton(
                    isExpanded: true,
                    items: _dropdownSub
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    value: _dropdownCategories.first,
                    onChanged: (i) {}),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.only(top: 12, bottom: 4),
              child: Text("Ad photos"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: DropdownButton(
                            items: _dropdownSub
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            value: _dropdownCategories.first,
                            onChanged: (i) {}),
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
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: DropdownButton(
                            items: _dropdownSub
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            value: _dropdownCategories.first,
                            onChanged: (i) {}),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: DropdownButton(
                            items: _dropdownSub
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            value: _dropdownCategories.first,
                            onChanged: (i) {}),
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
                        padding:
                            const EdgeInsetsDirectional.only(start: 8, end: 8),
                        child: DropdownButton(
                            items: _dropdownSub
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            value: _dropdownCategories.first,
                            onChanged: (i) {}),
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
                  OutlinedButton(onPressed: () {}, child: const Text("clear")),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Confirm")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
