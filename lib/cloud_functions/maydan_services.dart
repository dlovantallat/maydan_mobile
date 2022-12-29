import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maydan/screens/home/home.dart';
import 'package:maydan/screens/my_ads/my_items_obj.dart';

import '../common/model/category.dart';
import '../common/model/item.dart';
import '../common/model/login.dart';
import '../screens/favorite/favorite_obj.dart';
import '../screens/profile/profile.dart';
import '../screens/register/register.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "https://apimaydan.tornet.co/api/mobile/";
  static const int timeOutInSecond = 15;

  Map<String, String> headers({String token = ''}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'app-language': 'en',
    };
  }

  Future<ApiResponse<HomeObj>> getHome(String token) {
    return http
        .get(Uri.parse("${baseURL}home"), headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
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
      (s) => ApiResponse<HomeObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<CategoryObj>> getCategories() {
    return http
        .get(Uri.parse("${baseURL}categories"), headers: headers())
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CategoryObj.fromJson(jsonData);

          return ApiResponse<CategoryObj>(data: list);
        }
        return ApiResponse<CategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CategoryObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<SubCategoryObj>> getSubCategories(String categoryId) {
    return http
        .get(Uri.parse("${baseURL}categories/$categoryId/subcategories"),
            headers: headers())
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = SubCategoryObj.fromJson(jsonData);

          return ApiResponse<SubCategoryObj>(data: list);
        }
        return ApiResponse<SubCategoryObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<SubCategoryObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getItems(String token, String subCategoryId) {
    return http
        .get(Uri.parse("${baseURL}subcategories/$subCategoryId/items"),
            headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
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
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemRespond>> postItem(String token) {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}items"));
    request.fields['title'] = jsonEncode({"en": "eee"});
    request.fields['subcategory_id'] = "97edfeb0-f3a9-4cfe-8a15-3e4f14504407";
    request.fields['user_address_id'] = "98023c79-f1b0-4b2a-aee7-19445803c5ef";
    request.fields['description'] = jsonEncode({"en": "eee"});

    request.headers.addAll(headers(token: token));

    return request.send().then(
      (data) async {
        print("codeee : ${data.statusCode}");
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = ItemRespond.json(jsonDecode(respStr));

          return ApiResponse<ItemRespond>(data: register, statusCode: 201);
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
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}requestPincode"));

    request.fields['msisdn'] = "964$phoneNumber";
    request.fields['usertype'] = !isPersonal ? "P" : "C";

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = RequestOtpRespond.json(jsonDecode(respStr));

          return ApiResponse<RequestOtpRespond>(data: login);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = RequestOtpRespond.json(jsonDecode(respStr));

          return ApiResponse<RequestOtpRespond>(data: login, statusCode: 403);
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

  Future<ApiResponse<RegisterModel>> register(String name, String email,
      String token, String phoneNumber, String password, bool isPersonal) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}register"));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['token'] = token;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['msisdn'] = phoneNumber;

    if (isPersonal) {
      request.fields['category_id'] = "9808a274-5aba-4f93-9ecd-29ef2c66d60e";
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

        print(data.statusCode);

        return ApiResponse<RegisterModel>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<RegisterModel>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<ProfileData>> getMe(String token) {
    return http
        .get(Uri.parse("${baseURL}users"), headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final profile = ProfileData.fromJson(jsonData);

          return ApiResponse<ProfileData>(data: profile);
        } else if (data.statusCode == 401) {
          return ApiResponse<ProfileData>(statusCode: 401);
        }
        return ApiResponse<ProfileData>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ProfileData>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getMyItems(String token) {
    return http
        .get(Uri.parse("${baseURL}items/myItems"),
            headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final profile = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: profile);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<ItemObj>> getMyFavorite(String token) {
    return http
        .get(Uri.parse("${baseURL}favorites"), headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final profile = ItemObj.fromJson(jsonData);

          return ApiResponse<ItemObj>(data: profile);
        } else if (data.statusCode == 401) {
          return ApiResponse<ItemObj>(statusCode: 401);
        }
        return ApiResponse<ItemObj>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<ItemObj>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<FavoriteRequest>> postFavorite(String token, String id) {
    return http
        .post(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 201) {
          final jsonData = json.decode(data.body);

          final profile = FavoriteRequest.fromJson(jsonData);

          return ApiResponse<FavoriteRequest>(data: profile, statusCode: 201);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRequest>(statusCode: 401);
        }
        return ApiResponse<FavoriteRequest>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRequest>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }

  Future<ApiResponse<FavoriteRemove>> deleteFavorite(String token, String id) {
    return http
        .delete(Uri.parse("${baseURL}items/$id/favorite"),
            headers: headers(token: token))
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final profile = FavoriteRemove.fromJson(jsonData);

          return ApiResponse<FavoriteRemove>(data: profile, statusCode: 200);
        } else if (data.statusCode == 401) {
          return ApiResponse<FavoriteRemove>(statusCode: 401);
        }
        return ApiResponse<FavoriteRemove>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<FavoriteRemove>(
          requestStatus: true,
          errorMessage: s.toString() == "Connection failed"
              ? " No Internet, Please check your internet connection."
              : "API Down we are working to get things back to normal. Please have a patient"),
    );
  }
}
