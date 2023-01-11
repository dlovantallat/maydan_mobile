import 'package:flutter/material.dart';
import 'package:maydan/screens/my_ads/edit_item.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';

class MyItemsItemList extends StatefulWidget {
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
  State<MyItemsItemList> createState() => _MyItemsItemListState();
}

class _MyItemsItemListState extends State<MyItemsItemList> {
  bool isPop = false;

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
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsetsDirectional.all(8),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        imageLoader(widget.data.itemPhotos.isEmpty
                            ? ""
                            : widget.data.itemPhotos[0].filePath),
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
                        padding:
                            EdgeInsetsDirectional.only(bottom: 16, end: 16),
                        child: Text(
                          "data data data data  \n",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Text("${widget.data.priceAnnounced} \$"),
                    ],
                  )),
              if (!widget.isFav)
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: BorderDirectional(
                        start: BorderSide(width: 1.0, color: Colors.black),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, end: 8),
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  print("sss");
                                  isPop = true;
                                });
                              },
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
                        widget.listener.onFavRemove(widget.data.id);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ),
            ],
          ),
          if (!widget.isFav)
            if (isPop)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                  color: appColor,
                ),
                height: 75,
                width: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isPop = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditItem(item: widget.data)));
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 8, end: 8, top: 4, bottom: 4),
                            child: Icon(
                              Icons.edit_calendar_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isPop = false;
                        });
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 8, end: 8, top: 4, bottom: 4),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Sold Out",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Container()
          else
            Container(),
        ],
      ),
    );
  }
}

abstract class ItemListener {
  void onFavRemove(String id);
}
