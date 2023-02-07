import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/meta_data_widget.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../favorite/favorite_obj.dart';
import '../home/home_slider.dart';
import '../list_items/items_item.dart';
import 'login_screen.dart';

class ItemDetail extends StatefulWidget {
  final ItemData item;
  final bool isFav;

  const ItemDetail({Key? key, required this.item, required this.isFav})
      : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<FavoriteRequest> favReq;
  late ApiResponse<FavoriteRemove> removeFavo;

  late ApiResponse<ItemObj> items;
  bool isLoading = false;
  bool isTokenLoaded = false;
  String token = "";

  bool isFav = false;

  @override
  void initState() {
    isFav = widget.isFav;
    getRelatedItem();
    super.initState();
  }

  getRelatedItem() async {
    setState(() {
      isLoading = true;
    });

    tokenLocal();

    items = await service.getRelatedItems(token, widget.item.id);

    setState(() {
      isLoading = false;
    });
  }

  void sendLogin() async {
    final dd = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));

    if (dd == "token") {
      tokenLocal();
    }
  }

  void tokenLocal() async {
    setState(() {
      isTokenLoaded = false;
    });

    token = await getToken();

    setState(() {
      isTokenLoaded = true;
    });
  }

  void callingFunctionality() {
    final uri = Uri(scheme: 'tel', path: '+${widget.item.user.msisdn}');
    canLaunchUrl(uri).then((bool result) async {
      if (result) {
        await launchUrl(uri);
      } else {
        setSnackBar(context, AppLocalizations.of(context)!.call_not_available);
      }
    });
  }

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

  void shareUrl() {
    Share.share(
        'https://maydanwebsite-production.up.railway.app/item/${widget.item.id}',
        subject: AppLocalizations.of(context)!.share_item);
  }

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
                              InkWell(
                                onTap: shareUrl,
                                child: Stack(
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
                              ),
                              InkWell(
                                onTap: isFav ? removeFav : fav,
                                child: Padding(
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
                                        isFav
                                            ? mainFullFavoriteBottomNavigationSvg
                                            : mainFavoriteBottomNavigationSvg,
                                        color: appColor,
                                        semanticsLabel: '',
                                      ),
                                    ],
                                  ),
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
                          meteData(
                              AppLocalizations.of(context)!.item_detail_price,
                              "${widget.item.priceAnnounced} ${widget.item.currencyType == "U" ? "\$" : "IQD"}"),
                          meteData(
                              AppLocalizations.of(context)!.item_detail_date,
                              dateFormat(widget.item.statusDate)),
                          meteData(
                              AppLocalizations.of(context)!
                                  .item_detail_location,
                              "${widget.item.cityName} - ${widget.item.districtName}"),
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
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.all(8),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .item_detail_owner_information,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
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
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 16, top: 8),
                                    child: Text(
                                      widget.item.user.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          isTokenLoaded
                              ? Center(
                                  child: token == ""
                                      ? TextButton(
                                          onPressed: sendLogin,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .item_detail_login_please,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      : TextButton(
                                          onPressed: callingFunctionality,
                                          child: Text(
                                            widget.item.user.msisdn,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: Text(AppLocalizations.of(context)!
                          .item_detail_similar_(widget.item.title)),
                    ),
                    Builder(builder: (context) {
                      if (isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (items.requestStatus) {
                        return Center(
                          child: Text(items.errorMessage),
                        );
                      }

                      if (items.data!.list.isEmpty) {
                        return const Center(
                          child: Text("Empty"),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 220),
                        itemBuilder: (BuildContext context, int index) =>
                            ItemsItem(
                          item: items.data!.list[index],
                          isFav: items.data!.list[index].favorite,
                        ),
                        itemCount: items.data!.list.length,
                      );
                    }),
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
