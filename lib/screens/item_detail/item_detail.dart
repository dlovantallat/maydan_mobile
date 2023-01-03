import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/app_utilities.dart';
import '../list_items/items_item.dart';
import 'detail_item_meta_data.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

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
                          child: Image.network(
                            height: 300,
                            width: double.infinity,
                            'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Image(
                              image: AssetImage(mainProfileBottomNavigationSvg),
                              fit: BoxFit.cover,
                            ),
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
                            child: const Center(
                              child: Text("Cow"),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                const DetailItemMetaData(),
                            itemCount: 4,
                          )
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
                      child: const Padding(
                        padding: EdgeInsetsDirectional.all(8),
                        child: Text("Description"),
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
                                    padding: EdgeInsetsDirectional.only(
                                        start: 8, top: 8),
                                    child: Text(
                                      "Duration",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
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
                          )),
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
