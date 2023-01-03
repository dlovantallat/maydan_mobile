class ProfileData {
  String id;
  String name;
  String email;
  String msisdn;
  String userType;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.msisdn,
    required this.userType,
  });

  factory ProfileData.fromJson(Map<String, dynamic> item) {
    return ProfileData(
      id: item['id'],
      name: item['name'],
      email: item['email'],
      msisdn: item['msisdn'],
      userType: item['usertype'],
    );
  }
}
