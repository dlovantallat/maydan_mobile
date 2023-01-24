class RegisterModel {
  RegisterData? user;
  String token;
  String message;

  RegisterModel(
      {required this.user, required this.token, required this.message});

  factory RegisterModel.json(dynamic it) {
    return RegisterModel(
      user: it['user'] == null ? null : RegisterData.json(it['user']),
      token: it['token'] == null ? "" : it['token'] as String,
      message: it['message'] == null ? "" : it['message'] as String,
    );
  }
}

class RegisterData {
  String name;

  RegisterData({required this.name});

  factory RegisterData.json(dynamic it) {
    return RegisterData(name: it['name'] == null ? "" : it['name'] as String);
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

class UpdateUser {
  String id;
  String message;

  UpdateUser({required this.id, required this.message});

  factory UpdateUser.json(dynamic it) {
    return UpdateUser(
      id: it['id'] == null ? "" : it['id'] as String,
      message: it['message'] == null ? "" : it['message'] as String,
    );
  }
}
