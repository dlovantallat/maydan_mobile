import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../favorite/favorite_obj.dart';
import '../item_detail/item_detail.dart';

class ItemsItem extends StatefulWidget {
  final ItemData? item;
  final bool isFav;

  const ItemsItem({Key? key, this.item, required this.isFav}) : super(key: key);

  @override
  State<ItemsItem> createState() => _ItemsItemState();
}

class _ItemsItemState extends State<ItemsItem> {
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
    favReq = await service.postFavorite(token, widget.item!.id);

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

    removeFavo = await service.deleteFavorite(token, widget.item!.id);

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
                      imageLoader(widget.item!.itemPhotos.isEmpty
                          ? ""
                          : widget.item!.itemPhotos[0].filePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Image(
                        image: AssetImage(imageHolder),
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
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 8, top: 8),
                      child: Text(
                        "jsonDecode(item?.title ?? " ")['en'] ?? check name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    ),
                    Padding(
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
