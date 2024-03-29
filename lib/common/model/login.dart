class LoginData {
  String? token;
  String? message;
  UserData? userData;

  LoginData({this.token, this.message, this.userData});

  factory LoginData.json(dynamic it) {
    return LoginData(
      token: it['token'] ?? "",
      message: it['message'] ?? "",
      userData: it['user'] == null ? null : UserData.json(it['user']),
    );
  }
}

class UserData {
  String? name;
  String? phone;
  String? usertype;

  UserData({required this.name, required this.phone, required this.usertype});

  factory UserData.json(dynamic it) {
    return UserData(
      name: it['name'],
      phone: it['msisdn'],
      usertype: it['usertype'],
    );
  }
}
