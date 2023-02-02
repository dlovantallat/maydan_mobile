class StaticContentObj {
  String id;
  String name;
  String title;
  String text;
  String message;

  StaticContentObj(
      {required this.id,
      required this.name,
      required this.title,
      required this.text,
      required this.message});

  factory StaticContentObj.fromJson(Map<String, dynamic> item) {
    return StaticContentObj(
      id: item['id'] ?? "",
      name: item['name'] ?? "",
      title: item['title'] ?? "",
      text: item['text'] ?? "",
      message: item['message'] ?? "",
    );
  }
}
