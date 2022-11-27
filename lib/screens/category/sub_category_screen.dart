import 'package:flutter/material.dart';

import '../../common/model/category.dart';
import 'sub_category_item.dart';

class SubCategoryScreen extends StatefulWidget {
  final CategoryData category;

  const SubCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.category.id,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => SubCategoryItem(
          context: context,
        ),
        itemCount: 5,
      ),
    );
  }
}
