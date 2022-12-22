class CategoryObj {
  List<CategoryData> data;

  CategoryObj({required this.data});

  factory CategoryObj.fromJson(Map<String, dynamic> item) {
    List<CategoryData> l = [];
    for (var i in item['data']) {
      l.add(CategoryData.fromJson(i));
    }
    return CategoryObj(data: l);
  }
}

class CategoryData {
  String id;
  String title;
  String description;
  String urlImg;

  CategoryData({
    required this.id,
    required this.title,
    required this.description,
    required this.urlImg,
  });

  factory CategoryData.fromJson(Map<String, dynamic> item) {
    return CategoryData(
      id: item['id'] ?? "",
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      urlImg: item['url_img'] ?? "",
    );
  }
}

class SubCategoryObj {
  List<SubCategoryData> data;

  SubCategoryObj({required this.data});

  factory SubCategoryObj.fromJson(Map<String, dynamic> item) {
    List<SubCategoryData> l = [];
    for (var i in item['data']) {
      l.add(SubCategoryData.fromJson(i));
    }

    return SubCategoryObj(data: l);
  }
}

class SubCategoryData {
  String id;
  String title;
  String description;
  String categoryId;

  SubCategoryData({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
  });

  factory SubCategoryData.fromJson(Map<String, dynamic> item) {
    return SubCategoryData(
      id: item['id'] ?? "",
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      categoryId: item['category_id'] ?? "",
    );
  }
}
