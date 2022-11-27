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
