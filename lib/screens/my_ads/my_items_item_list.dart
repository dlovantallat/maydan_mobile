import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import 'edit_item.dart';

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
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemRespond> updateItemRequest;
  bool isPop = false;

  void openEditItem() async {
    final dd = await Navigator.push(context,
        MaterialPageRoute(builder: (_) => EditItem(item: widget.data)));

    if (dd == "refresh_update") {
      widget.listener.onFavRemove("id");
    }
  }

  soldOut() async {
    String token = await getToken();

    updateItemRequest = await service.soldOutItem(
      token: token,
      itemId: widget.data.id,
      title: widget.data.title,
      description: widget.data.title,
    );
    if (!mounted) return;

    if (!updateItemRequest.requestStatus) {
      if (updateItemRequest.statusCode == 200) {
        widget.listener.onFavRemove("id");
      } else {
        setSnackBar(context, "item can't be sold out there is an error");
      }
    } else {
      setSnackBar(context, updateItemRequest.errorMessage);
    }
  }

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
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          imageLoader(widget.data.itemPhotos.isEmpty
                              ? ""
                              : widget.data.itemPhotos[0].filePath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Image(
                            image: AssetImage(imageHolder),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      widget.data.currentAmount == 0
                          ? Image.asset(
                              soldOutPng,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            bottom: 16, end: 16),
                        child: Text(
                          "${widget.data.title}\n",
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
                        openEditItem();
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
                        if (widget.data.currentAmount == 0) {
                          return;
                        }

                        soldOut();
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
