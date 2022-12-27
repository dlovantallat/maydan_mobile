import '../../common/model/category.dart';

class HomeObj {
  List<HomeBanner> bannerList;
  List<CategoryData> categoryList;
  List<CompanyProfile> profile;
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

    List<CompanyProfile> pList = [];
    for (var i in item['companyProfilelist']) {
      pList.add(CompanyProfile.fromJson(i));
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

class CompanyProfile {
  String id;
  String msisdn;
  String name;
  String urlPhoto;

  CompanyProfile({
    required this.id,
    required this.msisdn,
    required this.name,
    required this.urlPhoto,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> item) {
    return CompanyProfile(
      id: item['id'] ?? "",
      msisdn: item['msisdn'] ?? "",
      name: item['name'] ?? "",
      urlPhoto: item['url_photo'] ?? "",
    );
  }
}

class ItemSection {
  List<HomeItemObj> hotDeals;
  List<HomeItemObj> latest;

  ItemSection({required this.hotDeals, required this.latest});

  factory ItemSection.fromJson(Map<String, dynamic> item) {
    List<HomeItemObj> list = [];
    for (var i in item['hotDeals']) {
      list.add(HomeItemObj.fromJson(i));
    }

    List<HomeItemObj> list1 = [];
    for (var i in item['latest']) {
      list1.add(HomeItemObj.fromJson(i));
    }

    return ItemSection(hotDeals: list, latest: list1);
  }
}

class HomeItemObj {
  String id;
  String title;
  String priceAnnounced;
  String statusDate;
  List<ItemPhotos> itemPhotos;

  HomeItemObj({
    required this.id,
    required this.title,
    required this.priceAnnounced,
    required this.statusDate,
    required this.itemPhotos,
  });

  factory HomeItemObj.fromJson(Map<String, dynamic> item) {
    List<ItemPhotos> list = [];

    for (var i in item['item_photos']) {
      list.add(ItemPhotos.fromJson(i));
    }

    return HomeItemObj(
      id: item['id'],
      title: item['title'],
      priceAnnounced: item['price_announced'],
      statusDate: item['status_date'],
      itemPhotos: list,
    );
  }
}

class ItemPhotos {
  String id;
  String filePath;

  ItemPhotos({required this.id, required this.filePath});

  factory ItemPhotos.fromJson(Map<String, dynamic> item) {
    return ItemPhotos(
      id: item['id'],
      filePath: item['file_path'],
    );
  }
}
