import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cloud_functions/api_response.dart';
import '../../cloud_functions/maydan_services.dart';
import '../../utilities/app_utilities.dart';
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
  bool isLoading = false;
  String key = "";

  @override
  void initState() {
    getLanguage();
    getHome();
    super.initState();
  }

  void getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    key = preferences.getString(languageKey) ?? "en";
  }

  void getHome() async {
    setState(() {
      isLoading = true;
    });

    String token = await getToken();
    home = await service.getHome(token);

    setState(() {
      isLoading = false;
    });
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

        return ListView(
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
        );
      }),
      drawer: HomeDrawer(
        listener: widget.listener,
        callBack: this,
        languageKey: key,
      ),
    );
  }

  @override
  void viewAll(int index) {
    // TODO: implement viewAll
  }

  @override
  void returnKey(String key) {
    setState(() {
      this.key = key;
    });
  }
}

abstract class HomeDrawerListener {
  void indexListener(int index);
}
