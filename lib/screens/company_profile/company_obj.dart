import '../profile/profile.dart';

class CompanyObj {
  List<ProfileData> data;
  int lastPage;

  CompanyObj({required this.data, required this.lastPage});

  factory CompanyObj.fromJson(Map<String, dynamic> item) {
    List<ProfileData> list = [];
    for (var i in item['data']) {
      list.add(ProfileData.fromJson(i));
    }
    return CompanyObj(data: list, lastPage: item['last_page']);
  }
}
