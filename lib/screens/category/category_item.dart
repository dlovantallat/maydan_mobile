import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/common/model/category.dart';

import '../../utilities/app_utilities.dart';
import 'sub_category_screen.dart';

class CategoryItem extends StatelessWidget {
  final BuildContext context;
  final CategoryData category;

  const CategoryItem({Key? key, required this.context, required this.category})
      : super(key: key);

  void onItemClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen(
          category: CategoryData(id: 'Animal', image: '', description: ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 8, bottom: 8),
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(12, 12),
                  color: const Color(0x06b4b0b0).withOpacity(.8),
                  spreadRadius: -9)
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: Image.network(
                imageLoader(category.image),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Image(
                  image: AssetImage(noInternet),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 8,
                end: 8,
                bottom: 8,
              ),
              child: Text(
                category.id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
