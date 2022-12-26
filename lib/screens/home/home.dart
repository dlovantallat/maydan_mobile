class HomeObj {
  List<HomeBanner> bannerList;

  HomeObj({
    required this.bannerList,
  });

  factory HomeObj.fromJson(Map<String, dynamic> item) {
    List<HomeBanner> bList = [];
    for (var i in item['bannerlist']) {
      bList.add(HomeBanner.fromJson(i));
    }
    return HomeObj(bannerList: bList);
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
