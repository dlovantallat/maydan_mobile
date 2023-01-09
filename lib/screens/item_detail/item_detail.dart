import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/common/meta_data_widget.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../home/home_slider.dart';
import '../list_items/items_item.dart';

class ItemDetail extends StatefulWidget {
  final ItemData item;

  const ItemDetail({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 20),
                          child: widget.item.itemPhotos.isEmpty
                              ? const Image(
                                  height: 220,
                                  width: double.infinity,
                                  image: AssetImage(imageHolder),
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(
                                  height: 220,
                                  child: homeSlider(context,
                                      itemPhotos: widget.item.itemPhotos),
                                ),
                        ),
                        PositionedDirectional(
                          end: 0,
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  SvgPicture.asset(
                                    height: 50,
                                    favBoarderSvg,
                                    semanticsLabel: '',
                                  ),
                                  SvgPicture.asset(
                                    shareSvg,
                                    semanticsLabel: '',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 8, end: 8),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    SvgPicture.asset(
                                      height: 50,
                                      favBoarderSvg,
                                      semanticsLabel: '',
                                    ),
                                    SvgPicture.asset(
                                      height: 24,
                                      mainFullFavoriteBottomNavigationSvg,
                                      semanticsLabel: '',
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 8, end: 8, bottom: 16, top: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(10),
                                  topEnd: Radius.circular(10)),
                              color: appColor,
                            ),
                            child: Center(
                              child: Text(widget.item.title),
                            ),
                          ),
                          meteData("Price", widget.item.priceAnnounced),
                          meteData("Date", dateFormat(widget.item.statusDate)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsetsDirectional.only(
                          bottom: 8, start: 8, end: 8),
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(8),
                        child: Text(widget.item.description),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColor,
                      ),
                      margin: const EdgeInsetsDirectional.all(8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: BorderDirectional(
                                      end: BorderSide(color: Colors.black),
                                      bottom: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  height: 40,
                                  child: const Padding(
                                    padding: EdgeInsetsDirectional.all(8),
                                    child: Center(
                                      child: Text(
                                        "Owner Information",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: BorderDirectional(
                                      bottom: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  height: 40,
                                  child: const Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 16, top: 8),
                                    child: Text(
                                      "widget.data.duration widget",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsetsDirectional.all(16),
                              child: Text("data"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.all(8.0),
                      child: Text("Similar Products"),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 220),
                      itemBuilder: (BuildContext context, int index) =>
                          const ItemsItem(
                        isFav: false,
                      ),
                      itemCount: 0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
