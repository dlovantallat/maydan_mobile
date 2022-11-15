import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydan/screens/item_detail/item_detail.dart';

import '../../utilities/app_utilities.dart';

class HomeItem extends StatelessWidget {
  final int index;

  const HomeItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16, end: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text("View All")),
            ],
          ),
          cases(index),
        ],
      ),
    );
  }
}

Widget cases(int index) {
  switch (index) {
    case 0:
      return homeItemRow([
        "1",
        "2",
        "3",
      ], index);

    case 4:
      return homeItemRow([
        "1",
        "4",
      ], index);

    default:
      return homeItemRow([
        "1",
        "2",
        "3",
        "4",
      ], index);
  }
}

Widget homeItemRow(List<String> category, int index) {
  var list = <Widget>[
    Container(
      width: 0,
    )
  ];

  for (var i in category) {
    switch (index) {
      case 0:
        list.add(const HomeCategoryItem());
        break;

      case 4:
        list.add(const HomeProfileItem());
        break;

      default:
        list.add(const HomeSubItem());
        break;
    }
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    ),
  );
}

class HomeCategoryItem extends StatelessWidget {
  const HomeCategoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 12),
      decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                offset: const Offset(12, 12),
                color: const Color(0x06b4b0b0).withOpacity(.8),
                spreadRadius: -9)
          ]),
      width: 90,
      child: Column(
        children: [
          SizedBox(
            height: 65,
            child: SvgPicture.asset(
              homeLogoSvg,
              semanticsLabel: '',
              color: appColor,
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(
              start: 8,
              end: 8,
              bottom: 8,
            ),
            child: Text("Category"),
          ),
        ],
      ),
    );
  }
}

class HomeSubItem extends StatelessWidget {
  const HomeSubItem({Key? key}) : super(key: key);

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
        child: SizedBox(
          width: 165,
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(20),
                      topEnd: Radius.circular(20)),
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
                    children: const [
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 8, top: 8),
                        child: Text(
                          "item Home SubItem ssd",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 8, bottom: 4),
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
      ),
    );
  }
}

class HomeProfileItem extends StatelessWidget {
  const HomeProfileItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      color: const Color(0xFFE5E5E5),
      margin: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 16),
      child: SizedBox(
        width: 165,
        child: Column(children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20), topEnd: Radius.circular(20)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 155,
              child: Image.network(
                "https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1988&q=80",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(20), topEnd: Radius.circular(20)),
            ),
            height: 45,
            width: 165,
            child: const Padding(
              padding: EdgeInsetsDirectional.only(start: 8, top: 8),
              child: Text(
                "item Home item Home item Home ",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
