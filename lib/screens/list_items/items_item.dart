import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../item_detail/item_detail.dart';

class ItemsItem extends StatelessWidget {
  final ItemData? item;

  const ItemsItem({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ItemDetail()));
      },
      child: Card(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: const Color(0xFFE5E5E5),
        margin: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 16),
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(20), topEnd: Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 155,
                    child: Image.network(
                      "https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: IconButton(
                      icon: Stack(
                        children: [
                          SvgPicture.asset(
                            favBoarderSvg,
                            semanticsLabel: '',
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.all(8),
                            child: Align(
                              child: SvgPicture.asset(
                                mainFullFavoriteBottomNavigationSvg,
                                color: appColor,
                                semanticsLabel: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 8, top: 8),
                      child: Text(
                        jsonDecode(item?.title ?? "")['en'] ?? "check name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.only(start: 8, bottom: 4),
                      child: Text(
                        "25/12/2022",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                  ],
                )),
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: 8, end: 8),
                  child: Text("10\$"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
