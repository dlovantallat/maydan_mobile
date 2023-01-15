class ProfileData {
  String id;
  String name;
  String email;
  String msisdn;
  String userType;
  String categoryId;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.msisdn,
    required this.userType,
    required this.categoryId,
  });

  factory ProfileData.fromJson(Map<String, dynamic> item) {
    return ProfileData(
      id: item['id'],
      name: item['name'],
      email: item['email'],
      msisdn: item['msisdn'],
      userType: item['usertype'],
      categoryId: item['category_id'] ?? "",
    );
  }
}
