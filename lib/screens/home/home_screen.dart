import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../common/model/item.dart';
import '../../utilities/app_utilities.dart';
import '../company_profile/company_item.dart';
import '../company_profile/company_obj.dart';
import '../list_items/items_item.dart';
import '../profile/profile.dart';
import 'home.dart';
import 'home_drawer.dart';
import 'home_item.dart';
import 'home_slider.dart';

class HomeScreen extends StatefulWidget {
  final HomeDrawerListener listener;

  const HomeScreen({Key? key, required this.listener}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with HomeViewAllListener, DrawerCallBack {
  MaydanServices get service => GetIt.I<MaydanServices>();
  late ApiResponse<HomeObj> home;
  late ApiResponse<CompanyObj> companies;
  late ApiResponse<ProfileData> profile;
  late ApiResponse<ItemObj> items;
  bool isLoading = false;
  String key = "";
  String token = "";
  bool isDrawer = false;

  bool isViewAll = false;
  bool isCompany = false;
  bool isHotDeals = false;
  bool isLatest = false;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<ItemData> data = [];
  List<ProfileData> companyData = [];
  int currentPage = 1;
  int totalPage = 0;
  bool noMoreLoad = true;

  @override
  void initState() {
    getMe();
    getHome();
    super.initState();
  }

  void getHome() async {
    setState(() {
      isLoading = true;
    });

    String token = await getToken();
    String localLang = await getLanguageKeyForApi();
    home = await service.getHome(token, localLang);

    setState(() {
      isLoading = false;
    });
  }

  getMe() async {
    setState(() {
      isDrawer = false;
    });

    key = await getLanguageKey();

    String token = await getToken();
    profile = await service.getMe(token);

    if (!profile.requestStatus) {
      if (profile.statusCode == 401) {
        setToken("");
      }
    }

    setState(() {
      isDrawer = true;
    });
  }

  getActiveCompanies() async {
    setState(() {
      isLoading = true;
    });

    companies = await service.getActiveCompanies(currentPage);

    if (!companies.requestStatus) {
      if (companies.statusCode == 200) {
        companyData.addAll(companies.data!.data);
        currentPage++;
        totalPage = companies.data!.lastPage;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetCompanies() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }

    companies = await service.getActiveCompanies(currentPage);
    companyData.addAll(companies.data!.data);
    currentPage++;

    setState(() {});
  }

  void getHotDeals() async {
    setState(() {
      isLoading = true;
    });

    token = await getToken();
    String localLang = await getLanguageKeyForApi();
    items = await service.getHotDeals(token, currentPage, localLang);

    if (!items.requestStatus) {
      if (items.statusCode == 200) {
        data.addAll(items.data!.list);
        currentPage++;
        totalPage = items.data!.lastPage;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  _secondGetHotDeals() async {
    if (currentPage > totalPage) {
      refreshController.loadComplete();
      setState(() {
        noMoreLoad = false;
      });

      return;
    }
    String localLang = await getLanguageKeyForApi();
    items = await service.getHotDeals(token, currentPage, localLang);
    data.addAll(items.data!.list);
    currentPage++;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130.0),
        child: Column(
          children: [
            AppBar(
              title: SvgPicture.asset(
                homeLogoSvg,
                semanticsLabel: '',
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.home_search_caption,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: appColor, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (home.requestStatus) {
          return Center(
            child: Text(home.errorMessage),
          );
        }

        return !isViewAll
            ? ListView(
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                      start: 12,
                      end: 12,
                      top: 16,
                      bottom: 16,
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: homeSlider(context, images: home.data!.bannerList),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => HomeItem(
                      index: index,
                      homeObj: home.data!,
                      listener: this,
                    ),
                    itemCount: 4,
                  )
                ],
              )
            : Builder(builder: (context) {
                if (isCompany) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isViewAll = !isViewAll;
                              isCompany = !isCompany;
                            });
                          },
                          child: Text(
                              AppLocalizations.of(context)!.home_view_less)),
                      Expanded(
                        child: SmartRefresher(
                          controller: refreshController,
                          enablePullUp: noMoreLoad,
                          enablePullDown: false,
                          onLoading: () async {
                            await _secondGetCompanies();

                            if (companies.requestStatus) {
                              refreshController.loadFailed();
                            } else {
                              refreshController.loadComplete();
                            }
                          },
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisExtent: 230),
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: 8, start: 8, end: 8),
                              child: CompanyItem(
                                data: companies.data!.data[index],
                              ),
                            ),
                            itemCount: companies.data!.data.length,
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (isHotDeals) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isViewAll = !isViewAll;
                              isHotDeals = !isHotDeals;
                            });
                          },
                          child: Text(
                              AppLocalizations.of(context)!.home_view_less)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 4, end: 4),
                          child: SmartRefresher(
                            controller: refreshController,
                            enablePullUp: noMoreLoad,
                            enablePullDown: false,
                            onLoading: () async {
                              await _secondGetHotDeals();

                              if (items.requestStatus) {
                                refreshController.loadFailed();
                              } else {
                                refreshController.loadComplete();
                              }
                            },
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisExtent: 220),
                              itemBuilder: (BuildContext context, int index) =>
                                  ItemsItem(
                                item: data[index],
                                isFav: data[index].favorite,
                              ),
                              itemCount: data.length,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (isLatest) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isViewAll = !isViewAll;
                              isLatest = !isLatest;
                            });
                          },
                          child: Text(
                              AppLocalizations.of(context)!.home_view_less)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 4, end: 4),
                          child: SmartRefresher(
                            controller: refreshController,
                            enablePullUp: noMoreLoad,
                            enablePullDown: false,
                            onLoading: () async {
                              await _secondGetHotDeals();

                              if (items.requestStatus) {
                                refreshController.loadFailed();
                              } else {
                                refreshController.loadComplete();
                              }
                            },
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisExtent: 220),
                              itemBuilder: (BuildContext context, int index) =>
                                  ItemsItem(
                                item: data[index],
                                isFav: data[index].favorite,
                              ),
                              itemCount: data.length,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text("er");
                }
              });
      }),
      drawer: isDrawer
          ? HomeDrawer(
              listener: widget.listener,
              callBack: this,
              languageKey: key,
              profileData: profile.data,
            )
          : null,
    );
  }

  @override
  void viewAll(int index) {
    if (index == 0) {
      //Category
      widget.listener.indexListener(1);
    } else if (index == 1) {
      currentPage = 1;
      totalPage = 0;
      noMoreLoad = true;
      companyData.clear();

      setState(() {
        isViewAll = !isViewAll;
        isCompany = !isCompany;
      });
      getActiveCompanies();
    } else if (index == 2) {
      //hot
      currentPage = 1;
      totalPage = 0;
      noMoreLoad = true;
      data.clear();
      setState(() {
        isViewAll = !isViewAll;
        isHotDeals = !isHotDeals;
      });

      getHotDeals();
    } else if (index == 3) {
      //latest
      currentPage = 1;
      totalPage = 0;
      noMoreLoad = true;
      data.clear();
      setState(() {
        isViewAll = !isViewAll;
        isLatest = !isLatest;
      });

      getHotDeals();
    }
  }

  @override
  void returnKey(String key) {
    setState(() {
      this.key = key;
      isViewAll = false;
    });
    getHome();
  }
}

abstract class HomeDrawerListener {
  void indexListener(int index);
}
