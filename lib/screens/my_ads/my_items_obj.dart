import '../home/home.dart';

class MyItemsObj {
  List<MyItemData> data;

  MyItemsObj({required this.data});

  factory MyItemsObj.fromJson(Map<String, dynamic> item) {
    List<MyItemData> list = [];
    for (var i in item['data']) {
      list.add(MyItemData.fromJson(i));
    }
    return MyItemsObj(data: list);
  }
}

class MyItemData {
  String id;
  String priceAnnounced;
  List<ItemPhotos> itemPhotos;

  MyItemData(
      {required this.id,
      required this.priceAnnounced,
      required this.itemPhotos});

  factory MyItemData.fromJson(Map<String, dynamic> item) {
    List<ItemPhotos> list = [];

    for (var i in item['item_photos']) {
      list.add(ItemPhotos.fromJson(i));
    }
    return MyItemData(
      id: item['id'],
      priceAnnounced: item['price_announced'],
      itemPhotos: list,
    );
  }
}
