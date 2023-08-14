import 'dart:io';

class UploadImage {
  String path;
  File image;

  UploadImage(this.path, this.image);
}

class CategoryDrop {
  String id;
  String title;

  CategoryDrop(this.id, this.title);
}

class SubCategoryDrop {
  String id;
  String title;

  SubCategoryDrop(this.id, this.title);
}

class CityDrop {
  String id;
  String title;

  CityDrop(this.id, this.title);
}

class DistrictDrop {
  String id;
  String title;

  DistrictDrop(this.id, this.title);
}

class CityObj {
  List<CityData> data;

  CityObj({required this.data});

  factory CityObj.fromJson(Map<String, dynamic> item) {
    List<CityData> l = [];

    for (var i in item['data']) {
      l.add(CityData.fromJson(i));
    }

    return CityObj(data: l);
  }
}

class CityData {
  String id;
  String name;

  CityData({
    required this.id,
    required this.name,
  });

  factory CityData.fromJson(Map<String, dynamic> item) {
    return CityData(
      id: item['id'],
      name: item['name'],
    );
  }
}

class DistrictObj {
  List<DistrictData> data;

  DistrictObj({required this.data});

  factory DistrictObj.fromJson(Map<String, dynamic> item) {
    List<DistrictData> l = [];

    for (var i in item['data']) {
      l.add(DistrictData.fromJson(i));
    }

    return DistrictObj(data: l);
  }
}

class DistrictData {
  String id;
  String name;

  DistrictData({
    required this.id,
    required this.name,
  });

  factory DistrictData.fromJson(Map<String, dynamic> item) {
    return DistrictData(
      id: item['id'],
      name: item['name'],
    );
  }
}

class DurationDropDown {
  String title;
  int id;

  DurationDropDown(this.title, this.id);
}
