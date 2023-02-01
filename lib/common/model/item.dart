class ItemObj {
  List<ItemData> list;
  int lastPage;

  ItemObj({required this.list, required this.lastPage});

  factory ItemObj.fromJson(Map<String, dynamic> item) {
    List<ItemData> l = [];
    for (var i in item['data']) {
      l.add(ItemData.fromJson(i));
    }
    return ItemObj(list: l, lastPage: item['last_page']);
  }
}

class ItemData {
  String id;
  String districtId;
  String status;
  String title;
  String description;
  String statusDate;
  String currencyType;
  String districtName;
  String cityName;
  bool favorite;
  int currentAmount;
  String priceAnnounced;
  UserObj user;
  List<ItemPhotos> itemPhotos;

  ItemData({
    required this.id,
    required this.districtId,
    required this.status,
    required this.title,
    required this.description,
    required this.statusDate,
    required this.currencyType,
    required this.districtName,
    required this.cityName,
    required this.favorite,
    required this.currentAmount,
    required this.priceAnnounced,
    required this.user,
    required this.itemPhotos,
  });

  factory ItemData.fromJson(Map<String, dynamic> item) {
    List<ItemPhotos> list = [];

    for (var i in item['item_photos']) {
      list.add(ItemPhotos.fromJson(i));
    }
    return ItemData(
      id: item['id'] ?? "",
      districtId: item['district_id'] ?? "",
      status: item['status'] ?? "",
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      statusDate: item['status_date'] ?? "",
      currencyType: item['currency_type'] ?? "",
      districtName: item['district_name'] ?? "",
      cityName: item['city_name'] ?? "",
      favorite: item['favorite'] ?? false,
      currentAmount: item['current_amount'] ?? -1,
      priceAnnounced: item['price_announced'] ?? "",
      user: UserObj.fromJson(item['user']),
      itemPhotos: list,
    );
  }
}

class ItemRespond {
  String id;
  String message;

  ItemRespond({required this.id, required this.message});

  factory ItemRespond.json(dynamic it) {
    return ItemRespond(
      id: it['id'] == null ? "" : it['id'] as String,
      message: it['message'] == null ? "" : it['message'] as String,
    );
  }
}

class ItemDeleteRespond {
  String message;

  ItemDeleteRespond({required this.message});

  factory ItemDeleteRespond.fromJson(Map<String, dynamic> item) {
    return ItemDeleteRespond(message: item['message']);
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

class UserObj {
  String id;
  String msisdn;
  String name;
  String email;
  String usertype;

  UserObj({
    required this.id,
    required this.msisdn,
    required this.name,
    required this.email,
    required this.usertype,
  });

  factory UserObj.fromJson(Map<String, dynamic> item) {
    return UserObj(
      id: item['id'],
      msisdn: item['msisdn'],
      name: item['name'],
      email: item['email'],
      usertype: item['usertype'],
    );
  }
}
