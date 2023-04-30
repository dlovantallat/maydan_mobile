import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/model/category.dart';
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
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Container(
                color: appColor,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(0.0),
                    child: category.urlImg
                                .substring(category.urlImg.length - 3)
                                .toLowerCase() !=
                            "svg"
                        ? Image.network(
                            imageLoader(category.urlImg),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Image(
                              image: AssetImage(imageHolder),
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : SvgPicture.network(
                            imageLoader(category.urlImg),
                            semanticsLabel: 'SVG From Network',
                            placeholderBuilder: (BuildContext context) =>
                                const Center(
                                    child: CircularProgressIndicator()),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(8.0),
              child: Text(
                "${category.title}\n",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3D3E3F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
