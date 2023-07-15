class Config {
  Update? data;

  Config({required this.data});

  factory Config.fromJson(Map<String, dynamic> item) {
    return Config(
      data: item['data'] == null ? null : Update.fromJson(item['data']),
    );
  }
}

class Update {
  String appleStoreLinkAppId;
  String androidStoreLinkPackage;
  ConfigTitle title;
  ConfigDes content;
  String updateMethod;

  Update({
    required this.appleStoreLinkAppId,
    required this.androidStoreLinkPackage,
    required this.title,
    required this.content,
    required this.updateMethod,
  });

  factory Update.fromJson(Map<String, dynamic> item) {
    return Update(
      appleStoreLinkAppId: item['apple_store_link_app_id'],
      androidStoreLinkPackage: item['android_store_link_package'],
      title: ConfigTitle.fromJson(item['title']),
      content: ConfigDes.fromJson(item['description']),
      updateMethod: item['updateMethod'] ?? "force",
    );
  }
}

class ConfigTitle {
  String en;
  String ar;
  String ku;

  ConfigTitle({required this.en, required this.ar, required this.ku});

  factory ConfigTitle.fromJson(Map<String, dynamic> item) {
    return ConfigTitle(en: item['en'], ar: item['ar'], ku: item['ku']);
  }
}

class ConfigDes {
  String en;
  String ar;
  String ku;

  ConfigDes({required this.en, required this.ar, required this.ku});

  factory ConfigDes.fromJson(Map<String, dynamic> item) {
    return ConfigDes(en: item['en'], ar: item['ar'], ku: item['ku']);
  }
}
