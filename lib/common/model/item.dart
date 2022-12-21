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

  // String title;
  // String description;
  String image;
  String priceAnnounced;

  ItemData({
    required this.id,
    // required this.title,
    // required this.description,
    required this.image,
    required this.priceAnnounced,
  });

  factory ItemData.fromJson(Map<String, dynamic> item) {
    return ItemData(
      id: item['id'] ?? "",
      // title: item['title'] ?? "",
      // description: item['description'] ?? "",
      image: item['image'] ?? "",
      priceAnnounced: item['price_announced'] ?? "",
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
