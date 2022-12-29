import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/screens/favorite/favorite_obj.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../my_ads/my_items_item_list.dart';
import '../my_ads/my_items_obj.dart';
import '../profile/login_widget.dart';

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

    myItems = await service.getMyFavorite(token);

    setState(() {
      isLoading = false;
    });
  }

  removeFavorite(String id) async {
    loading(context);

    removeFav = await service.deleteFavorite(token, id);
    if (!mounted) return;

    if (!removeFav.requestStatus) {
      if (removeFav.statusCode == 200) {
        Navigator.pop(context);
        getMyFavorite();
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
        title: const Text(
          "Favorite",
          style: TextStyle(color: Colors.black),
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

          if (myItems.data!.list.isEmpty) {
            return const Center(
              child: Text("Empty"),
            );
          }

          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: ListView.builder(
              itemBuilder: (context, index) => MyItemsItemList(
                data: myItems.data!.list[index],
                listener: this,
                isFav: true,
              ),
              itemCount: myItems.data!.list.length,
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
