class CategoryList {
  List<CategoryData> list;

  CategoryList({required this.list});

  factory CategoryList.getList(dynamic jsonData) {
    List<CategoryData> l = [];
    for (var i in jsonData) {
      l.add(CategoryData.fromJson(i));
    }
    return CategoryList(list: l);
  }
}

class CategoryData {
  String id;
  String image;
  String description;

  CategoryData({
    required this.id,
    required this.image,
    required this.description,
  });

  factory CategoryData.fromJson(Map<String, dynamic> item) {
    return CategoryData(
      id: item['id'],
      image: item[''] ?? "",
      description: item['description'],
    );
  }
}

class SubCategoryList {
  List<SubCategoryData> list;

  SubCategoryList({required this.list});

  factory SubCategoryList.getList(dynamic jsonData) {
    List<SubCategoryData> l = [];
    for (var i in jsonData) {
      l.add(SubCategoryData.fromJson(i));
    }

    return SubCategoryList(list: l);
  }
}

class SubCategoryData {
  String id;
  String image;
  String description;
  String categoryId;

  SubCategoryData({
    required this.id,
    required this.image,
    required this.description,
    required this.categoryId,
  });

  factory SubCategoryData.fromJson(Map<String, dynamic> item) {
    return SubCategoryData(
      id: item['id'] ?? "",
      image: item['image'] ?? "",
      description: item['description'] ?? "",
      categoryId: item['category_id'] ?? "",
    );
  }
}
