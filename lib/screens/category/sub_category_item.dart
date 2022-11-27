import 'package:flutter/material.dart';

import '../../common/model/category.dart';
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
        return const ListItemsScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubItemClick,
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Text(
                    subCategory.id,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
