import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:maydan/screens/config/config_model.dart';
import 'package:maydan/screens/static_content/static_content_obj.dart';

import '../common/model/category.dart';
import '../common/model/item.dart';
import '../common/model/login.dart';
import '../screens/company_profile/company_obj.dart';
import '../screens/favorite/favorite_obj.dart';
import '../screens/home/home.dart';
import '../screens/post/post_obj.dart';
import '../screens/profile/profile.dart';
import '../screens/register/register.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = dotenv.env['BASE_URL'] ?? "";
  final String noInternet =
      "No Internet, Please check your internet connection.";

  static const Duration timeOutDuration = Duration(seconds: 15);
  static const int perPage = 10;

  Map<String, String> headers({String token = '', String languageKey = 'en'}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'app-language': languageKey,
    };
  }

  Map<String, String> headersForOtp(String phone, String languageKey) {
    int phoneNo = int.parse(phone);
    final now = DateTime.now();
    final encryptedNo = (((phoneNo * now.year * now.month) /
                (now.minute + now.day + now.hour)) *
            (now.month + now.day))
        .toInt();
    final sKey = dotenv.env['SECRET_KEY'];
    return {
      'x-sub-version': '$encryptedNo$sKey',
      'app-language': languageKey,
    };
  }

  Future<ApiResponse<HomeObj>> getHome(String token, String localLang) {
    return http
        .get(Uri.parse("${baseURL}home"),
            headers: headers(token: token, languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = HomeObj.fromJson(jsonData);

          return ApiResponse<HomeObj>(data: list);
        }
        return ApiResponse<HomeObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<HomeObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<CategoryObj>> getCategories(String localLang) {
    return http
        .get(Uri.parse("${baseURL}categories?per_page=60"),
            headers: headers(languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CategoryObj.fromJson(jsonData);

          return ApiResponse<CategoryObj>(data: list, statusCode: 200);
        }
        return ApiResponse<CategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CategoryObj>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<SubCategoryObj>> getSubCategories(
      String categoryId, String localLang) {
    return http
        .get(
            Uri.parse(
                "${baseURL}categories/$categoryId/subcategories?per_page=60"),
            headers: headers(languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = SubCategoryObj.fromJson(jsonData);

          return ApiResponse<SubCategoryObj>(data: list, statusCode: 200);
        }
        return ApiResponse<SubCategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<SubCategoryObj>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<CompanyObj>> getActiveCompanies(int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}users/activesCompanies?per_page=$perPage&page=$currentPage"),
            headers: headers())
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CompanyObj.fromJson(jsonData);

          return ApiResponse<CompanyObj>(data: list, statusCode: 200);
        }
        return ApiResponse<CompanyObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CompanyObj>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getItems(
      String token, String subCategoryId, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}subcategories/$subCategoryId/items?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemRespond>> postItem({
    required String token,
    required String title,
    required String sellerName,
    required String phoneNumber,
    required String price,
    required String description,
    required String subCategory,
    required String duration,
    required String currencyType,
    required String districtId,
    required String firebaseToken,
    required String prefLang,
    required List<UploadImage> uploadedPhotos,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}items"));
    request.fields['title'] = jsonEncode({
      "en": title,
      "ckb": title,
      "ar": title,
    });
    request.fields['subcategory_id'] = subCategory;
    request.fields['description'] = jsonEncode({
      "en": description,
      "ckb": description,
      "ar": description,
    });
    request.fields['duration'] = duration;
    request.fields['seller_name'] = sellerName;
    request.fields['phone_number'] = phoneNumber;
    request.fields['currency_type'] = currencyType == "USD" ? "U" : "I";
    request.fields['district_id'] = districtId;
    request.fields['price_announced'] = price;
    request.fields['firebase_token'] = firebaseToken;
    request.fields['pref_lang'] = prefLang;

    List<http.MultipartFile> newList = <http.MultipartFile>[];

    // --- Start uploading photos ---
    for (int i = 0; i < uploadedPhotos.length; i++) {
      newList.add(await http.MultipartFile.fromPath(
          'photos[$i]', uploadedPhotos[i].path,
          contentType: MediaType("image", "jpeg")));
    }
    request.files.addAll(newList);
    // --- End uploading photos ---

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 201);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();
          final register = ItemRespond.json(jsonDecode(respStr));
          return ApiResponse<ItemRespond>(
              statusCode: 422, errorMessage: register.message);
        }
        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ItemRespond>> updateItem({
    required String token,
    required String itemId,
    required String districtId,
    required String title,
    required String description,
    required String price,
    required String currencyType,
    required String duration,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseURL}items/$itemId?_method=PUT"));
    request.fields['title'] = jsonEncode({
      "en": title,
      "ckb": title,
      "ar": title,
    });
    request.fields['description'] = jsonEncode({
      "en": description,
      "ckb": description,
      "ar": description,
    });
    request.fields['district_id'] = districtId;
    request.fields['currency_type'] = currencyType == "USD" ? "U" : "I";
    request.fields['duration'] = duration;
    request.fields['price'] = price;

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          return ApiResponse<ItemRespond>(statusCode: 422);
        }

        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ItemRespond>> soldOutItem({
    required String token,
    required String itemId,
    required String title,
    required String description,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseURL}items/$itemId?_method=PUT"));
    request.fields['title'] = jsonEncode({"en": title});
    request.fields['description'] = jsonEncode({"en": description});
    request.fields['current_amount'] = "0";

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          return ApiResponse<ItemRespond>(statusCode: 422);
        }

        return ApiResponse<ItemRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<LoginData>> login(String phoneNumber, String password) {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}login"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['password'] = password;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = LoginData.json(jsonDecode(respStr));

          return ApiResponse<LoginData>(data: login);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final login = LoginData.json(jsonDecode(respStr));

          return ApiResponse<LoginData>(data: login, statusCode: 401);
        }
        return ApiResponse<LoginData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<LoginData>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RequestOtpRespond>> requestPinCode(
      String phoneNumber, bool isPersonal) {
    String endPoint = dotenv.env['OTP_END_POINT'] ?? "";
    var request = http.MultipartRequest('POST', Uri.parse(baseURL + endPoint));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['usertype'] = !isPersonal ? "P" : "C";

    request.headers.addAll(headersForOtp("964$phoneNumber", "en"));
    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = RequestOtpRespond.json(jsonDecode(respStr));
          return ApiResponse<RequestOtpRespond>(data: login, statusCode: 200);
        } else if (data.statusCode == 403) {
          return ApiResponse<RequestOtpRespond>(statusCode: 403);
        } else if (data.statusCode == 429) {
          return ApiResponse<RequestOtpRespond>(statusCode: 429);
        }

        return ApiResponse<RequestOtpRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RequestOtpRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RequestOtpRespond>> requestChangePass(String phoneNumber) {
    String endPoint = dotenv.env['OTP_FORGET_END_POINT'] ?? "";
    var request = http.MultipartRequest('POST', Uri.parse(baseURL + endPoint));

    request.fields['msisdn'] = "964$phoneNumber";

    request.headers.addAll(headersForOtp("964$phoneNumber", "en"));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();
          final login = RequestOtpRespond.json(jsonDecode(respStr));
          return ApiResponse<RequestOtpRespond>(data: login, statusCode: 200);
        } else if (data.statusCode == 403) {
          return ApiResponse<RequestOtpRespond>(statusCode: 403);
        } else if (data.statusCode == 429) {
          return ApiResponse<RequestOtpRespond>(statusCode: 429);
        }

        return ApiResponse<RequestOtpRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RequestOtpRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<OtpRespond>> verifyPinCode(
      String phoneNumber, String otp) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}verifyPincode"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['pincode'] = otp;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 200);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 403);
        }

        return ApiResponse<OtpRespond>(
            requestStatus: true,
            errorMessage: "API Communication Down",
            statusCode: 0);
      },
    ).catchError(
      (s) => ApiResponse<OtpRespond>(
          requestStatus: true, errorMessage: s.toString(), statusCode: 0),
    );
  }

  Future<ApiResponse<OtpRespond>> verifyChangePass(
      String phoneNumber, String otp) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}verifyChangePass"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['pincode'] = otp;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 200);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 403);
        }

        return ApiResponse<OtpRespond>(
            requestStatus: true,
            errorMessage: "API Communication Down",
            statusCode: 0);
      },
    ).catchError(
      (s) => ApiResponse<OtpRespond>(
          requestStatus: true, errorMessage: s.toString(), statusCode: 0),
    );
  }

  Future<ApiResponse<ChangePassword>> changePassword(
    String token,
    String phoneNumber,
    String password,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}changePassword"));

    request.fields['token'] = token;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['msisdn'] = phoneNumber;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = ChangePassword.json(jsonDecode(respStr));

          return ApiResponse<ChangePassword>(data: register);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = ChangePassword.json(jsonDecode(respStr));
          return ApiResponse<ChangePassword>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = ChangePassword.json(jsonDecode(respStr));
          return ApiResponse<ChangePassword>(
              statusCode: 403, errorMessage: register.message);
        }

        return ApiResponse<ChangePassword>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ChangePassword>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RegisterModel>> register(
      String name,
      String email,
      String token,
      String phoneNumber,
      String password,
      String categoryId,
      String? path,
      String? address,
      bool isPersonal) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}register"));

    request.fields['name'] = name;
    if (email.isNotEmpty) {
      request.fields['email'] = email;
    }

    request.fields['token'] = token;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['msisdn'] = phoneNumber;

    if (isPersonal) {
      request.fields['category_id'] = categoryId;
      request.fields['address'] = address!;
    }

    if (path != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', path,
          contentType: MediaType("image", "jpeg")));
    }

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));

          return ApiResponse<RegisterModel>(data: register);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 403, errorMessage: register.message);
        }

        return ApiResponse<RegisterModel>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RegisterModel>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RegisterModel>> social(
      {required String token,
      required String name,
      bool isFace = false}) async {
    http.MultipartRequest request;
    if (isFace) {
      request = http.MultipartRequest(
          'POST', Uri.parse("${baseURL}socialite/facebook"));
    } else {
      request =
          http.MultipartRequest('POST', Uri.parse("${baseURL}socialite/apple"));
    }

    request.fields['authToken'] = token;

    if (name.isNotEmpty) {
      request.fields['fullName'] = name;
    }

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));

          return ApiResponse<RegisterModel>(data: register);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));
          return ApiResponse<RegisterModel>(
              statusCode: 403, errorMessage: register.message);
        }

        return ApiResponse<RegisterModel>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RegisterModel>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<UpdateUser>> updateMe(
      String name,
      String email,
      String? path,
      String? pathBanner,
      String token,
      String catId,
      bool isPersonal) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}users?_method=PUT"));

    request.fields['name'] = name;
    if (email.isNotEmpty) {
      request.fields['email'] = email;
    }
    if (path != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', path,
          contentType: MediaType("image", "jpeg")));
    }
    if (!isPersonal) {
      if (pathBanner != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'banner', pathBanner,
            contentType: MediaType("image", "jpeg")));
      }

      request.fields['category_id'] = catId;
    }

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));

          return ApiResponse<UpdateUser>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 403, errorMessage: register.message);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 401, errorMessage: register.message);
        }

        return ApiResponse<UpdateUser>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<UpdateUser>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<UpdateUser>> updateSocialMedia(String fb, String instagram,
      String youtube, String whatsapp, String viber, String token) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}users?_method=PUT"));

    request.fields['url_facebook'] = fb;
    request.fields['url_instagram'] = instagram;
    request.fields['url_youtube'] = youtube;
    request.fields['whatsapp'] = whatsapp;
    request.fields['viber'] = viber;

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));

          return ApiResponse<UpdateUser>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 403, errorMessage: register.message);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 401, errorMessage: register.message);
        }

        return ApiResponse<UpdateUser>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<UpdateUser>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ProfileData>> getMe(String token) {
    return http
        .get(Uri.parse("${baseURL}users"), headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final me = ProfileData.fromJson(jsonData);

          return ApiResponse<ProfileData>(data: me, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ProfileData>(statusCode: 401);
        }
        return ApiResponse<ProfileData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ProfileData>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemDeleteRespond>> deleteItem(String token, String id) {
    return http
        .delete(Uri.parse("${baseURL}items/$id"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = ItemDeleteRespond.fromJson(jsonData);

          return ApiResponse<ItemDeleteRespond>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemDeleteRespond>(statusCode: 401);
        }
        return ApiResponse<ItemDeleteRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemDeleteRespond>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getMyItems(String token, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}items/myItems?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final myItems = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: myItems, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(requestStatus: true, statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getItemsByUser(
      String id, String token, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}users/$id/items?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final myItems = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: myItems, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(requestStatus: true, statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getMyFavorite(String token, int currentPage) {
    return http
        .get(
            Uri.parse(
                "${baseURL}favorites?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<FavoriteRequest>> postFavorite(String token, String id) {
    return http
        .post(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 201) {
          final jsonData = json.decode(data.body);

          final fav = FavoriteRequest.fromJson(jsonData);

          return ApiResponse<FavoriteRequest>(data: fav, statusCode: 201);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRequest>(statusCode: 401);
        }
        return ApiResponse<FavoriteRequest>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRequest>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<FavoriteRemove>> deleteFavorite(String token, String id) {
    return http
        .delete(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final fav = FavoriteRemove.fromJson(jsonData);

          return ApiResponse<FavoriteRemove>(data: fav, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRemove>(statusCode: 401);
        }
        return ApiResponse<FavoriteRemove>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRemove>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<CityObj>> getCities(String localLang) {
    return http
        .get(Uri.parse("${baseURL}cities?per_page=100"),
            headers: headers(languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final city = CityObj.fromJson(jsonData);

          return ApiResponse<CityObj>(data: city, statusCode: 200);
        }
        return ApiResponse<CityObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<CityObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<DistrictObj>> getDistricts(String id, String localLang) {
    return http
        .get(Uri.parse("${baseURL}cities/$id/districts?per_page=300"),
            headers: headers(languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final districts = DistrictObj.fromJson(jsonData);

          return ApiResponse<DistrictObj>(data: districts, statusCode: 200);
        }
        return ApiResponse<DistrictObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<DistrictObj>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getRelatedCompanyItems(
      String token, String companyId) {
    return http
        .get(Uri.parse("${baseURL}users/$companyId/items"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getRelatedItems(String token, String itemId) {
    return http
        .get(Uri.parse("${baseURL}items/$itemId/related"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemData>> getItemId(String token, String itemId) {
    return http
        .get(Uri.parse("${baseURL}items/$itemId"),
            headers: headers(token: token))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemData.fromJson(jsonData);

          return ApiResponse<ItemData>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemData>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ProfileData>> getCompanyId(String companyId) {
    print("url: ${"${baseURL}users/$companyId"}");
    return http
        .get(Uri.parse("${baseURL}users/$companyId"))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ProfileData.fromJson(jsonData);

          return ApiResponse<ProfileData>(data: list, statusCode: 200);
        }
        return ApiResponse<ProfileData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ProfileData>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<StaticContentObj>> getStaticContent(
      String name, String local) {
    return http
        .get(Uri.parse("${baseURL}staticContents?name=$name"),
            headers: headers(languageKey: local))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final obj = StaticContentObj.fromJson(jsonData);

          return ApiResponse<StaticContentObj>(data: obj, statusCode: 200);
        } else if (data.statusCode == 500) {
          final jsonData = json.decode(data.body);

          final obj = StaticContentObj.fromJson(jsonData);

          return ApiResponse<StaticContentObj>(data: obj, statusCode: 200);
        }
        return ApiResponse<StaticContentObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<StaticContentObj>(
          requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getHotDeals(
      String token, int currentPage, String localLang) {
    return http
        .get(Uri.parse("${baseURL}deals?per_page=$perPage&page=$currentPage"),
            headers: headers(token: token, languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getLatestDeals(
      String token, int currentPage, String localLang,
      {String search = ""}) {
    return http
        .get(
            Uri.parse(
                "${baseURL}items?per_page=$perPage&page=$currentPage&title=$search"),
            headers: headers(token: token, languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<ItemObj>> getSearch(
      String token, int currentPage, String localLang,
      {String search = ""}) {
    return http
        .get(
        Uri.parse(
            "${baseURL}search/items?per_page=$perPage&page=$currentPage&search=$search"),
        headers: headers(token: token, languageKey: localLang))
        .timeout(timeOutDuration)
        .then(
          (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: list, statusCode: 200);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
          (s) =>
          ApiResponse<ItemObj>(requestStatus: true, errorMessage: noInternet),
    );
  }

  Future<ApiResponse<UpdateUser>> deleteMe(String phone, String token) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseURL}users/requestDeleteAccount"));

    request.fields['msisdn'] = phone;

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));

          return ApiResponse<UpdateUser>(data: register, statusCode: 200);
        } else if (data.statusCode == 422) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 422, errorMessage: register.message);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 403, errorMessage: register.message);
        } else if (data.statusCode == 401) {
          final respStr = await data.stream.bytesToString();

          final register = UpdateUser.json(jsonDecode(respStr));
          return ApiResponse<UpdateUser>(
              statusCode: 401, errorMessage: register.message);
        }

        return ApiResponse<UpdateUser>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<UpdateUser>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  // Config
  Future<ApiResponse<Config>> getConfig(String buildNo, String platform) {
    return http
        .get(Uri.parse(
            '${baseURL}boot?buildNumber=$buildNo&platformType=$platform'))
        .timeout(timeOutDuration)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        Config home = Config.fromJson(jsonData);

        return ApiResponse<Config>(data: home, statusCode: 200);
      }
      return ApiResponse<Config>(
          requestStatus: true, errorMessage: "API Communication Down");
    }).catchError((s) => ApiResponse<Config>(
            requestStatus: true, errorMessage: "API Communication Down"));
  }
}
