import '../profile/profile.dart';

class CompanyObj {
  List<ProfileData> data;

  CompanyObj({required this.data});

  factory CompanyObj.fromJson(Map<String, dynamic> item) {
    List<ProfileData> list = [];
    for (var i in item['data']) {
      list.add(ProfileData.fromJson(i));
    }
    return CompanyObj(data: list);
  }
}

