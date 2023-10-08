import 'package:flutter/material.dart';
import 'package:maydan/utilities/log_event_names.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../common/model/item.dart';
import '../../main.dart';
import '../../utilities/app_utilities.dart';
import 'search_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late ApiResponse<ItemObj> search;
  bool _isLoading = false;
  bool isShow = true;
  final myController = TextEditingController();
  List<ItemData> list = [];

  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;
  String token = "";
  String key = "";

  _fetchItems() async {
    list.clear();

    setState(() {
      _isLoading = true;
    });

    String searchQuery = myController.text.trim();
    token = await getToken();
    key = await getLanguageKeyForApi();

    search = await service.getLatestDeals(token, currentPage, key,
        search: searchQuery);

    if (!search.requestStatus) {
      if (search.statusCode == 200) {
        list.addAll(search.data!.list);
        currentPage++;
        totalPage = search.data!.lastPage;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  _secondGetLatestDeals() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }
    String localLang = await getLanguageKeyForApi();
    search = await service.getLatestDeals(token, currentPage, localLang);
    list.addAll(search.data!.list);
    currentPage++;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextFormField(
          cursorColor: Colors.black,
          style:
              const TextStyle(fontSize: 14.0, height: 1, color: Colors.black),
          controller: myController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          enabled: true,
          autofocus: true,
          onChanged: (txt) {
            setState(() {
              _isLoading = true;
              isShow = false;
            });

            if (txt.isEmpty) {
              setState(() {
                isShow = true;
              });
            }

            analytics
                .logEvent(name: leSearchScreen, parameters: <String, dynamic>{
              leSearchScreen: "Search Screen",
              "search_query": myController.text.trim(),
            });

            currentPage = 1;
            _fetchItems();
          },
          decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search_sharp,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  myController.clear();
                  setState(() {
                    isShow = true;
                  });
                },
              ),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintStyle: const TextStyle(color: Colors.black),
              hintText: "Search"),
        ),
      ),
      body: Builder(builder: (_) {
        if (isShow) {
          return const Center(child: Text(""));
        }

        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (search.requestStatus) {
          return Center(child: Text(search.errorMessage));
        }

        if (list.isEmpty) {
          return const Center(child: Text("Nothing Was found"));
        }

        return Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: SmartRefresher(
            controller: refreshController,
            enablePullUp: noMoreLoad,
            enablePullDown: false,
            onLoading: () async {
              await _secondGetLatestDeals();

              if (search.requestStatus) {
                refreshController.loadFailed();
              } else {
                refreshController.loadComplete();
              }
            },
            child: ListView.builder(
              itemBuilder: (context, position) => SearchItem(
                data: list[position],
                keyLang: key,
              ),
              itemCount: list.length,
            ),
          ),
        );
      }),
    );
  }
}
