import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maydan/utilities/log_event_names.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/item.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import '../register/login_widget.dart';
import 'my_items_item_list.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with LoginCallBack, ItemListener {
  late ApiResponse<ItemObj> myItems;
  bool isLoading = false;
  bool isTokenLoading = false;
  bool isLogin = false;
  String token = "";
  String key = "";

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;

  @override
  void initState() {
    analytics.logEvent(name: leMyAdsScreen, parameters: <String, dynamic>{
      leMyAdsScreen: "My Ads Screen",
    });

    tokenCheck();
    super.initState();
  }

  tokenCheck() async {
    setState(() {
      isTokenLoading = true;
    });

    key = await getLanguageKeyForApi();
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
        noMoreLoad = false;
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
        title: Text(
          AppLocalizations.of(context)!.my_ads_title,
          style: const TextStyle(color: Colors.black),
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
            enablePullUp: noMoreLoad,
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
                keyLang: key,
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
    currentPage = 1;
    data.clear();
    getMyItems();
  }
}
