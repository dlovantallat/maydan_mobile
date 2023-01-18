import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../profile/login_widget.dart';
import 'my_items_item_list.dart';

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

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool che = true;

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

    myItems = await service.getMyItems(token, currentPage);

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

  _secondGetMyItems() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        che = false;
      });

      return;
    }

    myItems = await service.getMyItems(token, currentPage);
    data.addAll(myItems.data!.list);
    currentPage++;

    setState(() {});
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

          if (data.isEmpty) {
            return const Center(
              child: Text("Empty"),
            );
          }

          return SmartRefresher(
            controller: refreshController,
            enablePullUp: che,
            enablePullDown: false,
            onLoading: () async {
              await _secondGetMyItems();

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
                isFav: false,
              ),
              itemCount: data.length,
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
    getMyItems();
  }
}
