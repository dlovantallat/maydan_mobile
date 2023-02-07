import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../my_ads/my_items_item_list.dart';
import '../profile/login_widget.dart';
import 'favorite_obj.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with LoginCallBack, ItemListener {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemObj> myItems;
  late ApiResponse<FavoriteRemove> removeFav;
  bool isLoading = false;
  bool isTokenLoading = false;
  bool isLogin = false;
  String token = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;

  @override
  void initState() {
    tokenCheck();
    super.initState();
  }

  tokenCheck() async {
    setState(() {
      isTokenLoading = true;
    });

    token = await getToken();
    if (token == "") {
      setState(() {
        isLogin = false;
      });
    } else {
      setState(() {
        isLogin = true;
      });
      getMyFavorite();
    }
    setState(() {
      isTokenLoading = false;
    });
  }

  getMyFavorite() async {
    setState(() {
      isLoading = true;
    });

    myItems = await service.getMyFavorite(token, currentPage);

    if (!myItems.requestStatus) {
      if (myItems.statusCode == 200) {
        data.addAll(myItems.data!.list);
        currentPage++;
        totalPage = myItems.data!.lastPage;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetMyFavorite() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }

    myItems = await service.getMyFavorite(token, currentPage);
    data.addAll(myItems.data!.list);
    currentPage++;

    setState(() {});
  }

  removeFavorite(String id) async {
    loading(context);

    removeFav = await service.deleteFavorite(token, id);
    if (!mounted) return;

    if (!removeFav.requestStatus) {
      if (removeFav.statusCode == 200) {
        Navigator.pop(context);
        data.clear();
        currentPage = 1;
        getMyFavorite();
      } else {
        setSnackBar(context, AppLocalizations.of(context)!.fav_remove_not);
      }
    } else {
      Navigator.pop(context);
      setSnackBar(context, removeFav.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favorite_title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        if (isTokenLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (isLogin) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (myItems.requestStatus) {
            return Center(
              child: Text(myItems.errorMessage),
            );
          }

          if (data.isEmpty) {
            return const Center(
              child: Text("Empty"),
            );
          }

          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: SmartRefresher(
              controller: refreshController,
              enablePullUp: noMoreLoad,
              enablePullDown: false,
              onLoading: () async {
                await _secondGetMyFavorite();

                if (myItems.requestStatus) {
                  refreshController.loadFailed();
                } else {
                  refreshController.loadComplete();
                }
              },
              child: ListView.builder(
                itemBuilder: (context, index) => MyItemsItemList(
                  data: data[index],
                  listener: this,
                  isFav: true,
                ),
                itemCount: data.length,
              ),
            ),
          );
        } else {
          return LoginWidget(
            callBack: this,
          );
        }
      }),
    );
  }

  @override
  void onLogin() {
    tokenCheck();
  }

  @override
  void onFavRemove(String id) {
    removeFavorite(id);
  }
}
