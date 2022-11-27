class ItemList {
  List<ItemData> list;

  ItemList({required this.list});

  factory ItemList.getList(dynamic jsonData) {
    List<ItemData> l = [];
    for (var i in jsonData) {
      l.add(ItemData.fromJson(i));
    }
    return ItemList(list: l);
  }
}

class ItemData {
  String id;
  String title;
  String description;
  String image;
  String priceAnnounced;

  ItemData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.priceAnnounced,
  });

  factory ItemData.fromJson(Map<String, dynamic> item) {
    return ItemData(
      id: item['id'] ?? "",
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      image: item['image'] ?? "",
      priceAnnounced: item['price_announced'] ?? "",
    );
  }
}
