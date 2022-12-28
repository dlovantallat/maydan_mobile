import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../common/model/category.dart';
import '../../utilities/app_utilities.dart';
import '../company_profile/company_profile_screen.dart';
import '../item_detail/item_detail.dart';
import 'home.dart';

class HomeItem extends StatelessWidget {
  final int index;
  final HomeObj homeObj;

  const HomeItem({Key? key, required this.index, required this.homeObj})
      : super(key: key);

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
              Text(
                index == 0
                    ? "Categories"
                    : index == 1
                        ? "Profile"
                        : index == 2
                            ? "hot"
                            : "items",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text("View All")),
            ],
          ),
          cases(index, homeObj),
        ],
      ),
    );
  }
}

Widget cases(int index, HomeObj homeObj) {
  if (index == 0) {
    return homeItemRow(homeObj.categoryList.length, index, homeObj);
  } else if (index == 1) {
    return homeItemRow(homeObj.profile.length, index, homeObj);
  } else if (index == 2) {
    return homeItemRow(homeObj.itemSection.hotDeals.length, index, homeObj);
  } else {
    return homeItemRow(homeObj.itemSection.latest.length, index, homeObj);
  }
}

Widget homeItemRow(int length, int index, HomeObj homeObj) {
  var list = <Widget>[
    Container(
      width: 0,
    )
  ];

  for (var i = 0; i < length; i++) {
    if (index == 0) {
      list.add(HomeCategoryItem(
        data: homeObj.categoryList[i],
      ));
    } else if (index == 1) {
      list.add(HomeProfileItem(
        profile: homeObj.profile[i],
      ));
    } else if (index == 2) {
      list.add(HomeSubItem(
        data: homeObj.itemSection.hotDeals[i],
      ));
    } else {
      list.add(HomeSubItem(
        data: homeObj.itemSection.latest[i],
      ));
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
  final CategoryData data;

  const HomeCategoryItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
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
      width: 100,
      child: Column(
        children: [
          SizedBox(
            height: 65,
            width: double.infinity,
            child: Image.network(
              imageLoader(data.urlImg),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Image(
                image: AssetImage(noInternet),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 8,
              start: 8,
              end: 8,
              bottom: 8,
            ),
            child: Text(
              "${data.title}\n",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSubItem extends StatelessWidget {
  final HomeItemObj data;

  const HomeSubItem({Key? key, required this.data}) : super(key: key);

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
                        imageLoader(data.itemPhotos[0].filePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Image(
                          image: AssetImage(noInternet),
                          fit: BoxFit.fitWidth,
                        ),
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
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, top: 8),
                            child: Text(
                              data.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 8, bottom: 4),
                            child: Text(
                              DateFormat("d MMM yyyy")
                                  .format(DateTime.parse(data.statusDate)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                    child: Text("${data.priceAnnounced}\$"),
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
  final CompanyProfile profile;

  const HomeProfileItem({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CompanyProfileScreen()));
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
                  imageLoader(profile.urlPhoto),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Image(
                    image: AssetImage(noInternet),
                    fit: BoxFit.fitWidth,
                  ),
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
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
                child: Text(
                  profile.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
