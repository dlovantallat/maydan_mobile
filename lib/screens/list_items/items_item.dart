import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/item.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../favorite/favorite_obj.dart';
import '../item_detail/item_detail.dart';

class ItemsItem extends StatefulWidget {
  final ItemData item;
  final bool isFav;
  final String keyLang;

  const ItemsItem({
    Key? key,
    required this.item,
    required this.isFav,
    required this.keyLang,
  }) : super(key: key);

  @override
  State<ItemsItem> createState() => _ItemsItemState();
}

class _ItemsItemState extends State<ItemsItem> {
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
    favReq = await service.postFavorite(token, widget.item.id);

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

    removeFavo = await service.deleteFavorite(token, widget.item.id);

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
                      item: widget.item,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(20), topEnd: Radius.circular(20)),
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
                          imageLoader(widget.item.itemPhotos.isEmpty
                              ? ""
                              : widget.item.itemPhotos[0].filePath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Image(
                            image: AssetImage(imageHolder),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      widget.item.currentAmount == 0
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
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    Text(
                      currencyFormat(
                          widget.item.currencyType, widget.item.priceAnnounced),
                      maxLines: 1,
                      style: const TextStyle(height: 1),
                    ),
                    Text(
                      dateFormat(widget.item.statusDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 1),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
