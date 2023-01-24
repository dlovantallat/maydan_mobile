class ProfileData {
  String id;
  String name;
  String email;
  String msisdn;
  String userType;
  String urlPhoto;
  String categoryId;
  String address;
  CompanyCat cat;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.msisdn,
    required this.userType,
    required this.urlPhoto,
    required this.categoryId,
    required this.address,
    required this.cat,
  });

  factory ProfileData.fromJson(Map<String, dynamic> item) {
    return ProfileData(
      id: item['id'] ?? "",
      name: item['name'] ?? "",
      email: item['email'] ?? "",
      msisdn: item['msisdn'] ?? "",
      userType: item['usertype'] ?? "",
      urlPhoto: item['url_photo'] ?? "",
      categoryId: item['category_id'] ?? "",
      address: item['address'] ?? "",
      cat: CompanyCat.fromJson(item['category'])
    );
  }
}

class CompanyCat {
  String id;

  CompanyCat({required this.id});

  factory CompanyCat.fromJson(Map<String, dynamic> item) {
    return CompanyCat(
      id: item['id'] ?? "",
    );
  }
}
