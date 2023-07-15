import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../category/sub_category_screen.dart';
import '../company_profile/company_profile_screen.dart';
import '../favorite/favorite_obj.dart';
import '../item_detail/item_detail.dart';
import '../profile/profile.dart';
import 'home.dart';

class HomeItem extends StatelessWidget {
  final int index;
  final HomeObj homeObj;
  final String keyLang;
  final HomeViewAllListener listener;

  const HomeItem({
    Key? key,
    required this.index,
    required this.homeObj,
    required this.keyLang,
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
                        ? AppLocalizations.of(context)!.home_hot_items
                        : index == 2
                            ? AppLocalizations.of(context)!.home_latest_items
                            : AppLocalizations.of(context)!
                                .home_company_profile,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              TextButton(
                  onPressed: () {
                    listener.viewAll(index);
                  },
                  child: Text(AppLocalizations.of(context)!.home_view_all)),
            ],
          ),
          cases(index, homeObj, keyLang),
        ],
      ),
    );
  }
}

Widget cases(int index, HomeObj homeObj, String key) {
  if (index == 0) {
    return homeItemRow(homeObj.categoryList.length, index, homeObj, "");
  } else if (index == 1) {
    return homeItemRow(
      homeObj.itemSection.hotDeals.length,
      index,
      homeObj,
      key,
    );
  } else if (index == 2) {
    return homeItemRow(
      homeObj.itemSection.latest.length,
      index,
      homeObj,
      key,
    );
  } else {
    return homeItemRow(
      homeObj.profile.length,
      index,
      homeObj,
      "",
    );
  }
}

Widget homeItemRow(int length, int index, HomeObj homeObj, String key) {
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
      list.add(HomeSubItem(
        data: homeObj.itemSection.hotDeals[i],
        isFav: homeObj.itemSection.latest[i].favorite,
        keyLang: key,
      ));
    } else if (index == 2) {
      list.add(HomeSubItem(
        data: homeObj.itemSection.latest[i],
        isFav: homeObj.itemSection.latest[i].favorite,
        keyLang: key,
      ));
    } else {
      list.add(HomeProfileItem(
        profile: homeObj.profile[i],
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryScreen(
              category: data,
            ),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsetsDirectional.only(end: 8, bottom: 12),
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
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: appColor),
                height: 52,
                width: 52,
                child: data.urlImg
                            .substring(data.urlImg.length - 3)
                            .toLowerCase() !=
                        "svg"
                    ? Image.network(
                        imageLoader(data.urlImg),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Image(
                          image: AssetImage(imageHolder),
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : SvgPicture.network(
                        imageLoader(data.urlImg),
                        semanticsLabel: 'SVG From Network',
                        placeholderBuilder: (BuildContext context) =>
                            const Center(child: CircularProgressIndicator()),
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
      ),
    );
  }
}

class HomeSubItem extends StatefulWidget {
  final ItemData data;
  final bool isFav;
  final String keyLang;

  const HomeSubItem(
      {Key? key,
      required this.data,
      required this.isFav,
      required this.keyLang})
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
                      isFav: isFav,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                widget.keyLang == "en"
                                    ? soldOutPngEn
                                    : widget.keyLang == "ar"
                                        ? soldOutPngAr
                                        : soldOutPngCkb,
                                height: 100,
                                width: 100,
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
                                  colorFilter: const ColorFilter.mode(
                                      appColor, BlendMode.srcIn),
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
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
                child: Text(
                  widget.data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                child: Text(currencyFormat(
                    widget.data.currencyType, widget.data.priceAnnounced)),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
                child: Text(
                  "${dateFormat(widget.data.statusDate)}\n",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeProfileItem extends StatelessWidget {
  final ProfileData profile;

  const HomeProfileItem({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CompanyProfileScreen(id: profile.id)));
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
