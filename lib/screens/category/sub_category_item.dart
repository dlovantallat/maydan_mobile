import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Container(
                color: const Color(0xFFF9F9F9),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(0.0),
                    child: Image.network(
                      imageLoader(subCategory.urlImg),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(imageHolder),
                      ),
                    ),
                  ),
                ),
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
                "${subCategory.title}\n",
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
