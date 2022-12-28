class FavoriteRemove {
  String message;

  FavoriteRemove({
    required this.message,
  });

  factory FavoriteRemove.fromJson(Map<String, dynamic> item) {
    return FavoriteRemove(
      message: item['message'],
    );
  }
}

class FavoriteRequest {
  String message;
  String itemId;

  FavoriteRequest({
    required this.message,
    required this.itemId,
  });

  factory FavoriteRequest.fromJson(Map<String, dynamic> item) {
    return FavoriteRequest(
      message: item['message'] ?? "",
      itemId: item['item_id'] ?? "",
    );
  }
}
