import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:maydan/common/model/item.dart';
import 'package:maydan/screens/my_ads/my_items_item_list.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
import '../profile/login_widget.dart';
import 'my_items_obj.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with LoginCallBack, ItemListener {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<ItemObj> myItems;
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
      getMyItems();
    }
    setState(() {
      isTokenLoading = false;
    });
  }

  getMyItems() async {
    setState(() {
      isLoading = true;
    });

    myItems = await service.getMyItems(token);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Ads",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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

          return ListView.builder(
            itemBuilder: (context, index) => MyItemsItemList(
              data: myItems.data!.list[index],
              listener: this,
              isFav: false,
            ),
            itemCount: myItems.data!.list.length,
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
    // TODO: implement onFavRemove
  }
}
