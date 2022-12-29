import 'package:flutter/material.dart';
import 'package:maydan/common/model/item.dart';

import '../../utilities/app_utilities.dart';
import 'my_items_obj.dart';

class MyItemsItemList extends StatelessWidget {
  final ItemData data;
  final bool isFav;
  final ItemListener listener;

  const MyItemsItemList({
    Key? key,
    required this.data,
    required this.listener,
    required this.isFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsetsDirectional.all(8),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    imageLoader(data.itemPhotos[0].filePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Image(
                      image: AssetImage(noInternet),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 16, end: 16),
                    child: Text(
                      "data data data data  \n",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text("${data.priceAnnounced} \$"),
                ],
              )),
          if (!isFav)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  border: BorderDirectional(
                    start: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_calendar_outlined)),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete_outline)),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  border: BorderDirectional(
                    start: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    listener.onFavRemove(data.id);
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

abstract class ItemListener {
  void onFavRemove(String id);
}
