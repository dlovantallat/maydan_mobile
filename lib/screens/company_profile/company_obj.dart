class CompanyObj {
  List<CompanyData> data;

  CompanyObj({required this.data});

  factory CompanyObj.fromJson(Map<String, dynamic> item) {
    List<CompanyData> list = [];
    for (var i in item['data']) {
      list.add(CompanyData.fromJson(i));
    }
    return CompanyObj(data: list);
  }
}

class CompanyData {
  String id;
  String name;
  String email;
  String usertype;
  String msisdn;
  String urlPhoto;

  CompanyData({
    required this.id,
    required this.name,
    required this.email,
    required this.usertype,
    required this.msisdn,
    required this.urlPhoto,
  });

  factory CompanyData.fromJson(Map<String, dynamic> item) {
    return CompanyData(
      id: item['id'] ?? "",
      name: item['name'] ?? "",
      email: item['email'] ?? "",
      usertype: item['usertype'] ?? "",
      msisdn: item['msisdn'] ?? "",
      urlPhoto: item['url_photo'] ?? "",
    );
  }
}
