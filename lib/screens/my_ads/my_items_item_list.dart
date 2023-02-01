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
  late ApiResponse<ItemDeleteRespond> deleteItemRequest;
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

  deleteItem() async {
    String token = await getToken();

    deleteItemRequest = await service.deleteItem(token, widget.data.id);

    if (!deleteItemRequest.requestStatus) {
      if (deleteItemRequest.statusCode == 200) {
        widget.listener.onFavRemove("");
      } else {
        print("ddd");
      }
    } else {
      print(deleteItemRequest.errorMessage);
    }
  }

  deletePopup() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(""),
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(top: 8, bottom: 16),
                      child: Text(
                        "Are you sure you want to delete this post",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, end: 8),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.resolveWith<Size>(
                                  (Set<MaterialState> states) {
                                    return const Size(
                                      double.infinity,
                                      40,
                                    );
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No, keep it".toUpperCase()),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              deleteItem();
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                appColor,
                              ),
                              minimumSize:
                                  MaterialStateProperty.resolveWith<Size>(
                                (Set<MaterialState> states) {
                                  return const Size(
                                    double.infinity,
                                    40,
                                  );
                                },
                              ),
                            ),
                            child: Text("Yes, Deleted".toUpperCase()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: true);
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
                        padding: EdgeInsetsDirectional.only(
                            bottom: !widget.isFav ? 0 : 16, end: 16),
                        child: Text(
                          "${widget.data.title}\n",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (!widget.isFav) customDivider() else const SizedBox(),
                      Text(
                          "${widget.data.priceAnnounced} ${widget.data.currencyType == "U" ? "\$" : "IQD"}"),
                      if (!widget.isFav) customDivider() else const SizedBox(),
                      !widget.isFav
                          ? Text(
                              "Status: ${widget.data.currentAmount == 0 ? "Sold out" : widget.data.status == "I" ? "in review" : "published"}")
                          : const SizedBox(),
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
                              onPressed: deletePopup,
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

Widget customDivider() {
  return const Divider(
    thickness: 1,
    color: Colors.black,
  );
}

abstract class ItemListener {
  void onFavRemove(String id);
}
