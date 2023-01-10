class ItemObj {
  List<ItemData> list;

  ItemObj({required this.list});

  factory ItemObj.fromJson(Map<String, dynamic> item) {
    List<ItemData> l = [];
    for (var i in item['data']) {
      l.add(ItemData.fromJson(i));
    }
    return ItemObj(list: l);
  }
}

class ItemData {
  String id;
  String status;
  String title;
  String description;
  String statusDate;
  bool favorite;
  String priceAnnounced;
  UserObj user;
  List<ItemPhotos> itemPhotos;

  ItemData({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.statusDate,
    required this.favorite,
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
      status: item['status'] ?? "",
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      statusDate: item['status_date'] ?? "",
      favorite: item['favorite'] ?? false,
      priceAnnounced: item['price_announced'] ?? "",
      user: UserObj.fromJson(item['user']),
      itemPhotos: list,
    );
  }
}

class ItemRespond {
  String id;

  ItemRespond({required this.id});

  factory ItemRespond.json(dynamic it) {
    return ItemRespond(
      id: it['id'] as String,
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
