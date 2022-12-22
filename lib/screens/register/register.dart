class RegisterModel {
  RegisterData user;

  RegisterModel({required this.user});

  factory RegisterModel.json(dynamic it) {
    return RegisterModel(
      user: RegisterData.json(it['user']),
    );
  }
}

class RegisterData {
  String name;

  RegisterData({required this.name});

  factory RegisterData.json(dynamic it) {
    return RegisterData(name: it['name']);
  }
}

class RequestOtpRespond {
  String message;

  RequestOtpRespond({required this.message});

  factory RequestOtpRespond.json(dynamic it) {
    return RequestOtpRespond(
      message: it['message'] == null ? "" : it['message'] as String,
    );
  }
}

class OtpRespond {
  String message;
  String token;
  String type;

  OtpRespond({required this.message, required this.token, required this.type});

  factory OtpRespond.json(dynamic it) {
    return OtpRespond(
      message: it['message'] == null ? "" : it['message'] as String,
      token: it['token'] == null ? "" : it['token'] as String,
      type: it['type'] == null ? "" : it['type'] as String,
    );
  }
}
