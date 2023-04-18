import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/model/category.dart';
import '../../utilities/app_utilities.dart';
import '../list_items/list_items_screen.dart';

class SubCategoryItem extends StatelessWidget {
  final BuildContext context;
  final SubCategoryData subCategory;

  const SubCategoryItem({
    Key? key,
    required this.context,
    required this.subCategory,
  }) : super(key: key);

  void onSubItemClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return ListItemsScreen(
          subCategory: subCategory,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubItemClick,
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
            Container(
              clipBehavior: Clip.hardEdge,
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xFFE5E5E5)),
              height: 80,
              width: 80,
              child: subCategory.urlImg
                          .substring(subCategory.urlImg.length - 3)
                          .toLowerCase() !=
                      "svg"
                  ? Image.network(
                      imageLoader(subCategory.urlImg),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Image(
                        image: AssetImage(imageHolder),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : SvgPicture.network(
                      imageLoader(subCategory.urlImg),
                      semanticsLabel: 'SVG From Network',
                      placeholderBuilder: (BuildContext context) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 8,
                end: 8,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                subCategory.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
