class ProfileData {
  String id;
  String name;
  String email;
  String msisdn;
  String userType;
  String urlPhoto;
  String urlBanner;
  String categoryId;
  String address;
  String? facebook;
  String? instagram;
  String? youtube;
  String? whatsapp;
  String? viber;
  CompanyCat? cat;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.msisdn,
    required this.userType,
    required this.urlPhoto,
    required this.urlBanner,
    required this.categoryId,
    required this.address,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    required this.whatsapp,
    required this.viber,
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
        urlBanner: item['url_banner'] ?? "",
        categoryId: item['category_id'] ?? "",
        address: item['address'] ?? "",
        facebook: item['url_facebook'] ?? "",
        instagram: item['url_instagram'] ?? "",
        youtube: item['url_youtube'] ?? "",
        whatsapp: item['whatsapp'] ?? "",
        viber: item['viber'] ?? "",
        cat: item['category'] != null
            ? CompanyCat.fromJson(item['category'])
            : null);
  }
}

class CompanyCat {
  String id;
  CatTitle title;

  CompanyCat({required this.id, required this.title});

  factory CompanyCat.fromJson(Map<String, dynamic> item) {
    return CompanyCat(
      id: item['id'] ?? "",
      title: CatTitle.fromJson(item['title']),
    );
  }
}

class CatTitle {
  String ar;
  String en;
  String ckb;

  CatTitle({required this.ar, required this.en, required this.ckb});

  factory CatTitle.fromJson(Map<String, dynamic> item) {
    return CatTitle(
      ar: item['ar'] ?? "",
      en: item['en'] ?? "",
      ckb: item['ckb'] ?? "",
    );
  }
}
