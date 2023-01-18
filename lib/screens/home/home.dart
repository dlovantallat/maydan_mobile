import '../../common/model/category.dart';
import '../../common/model/item.dart';
import '../profile/profile.dart';

class HomeObj {
  List<HomeBanner> bannerList;
  List<CategoryData> categoryList;
  List<ProfileData> profile;
  ItemSection itemSection;

  HomeObj(
      {required this.bannerList,
      required this.categoryList,
      required this.profile,
      required this.itemSection});

  factory HomeObj.fromJson(Map<String, dynamic> item) {
    List<HomeBanner> bList = [];
    for (var i in item['bannerlist']) {
      bList.add(HomeBanner.fromJson(i));
    }

    List<CategoryData> cList = [];
    for (var i in item['categorylist']) {
      cList.add(CategoryData.fromJson(i));
    }

    List<ProfileData> pList = [];
    for (var i in item['companyProfilelist']) {
      pList.add(ProfileData.fromJson(i));
    }

    return HomeObj(
      bannerList: bList,
      categoryList: cList,
      profile: pList,
      itemSection: ItemSection.fromJson(item['itemSection']),
    );
  }
}

class HomeBanner {
  String id;
  String name;
  String urlImg;
  String url;

  HomeBanner({
    required this.id,
    required this.name,
    required this.urlImg,
    required this.url,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> item) {
    return HomeBanner(
      id: item['id'],
      name: item['name'],
      urlImg: item['url_img'],
      url: item['url'],
    );
  }
}

class ItemSection {
  List<ItemData> hotDeals;
  List<ItemData> latest;

  ItemSection({required this.hotDeals, required this.latest});

  factory ItemSection.fromJson(Map<String, dynamic> item) {
    List<ItemData> list = [];
    for (var i in item['hotDeals']) {
      list.add(ItemData.fromJson(i));
    }

    List<ItemData> list1 = [];
    for (var i in item['latest']) {
      list1.add(ItemData.fromJson(i));
    }

    return ItemSection(hotDeals: list, latest: list1);
  }
}
