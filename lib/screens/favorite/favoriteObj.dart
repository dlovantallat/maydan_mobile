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
