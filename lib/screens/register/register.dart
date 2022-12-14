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
