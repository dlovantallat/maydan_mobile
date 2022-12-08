class LoginData {
  String? token;
  String? message;

  LoginData({
    this.token,
    this.message,
  });

  factory LoginData.json(dynamic it) {
    return LoginData(
      token: it['token'],
      message: it['message'],
    );
  }
}
