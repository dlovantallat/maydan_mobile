import 'dart:convert';
import 'package:http/http.dart' as http;

import '../common/model/category.dart';
import '../common/model/item.dart';
import '../common/model/login.dart';
import '../screens/profile/profile.dart';
import '../screens/register/register.dart';
import 'api_response.dart';

class MaydanServices {
  final String baseURL = "https://api.maydan.farm/api/mobile/";
  static const int timeOutInSecond = 15;

  Map<String, String> headers({String token = ''}) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'app-language': 'en',
    };
  }

  Future<ApiResponse<CategoryList>> getCategories() {
    return http
        .get(Uri.parse("${baseURL}categories"), headers: headers())
        .timeout(const Duration(seconds: timeOutInSecond))
        .then(
      (data) {
        if (data.statusCode == 200) {
          final jsonData = json.decode(data.body);

          final list = CategoryList.getList(jsonData);

          return ApiResponse<CategoryList>(data: list);
        }
        return ApiResponse<CategoryList>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<CategoryList>(
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

  Future<ApiResponse<ItemObj>> getItems(String subCategoryId) {
    return http
        .get(Uri.parse("${baseURL}subcategories/$subCategoryId/items"))
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

  Future<ApiResponse<LoginData>> login(String phoneNumber, String password) {
    var request = http.MultipartRequest('POST', Uri.parse("${baseURL}login"));

    request.fields['msisdn'] = phoneNumber;
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

  Future<ApiResponse<OtpRespond>> requestPinCode(String phoneNumber) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}requestPincode"));

    request.fields['msisdn'] = phoneNumber;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 200) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login);
        } else if (data.statusCode == 403) {
          final respStr = await data.stream.bytesToString();

          final login = OtpRespond.json(jsonDecode(respStr));

          return ApiResponse<OtpRespond>(data: login, statusCode: 403);
        }

        return ApiResponse<OtpRespond>(
            requestStatus: true, errorMessage: "API Communication Down");
      },
    ).catchError(
      (s) => ApiResponse<OtpRespond>(
          requestStatus: true, errorMessage: s.toString()),
    );
  }

  Future<ApiResponse<RegisterModel>> register(
      String name, String email, String phoneNumber, String password) {
    var request =
        http.MultipartRequest('POST', Uri.parse("${baseURL}register"));

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['msisdn'] = phoneNumber;

    request.headers.addAll(headers());

    return request.send().then(
      (data) async {
        if (data.statusCode == 201) {
          final respStr = await data.stream.bytesToString();

          final register = RegisterModel.json(jsonDecode(respStr));

          return ApiResponse<RegisterModel>(data: register);
        } else if (data.statusCode == 422) {
          return ApiResponse<RegisterModel>(statusCode: 422);
        }
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
}
