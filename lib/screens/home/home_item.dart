import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../company_profile/company_obj.dart';
import '../company_profile/company_profile_screen.dart';
import '../favorite/favorite_obj.dart';
import '../item_detail/item_detail.dart';
import 'home.dart';

class HomeItem extends StatelessWidget {
  final int index;
  final HomeObj homeObj;
  final HomeViewAllListener listener;

  const HomeItem({
    Key? key,
    required this.index,
    required this.homeObj,
    required this.listener,
  }) : super(key: key);

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
                    ? AppLocalizations.of(context)!.home_categories
                    : index == 1
                        ? AppLocalizations.of(context)!.home_company_profile
                        : index == 2
                            ? AppLocalizations.of(context)!.home_hot_items
                            : AppLocalizations.of(context)!.home_latest_items,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.home_view_all)),
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
        isFav: homeObj.itemSection.latest[i].favorite,
      ));
    } else {
      list.add(HomeSubItem(
        data: homeObj.itemSection.latest[i],
        isFav: homeObj.itemSection.latest[i].favorite,
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
      margin: const EdgeInsetsDirectional.only(end: 12, bottom: 12),
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
      width: 120,
      child: Column(
        children: [
          SizedBox(
            height: 65,
            width: double.infinity,
            child: SvgPicture.network(
              imageLoader(data.urlImg),
              semanticsLabel: 'SVG From Network',
              placeholderBuilder: (BuildContext context) =>
                  const Center(child: CircularProgressIndicator()),
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

class HomeSubItem extends StatefulWidget {
  final ItemData data;
  final bool isFav;

  const HomeSubItem({Key? key, required this.data, required this.isFav})
      : super(key: key);

  @override
  State<HomeSubItem> createState() => _HomeSubItemState();
}

class _HomeSubItemState extends State<HomeSubItem> {
  @override
  void initState() {
    isFav = widget.isFav;
    super.initState();
  }

  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<FavoriteRequest> favReq;
  late ApiResponse<FavoriteRemove> removeFavo;

  bool isFav = false;

  void fav() async {
    String token = await getToken();
    favReq = await service.postFavorite(token, widget.data.id);

    if (!mounted) return;
    if (!favReq.requestStatus) {
      if (favReq.statusCode == 201) {
        setState(() {
          isFav = !isFav;
        });
      }
    } else {
      setSnackBar(context, removeFavo.errorMessage);
    }
  }

  void removeFav() async {
    String token = await getToken();

    removeFavo = await service.deleteFavorite(token, widget.data.id);

    if (!mounted) return;

    if (!removeFavo.requestStatus) {
      if (removeFavo.statusCode == 200) {
        setState(() {
          isFav = !isFav;
        });
      }
    } else {
      setSnackBar(context, removeFavo.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItemDetail(
                      item: widget.data,
                    )));
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
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 155,
                          child: Image.network(
                            imageLoader(widget.data.itemPhotos.isEmpty
                                ? ""
                                : widget.data.itemPhotos[0].filePath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Image(
                              image: AssetImage(imageHolder),
                              fit: BoxFit.cover,
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
                                  isFav
                                      ? mainFullFavoriteBottomNavigationSvg
                                      : mainFavoriteBottomNavigationSvg,
                                  color: appColor,
                                  semanticsLabel: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: isFav ? removeFav : fav,
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
                              widget.data.title,
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
                              dateFormat(widget.data.statusDate),
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
                    child: Text("${widget.data.priceAnnounced}\$"),
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
  final CompanyData profile;

  const HomeProfileItem({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CompanyProfileScreen(data: profile)));
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
                    image: AssetImage(imageHolder),
                    fit: BoxFit.cover,
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

abstract class HomeViewAllListener {
  void viewAll(int index);
}
