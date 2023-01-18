class StaticContentObj {
  String id;
  String name;
  String message;

  StaticContentObj(
      {required this.id, required this.name, required this.message});

  factory StaticContentObj.fromJson(Map<String, dynamic> item) {
    return StaticContentObj(
      id: item['id'] ?? "",
      name: item['name'] ?? "",
      message: item['message'] ?? "",
    );
  }
}
